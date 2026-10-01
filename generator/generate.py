"""Deterministic synthetic landing data for the marketplace example.

Writes one Parquet file per raw table under ``data/landing/<source>/<table>/``:

- ``shop``: the marketplace application database (customers, merchants, orders, order_items)
- ``psp``: a Stripe-like payment service provider export (payments, refunds), with
  lowercase currency codes, epoch-second timestamps, amounts in minor units, and
  ``_loaded_at`` lagging ``created`` so incremental models must handle late arrivals
- ``ecb``: the real ECB reference rates (wide, string-typed, ``N/A`` for missing),
  copied from ``generator/reference``

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
    _write(out, "ecb", "eurofxref", ecb_rows, pa.schema([
        ("date", pa.string()), ("usd", pa.string()), ("jpy", pa.string()), ("gbp", pa.string()),
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
