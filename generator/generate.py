"""Deterministic synthetic landing data for the marketplace example.

Writes one Parquet file per raw table under ``data/landing/<source>/<table>/``:

- ``shop``: the marketplace application database, including catalog and orders
- ``psp``: a Stripe-like payment service provider export, with
  lowercase currency codes, epoch-second timestamps, amounts in minor units, and
  ``_loaded_at`` lagging ``created`` so incremental models must handle late arrivals
- ``reference``: the real ECB rates (wide, string-typed, ``N/A`` for missing),
  copied from ``generator/reference``, plus currency and calendar metadata
- ``ecb``: the same rate extract retained for baseline builds in slim CI
- ``fulfillment``, ``billing`` and ``marketing``: connected marketplace feeds

Running it twice produces byte-identical data: every random draw comes from one seeded RNG.
"""

from __future__ import annotations

import argparse
import csv
import random
from dataclasses import dataclass
from datetime import UTC, date, datetime, timedelta
from pathlib import Path

import pyarrow as pa
import pyarrow.parquet as pq

REPO_ROOT = Path(__file__).resolve().parent.parent
ECB_REFERENCE = REPO_ROOT / "generator" / "reference" / "ecb_eurofxref_2024_2025.csv"

START = date(2024, 1, 1)
END = date(2025, 12, 31)

# ISO 4217 minor-unit exponents; JPY has no minor unit.
MERCHANT_MARKETS = [
    ("DE", "EUR", "Europe/Berlin"),
    ("FR", "EUR", "Europe/Paris"),
    ("GB", "GBP", "Europe/London"),
    ("US", "USD", "America/New_York"),
    ("JP", "JPY", "Asia/Tokyo"),
]
PRICE_RANGE_MINOR = {"EUR": (500, 25_000), "GBP": (500, 20_000), "USD": (500, 30_000), "JPY": (800, 40_000)}
REFUND_REASONS = ["requested_by_customer", "duplicate", "fraudulent"]


@dataclass(frozen=True)
class Volumes:
    customers: int
    merchants: int
    orders: int


def _ts(day: date, rng: random.Random) -> datetime:
    return datetime(day.year, day.month, day.day, tzinfo=UTC) + timedelta(seconds=rng.randrange(86_400))


def _random_day(rng: random.Random, start: date = START) -> date:
    return start + timedelta(days=rng.randrange((END - start).days + 1))


def _write(out: Path, source: str, table: str, rows: list[dict], schema: pa.Schema) -> None:
    target = out / source / table
    target.mkdir(parents=True, exist_ok=True)
    # Raw exports carry naive UTC timestamps; generation keeps them tz-aware so
    # epoch conversion is unambiguous, and the tz is dropped only at write time.
    naive = [
        {k: v.astimezone(UTC).replace(tzinfo=None) if isinstance(v, datetime) else v for k, v in row.items()}
        for row in rows
    ]
    pq.write_table(pa.Table.from_pylist(naive, schema=schema), target / "part-0.parquet")
    print(f"{source}.{table}: {len(rows)} rows")


def generate(out: Path, volumes: Volumes, seed: int) -> None:
    rng = random.Random(seed)

    customers = []
    for i in range(1, volumes.customers + 1):
        created = _ts(_random_day(rng), rng)
        customers.append({
            "id": i,
            "email": f"customer{i}@example.com",
            "country": rng.choice(MERCHANT_MARKETS)[0],
            "created_at": created,
            "updated_at": created + timedelta(days=rng.randrange(0, 60)),
        })

    merchants = []
    for i in range(1, volumes.merchants + 1):
        country, currency, tz = MERCHANT_MARKETS[(i - 1) % len(MERCHANT_MARKETS)]
        merchants.append({
            "id": i,
            "name": f"Merchant {i:03d}",
            "country": country,
            "currency": currency,
            "timezone": tz,
            "created_at": _ts(START, rng),
        })

    orders, order_items, payments, refunds = [], [], [], []
    item_id = payment_id = refund_id = 0
    for order_id in range(1, volumes.orders + 1):
        customer = rng.choice(customers)
        merchant = rng.choice(merchants)
        ordered_at = _ts(_random_day(rng, customer["created_at"].date()), rng)
        status = rng.choices(["completed", "cancelled", "pending"], weights=[90, 7, 3])[0]
        orders.append({
            "id": order_id,
            "customer_id": customer["id"],
            "merchant_id": merchant["id"],
            "currency": merchant["currency"],
            "status": status,
            "ordered_at": ordered_at,
            "updated_at": ordered_at + timedelta(minutes=rng.randrange(0, 2_880)),
        })

        lo, hi = PRICE_RANGE_MINOR[merchant["currency"]]
        total_minor = 0
        for _ in range(rng.randint(1, 4)):
            item_id += 1
            quantity = rng.randint(1, 3)
            unit_price = rng.randrange(lo, hi)
            total_minor += quantity * unit_price
            order_items.append({
                "id": item_id,
                "order_id": order_id,
                "sku": f"SKU-{rng.randrange(1, 500):04d}",
                "quantity": quantity,
                "unit_price_minor": unit_price,
            })

        if status == "pending":
            continue
        # A failed attempt precedes some successful payments, as PSP retries do.
        attempts = ["failed", "succeeded"] if rng.random() < 0.05 else ["succeeded"]
        if status == "cancelled":
            attempts = ["failed"]
        for attempt in attempts:
            payment_id += 1
            created = ordered_at + timedelta(seconds=rng.randrange(5, 900))
            # ~8% of events land in the export days later: late-arriving data.
            lag = timedelta(days=rng.randint(1, 5)) if rng.random() < 0.08 else timedelta(minutes=rng.randrange(1, 90))
            payments.append({
                "id": f"py_{payment_id:08d}",
                "metadata_order_id": str(order_id),
                "amount": total_minor,
                "currency": merchant["currency"].lower(),
                "status": attempt,
                "created": int(created.timestamp()),
                "_loaded_at": created + lag,
            })
            if attempt == "succeeded" and rng.random() < 0.06:
                refund_id += 1
                refund_created = created + timedelta(days=rng.randint(1, 30), seconds=rng.randrange(86_400))
                partial = rng.random() < 0.4
                refunds.append({
                    "id": f"re_{refund_id:08d}",
                    "payment_id": f"py_{payment_id:08d}",
                    "amount": total_minor // 2 if partial else total_minor,
                    "currency": merchant["currency"].lower(),
                    "reason": rng.choice(REFUND_REASONS),
                    "status": "succeeded",
                    "created": int(refund_created.timestamp()),
                    "_loaded_at": refund_created + timedelta(minutes=rng.randrange(1, 4_000)),
                })

    ts = pa.timestamp("us")
    _write(out, "shop", "customers", customers, pa.schema([
        ("id", pa.int64()), ("email", pa.string()), ("country", pa.string()),
        ("created_at", ts), ("updated_at", ts),
    ]))
    _write(out, "shop", "merchants", merchants, pa.schema([
        ("id", pa.int64()), ("name", pa.string()), ("country", pa.string()),
        ("currency", pa.string()), ("timezone", pa.string()), ("created_at", ts),
    ]))
    _write(out, "shop", "orders", orders, pa.schema([
        ("id", pa.int64()), ("customer_id", pa.int64()), ("merchant_id", pa.int64()),
        ("currency", pa.string()), ("status", pa.string()), ("ordered_at", ts), ("updated_at", ts),
    ]))
    _write(out, "shop", "order_items", order_items, pa.schema([
        ("id", pa.int64()), ("order_id", pa.int64()), ("sku", pa.string()),
        ("quantity", pa.int32()), ("unit_price_minor", pa.int64()),
    ]))
    _write(out, "psp", "payments", payments, pa.schema([
        ("id", pa.string()), ("metadata_order_id", pa.string()), ("amount", pa.int64()),
        ("currency", pa.string()), ("status", pa.string()), ("created", pa.int64()), ("_loaded_at", ts),
    ]))
    _write(out, "psp", "refunds", refunds, pa.schema([
        ("id", pa.string()), ("payment_id", pa.string()), ("amount", pa.int64()), ("currency", pa.string()),
        ("reason", pa.string()), ("status", pa.string()), ("created", pa.int64()), ("_loaded_at", ts),
    ]))

    with ECB_REFERENCE.open() as f:
        ecb_rows = [{k.lower(): v for k, v in row.items()} for row in csv.DictReader(f)]
    # Slim CI builds the main-branch baseline against this same raw catalog.
    # Keep its ECB source available while the current graph imports the rates
    # through reference.fx_rates.
    _write(out, "ecb", "eurofxref", ecb_rows, pa.schema([
        ("date", pa.string()), ("usd", pa.string()), ("jpy", pa.string()), ("gbp", pa.string()),
    ]))
    _generate_extended(out, rng, customers, merchants, orders, order_items, payments, refunds, ecb_rows)


def _generate_extended(
    out: Path,
    rng: random.Random,
    customers: list[dict],
    merchants: list[dict],
    orders: list[dict],
    order_items: list[dict],
    payments: list[dict],
    refunds: list[dict],
    ecb_rows: list[dict],
) -> None:
    """Connected secondary feeds; all foreign keys refer to the core dataset."""
    ts = pa.timestamp("us")
    i64 = pa.int64()
    string = pa.string()
    day = pa.date32()
    categories = [{"id": i, "name": name} for i, name in enumerate(
        ["home", "electronics", "books", "clothing", "outdoors"], 1
    )]
    skus = sorted({item["sku"] for item in order_items})
    products = [
        {"sku": sku, "category_id": (index % len(categories)) + 1, "list_price_minor": 500 + index * 37}
        for index, sku in enumerate(skus)
    ]
    warehouses = [{"id": i, "country": market[0]} for i, market in enumerate(MERCHANT_MARKETS, 1)]
    inventory = [
        {"sku": product["sku"], "warehouse_id": (index % len(warehouses)) + 1,
         "on_hand": rng.randrange(0, 200)}
        for index, product in enumerate(products)
    ]
    promotions = [
        {"id": merchant["id"], "merchant_id": merchant["id"],
         "discount_percent": 5 + (merchant["id"] % 4) * 5}
        for merchant in merchants
    ]
    order_discounts = [
        {"id": order["id"], "order_id": order["id"],
         "promotion_id": order["merchant_id"],
         "amount_minor": 100 + (order["id"] % 5) * 50}
        for order in orders if order["status"] == "completed" and order["id"] % 10 == 0
    ]
    _write(out, "shop", "categories", categories, pa.schema([("id", i64), ("name", string)]))
    _write(out, "shop", "products", products, pa.schema([
        ("sku", string), ("category_id", i64), ("list_price_minor", i64),
    ]))
    _write(out, "shop", "inventory", inventory, pa.schema([
        ("sku", string), ("warehouse_id", i64), ("on_hand", i64),
    ]))
    _write(out, "shop", "promotions", promotions, pa.schema([
        ("id", i64), ("merchant_id", i64), ("discount_percent", i64),
    ]))
    _write(out, "shop", "order_discounts", order_discounts, pa.schema([
        ("id", i64), ("order_id", i64), ("promotion_id", i64), ("amount_minor", i64),
    ]))

    payment_order = {payment["id"]: int(payment["metadata_order_id"]) for payment in payments}
    succeeded = [payment for payment in payments if payment["status"] == "succeeded"]
    fees = [
        {"payment_id": payment["id"], "fee_minor": max(1, payment["amount"] * 3 // 100)}
        for payment in succeeded
    ]
    disputes = [
        {"id": f"dp_{index:08d}", "payment_id": payment["id"],
         "amount_minor": payment["amount"], "status": "open" if index % 3 else "won"}
        for index, payment in enumerate(succeeded[::97], 1)
    ]
    balance = [
        {"id": f"bt_{index:08d}", "payment_id": payment["id"],
         "net_minor": payment["amount"] - fees[index - 1]["fee_minor"],
         "available_at": datetime.fromtimestamp(payment["created"], UTC) + timedelta(days=2)}
        for index, payment in enumerate(succeeded, 1)
    ]
    payouts = [
        {"id": f"po_{index:08d}", "merchant_id": order["merchant_id"],
         "payment_id": payment["id"], "paid_at": datetime.fromtimestamp(payment["created"], UTC) + timedelta(days=3)}
        for index, payment in enumerate(succeeded, 1)
        for order in [orders[payment_order[payment["id"]] - 1]]
    ]
    _write(out, "psp", "fees", fees, pa.schema([("payment_id", string), ("fee_minor", i64)]))
    _write(out, "psp", "disputes", disputes, pa.schema([
        ("id", string), ("payment_id", string), ("amount_minor", i64), ("status", string),
    ]))
    _write(out, "psp", "balance_transactions", balance, pa.schema([
        ("id", string), ("payment_id", string), ("net_minor", i64), ("available_at", ts),
    ]))
    _write(out, "psp", "payouts", payouts, pa.schema([
        ("id", string), ("merchant_id", i64), ("payment_id", string), ("paid_at", ts),
    ]))

    carriers = [{"id": 1, "name": "Parcel North"}, {"id": 2, "name": "Parcel South"}]
    shipped = [order for order in orders if order["status"] == "completed" and order["id"] % 2 == 0]
    shipments = [
        {"id": order["id"], "order_id": order["id"],
         "warehouse_id": order["merchant_id"] % len(warehouses) + 1,
         "carrier_id": order["id"] % len(carriers) + 1,
         "shipped_at": order["ordered_at"] + timedelta(days=1)}
        for order in shipped
    ]
    labels = [{"shipment_id": row["id"], "tracking_code": f"TRK{row['id']:09d}"} for row in shipments]
    shipment_events = [
        {"shipment_id": row["id"], "status": status,
         "event_at": row["shipped_at"] + timedelta(days=offset)}
        for row in shipments
        for offset, status in [(0, "shipped"), (2 + row["id"] % 4, "delivered")]
    ]
    delivery_attempts = [
        {"shipment_id": row["id"], "attempt_at": row["shipped_at"] + timedelta(days=2),
         "outcome": "failed" if row["id"] % 11 == 0 else "delivered"}
        for row in shipments
    ]
    _write(out, "fulfillment", "warehouses", warehouses, pa.schema([("id", i64), ("country", string)]))
    _write(out, "fulfillment", "carriers", carriers, pa.schema([("id", i64), ("name", string)]))
    _write(out, "fulfillment", "shipments", shipments, pa.schema([
        ("id", i64), ("order_id", i64), ("warehouse_id", i64), ("carrier_id", i64), ("shipped_at", ts),
    ]))
    _write(out, "fulfillment", "shipping_labels", labels, pa.schema([
        ("shipment_id", i64), ("tracking_code", string),
    ]))
    _write(out, "fulfillment", "shipment_events", shipment_events, pa.schema([
        ("shipment_id", i64), ("status", string), ("event_at", ts),
    ]))
    _write(out, "fulfillment", "delivery_attempts", delivery_attempts, pa.schema([
        ("shipment_id", i64), ("attempt_at", ts), ("outcome", string),
    ]))

    currencies = [
        {"currency_code": code, "minor_units": 0 if code == "JPY" else 2}
        for code in ["EUR", "GBP", "USD", "JPY"]
    ]
    countries = [{"country_code": country, "currency_code": currency} for country, currency, _ in MERCHANT_MARKETS]
    calendar = [{"date_day": START + timedelta(days=offset)} for offset in range((END - START).days + 1)]
    holidays = [
        {"date_day": date(year, month, day_number), "label": label}
        for year in [2024, 2025]
        for month, day_number, label in [(1, 1, "new_year"), (12, 25, "winter_holiday")]
    ]
    _write(out, "reference", "fx_rates", ecb_rows, pa.schema([
        ("date", string), ("usd", string), ("jpy", string), ("gbp", string),
    ]))
    _write(out, "reference", "currencies", currencies, pa.schema([
        ("currency_code", string), ("minor_units", i64),
    ]))
    _write(out, "reference", "countries", countries, pa.schema([
        ("country_code", string), ("currency_code", string),
    ]))
    _write(out, "reference", "calendar", calendar, pa.schema([("date_day", day)]))
    _write(out, "reference", "holidays", holidays, pa.schema([
        ("date_day", day), ("label", string),
    ]))

    completed = [order for order in orders if order["status"] == "completed"]
    invoices = [
        {"id": order["id"], "order_id": order["id"], "issued_at": order["ordered_at"] + timedelta(days=1)}
        for order in completed
    ]
    completed_ids = {order["id"] for order in completed}
    invoice_lines = [
        {"id": item["id"], "invoice_id": item["order_id"], "amount_minor": item["quantity"] * item["unit_price_minor"]}
        for item in order_items if item["order_id"] in completed_ids
    ]
    credit_notes = [
        {"id": index, "invoice_id": payment_order[refund["payment_id"]],
         "amount_minor": refund["amount"]}
        for index, refund in enumerate(refunds, 1)
    ]
    tax_rates = [{"country_code": country, "rate_percent": rate} for country, rate in
                 [("DE", 19), ("FR", 20), ("GB", 20), ("US", 8), ("JP", 10)]]
    adjustments = [
        {"id": row["id"], "invoice_id": row["id"], "amount_minor": 50}
        for row in invoices if row["id"] % 113 == 0
    ]
    _write(out, "billing", "invoices", invoices, pa.schema([
        ("id", i64), ("order_id", i64), ("issued_at", ts),
    ]))
    _write(out, "billing", "invoice_lines", invoice_lines, pa.schema([
        ("id", i64), ("invoice_id", i64), ("amount_minor", i64),
    ]))
    _write(out, "billing", "credit_notes", credit_notes, pa.schema([
        ("id", i64), ("invoice_id", i64), ("amount_minor", i64),
    ]))
    _write(out, "billing", "tax_rates", tax_rates, pa.schema([
        ("country_code", string), ("rate_percent", i64),
    ]))
    _write(out, "billing", "adjustments", adjustments, pa.schema([
        ("id", i64), ("invoice_id", i64), ("amount_minor", i64),
    ]))

    campaigns = [{"id": i, "channel": ["search", "social", "email"][i % 3]} for i in range(1, 13)]
    impressions = [
        {"id": customer["id"], "customer_id": customer["id"],
         "campaign_id": customer["id"] % len(campaigns) + 1,
         "occurred_at": customer["created_at"] - timedelta(days=2)}
        for customer in customers
    ]
    clicks = [
        {"id": row["id"], "impression_id": row["id"], "customer_id": row["customer_id"],
         "occurred_at": row["occurred_at"] + timedelta(hours=1)}
        for row in impressions if row["id"] % 3 == 0
    ]
    email_sends = [
        {"id": customer["id"], "customer_id": customer["id"],
         "sent_at": customer["created_at"] + timedelta(days=7)}
        for customer in customers if customer["id"] % 4 == 0
    ]
    attribution = [
        {"customer_id": row["customer_id"], "campaign_id": row["campaign_id"],
         "attributed_at": row["occurred_at"]}
        for row in impressions
    ]
    _write(out, "marketing", "campaigns", campaigns, pa.schema([("id", i64), ("channel", string)]))
    _write(out, "marketing", "ad_impressions", impressions, pa.schema([
        ("id", i64), ("customer_id", i64), ("campaign_id", i64), ("occurred_at", ts),
    ]))
    _write(out, "marketing", "ad_clicks", clicks, pa.schema([
        ("id", i64), ("impression_id", i64), ("customer_id", i64), ("occurred_at", ts),
    ]))
    _write(out, "marketing", "email_sends", email_sends, pa.schema([
        ("id", i64), ("customer_id", i64), ("sent_at", ts),
    ]))
    _write(out, "marketing", "customer_attribution", attribution, pa.schema([
        ("customer_id", i64), ("campaign_id", i64), ("attributed_at", ts),
    ]))


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--out", type=Path, default=REPO_ROOT / "data" / "landing")
    parser.add_argument("--seed", type=int, default=42)
    parser.add_argument("--customers", type=int, default=2_000)
    parser.add_argument("--merchants", type=int, default=50)
    parser.add_argument("--orders", type=int, default=20_000)
    args = parser.parse_args()
    generate(args.out, Volumes(args.customers, args.merchants, args.orders), args.seed)


if __name__ == "__main__":
    main()
