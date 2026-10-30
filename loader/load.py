"""Load generated landing Parquet into the raw layer of a target engine.

The raw layer is what dbt declares as sources. It lives outside the dbt-managed
catalog so ``dbt build`` never drops or rewrites it:

- ``duckdb``: tables in ``data/raw.duckdb`` (schemas ``shop``, ``psp``, ``ecb``),
  which the dbt profile attaches as database ``raw``.
- ``trino``: Parquet uploaded to ``s3://raw/<source>/<table>/`` on Garage and
  registered as external tables in the Hive catalog ``raw`` (file metastore).
  The files stay in the bucket; dropping a table only removes its metadata.
"""

from __future__ import annotations

import argparse
import os
from pathlib import Path

import pyarrow as pa
import pyarrow.parquet as pq

REPO_ROOT = Path(__file__).resolve().parent.parent
LANDING = REPO_ROOT / "data" / "landing"

ARROW_TO_TRINO = {
    pa.date32(): "date",
    pa.int32(): "integer",
    pa.int64(): "bigint",
    pa.string(): "varchar",
    pa.timestamp("us"): "timestamp(6)",
}


def landing_tables() -> list[tuple[str, str, Path]]:
    return sorted(
        (path.parent.parent.name, path.parent.name, path)
        for path in LANDING.glob("*/*/part-0.parquet")
    )


def load_duckdb(database: Path) -> None:
    import duckdb

    database.parent.mkdir(parents=True, exist_ok=True)
    with duckdb.connect(str(database)) as con:
        for source, table, path in landing_tables():
            con.execute(f"create schema if not exists {source}")
            con.execute(f"create or replace table {source}.{table} as select * from read_parquet(?)", [str(path)])
            (rows,) = con.execute(f"select count(*) from {source}.{table}").fetchone()
            print(f"duckdb raw.{source}.{table}: {rows} rows")


def load_trino(host: str, port: int) -> None:
    import trino
    from pyarrow import fs

    s3 = fs.S3FileSystem(
        access_key=os.environ["S3_ACCESS_KEY"],
        secret_key=os.environ["S3_SECRET_KEY"],
        endpoint_override=os.environ.get("S3_ENDPOINT", "http://localhost:3900"),
        region=os.environ.get("S3_REGION", "garage"),
        scheme="http",
        force_virtual_addressing=False,
    )
    cur = trino.dbapi.connect(host=host, port=port, user="loader", catalog="raw").cursor()

    def run(sql: str) -> list:
        cur.execute(sql)
        return cur.fetchall()

    for source, table, path in landing_tables():
        prefix = f"raw/{source}/{table}"
        fs.copy_files(str(path), f"{prefix}/part-0.parquet", destination_filesystem=s3)
        columns = ",\n  ".join(
            f'"{field.name}" {ARROW_TO_TRINO[field.type]}' for field in pq.read_schema(path)
        )
        run(f"create schema if not exists raw.{source} with (location = 's3://raw/{source}/')")
        # Recreate so schema changes in the generator are picked up; the data files are untouched.
        run(f"drop table if exists raw.{source}.{table}")
        run(
            f"create table raw.{source}.{table} (\n  {columns}\n) "
            f"with (external_location = 's3://{prefix}/', format = 'PARQUET')"
        )
        (rows,) = run(f"select count(*) from raw.{source}.{table}")[0]
        print(f"trino raw.{source}.{table}: {rows} rows")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("target", choices=["duckdb", "trino"])
    parser.add_argument("--duckdb-path", type=Path, default=REPO_ROOT / "data" / "raw.duckdb")
    parser.add_argument("--trino-host", default=os.environ.get("TRINO_HOST", "localhost"))
    parser.add_argument("--trino-port", type=int, default=int(os.environ.get("TRINO_PORT", "8080")))
    args = parser.parse_args()
    if not landing_tables():
        raise SystemExit(f"no landing data under {LANDING}; run the generator first")
    if args.target == "duckdb":
        load_duckdb(args.duckdb_path)
    else:
        load_trino(args.trino_host, args.trino_port)


if __name__ == "__main__":
    main()
