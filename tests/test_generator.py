from pathlib import Path

import pyarrow.parquet as pq

from generator.generate import Volumes, generate
from loader.load import ARROW_TO_TRINO


def _rows(root: Path, source: str, table: str) -> list[dict]:
    return pq.read_table(root / source / table / "part-0.parquet").to_pylist()


def test_secondary_feeds_are_reproducible_and_join_to_core_orders(tmp_path: Path) -> None:
    first = tmp_path / "first"
    second = tmp_path / "second"
    volumes = Volumes(customers=20, merchants=5, orders=100)
    generate(first, volumes, seed=42)
    generate(second, volumes, seed=42)

    files = sorted(first.glob("*/*/part-0.parquet"))
    assert len(files) == 36
    for path in files:
        assert path.read_bytes() == (second / path.relative_to(first)).read_bytes()
        assert all(field.type in ARROW_TO_TRINO for field in pq.read_schema(path))

    orders = {row["id"] for row in _rows(first, "shop", "orders")}
    payments = {row["id"] for row in _rows(first, "psp", "payments")}
    invoices = _rows(first, "billing", "invoices")
    shipments = _rows(first, "fulfillment", "shipments")
    payouts = _rows(first, "psp", "payouts")
    assert invoices and shipments and payouts
    assert {row["order_id"] for row in invoices} <= orders
    assert {row["order_id"] for row in shipments} <= orders
    assert {row["payment_id"] for row in payouts} <= payments

    merchant_by_order = {row["id"]: row["merchant_id"] for row in _rows(first, "shop", "orders")}
    merchant_by_promotion = {row["id"]: row["merchant_id"] for row in _rows(first, "shop", "promotions")}
    discounts = _rows(first, "shop", "order_discounts")
    assert discounts
    assert all(
        merchant_by_order[row["order_id"]] == merchant_by_promotion[row["promotion_id"]]
        for row in discounts
    )
