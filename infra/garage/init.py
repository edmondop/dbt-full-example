"""Idempotent bootstrap of the single-node Garage cluster via the v2 admin API.

Assigns the node a layout role, imports the fixed dev access key, and creates
the buckets the stack needs: `raw` (landing Parquet + Hive file metastore) and
`lakehouse` (Iceberg warehouse managed by Lakekeeper).
"""

import json
import os
import time
import urllib.error
import urllib.request

ADMIN = os.environ.get("GARAGE_ADMIN_URL", "http://garage:3903")
TOKEN = os.environ["GARAGE_ADMIN_TOKEN"]
ACCESS_KEY = os.environ["S3_ACCESS_KEY"]
SECRET_KEY = os.environ["S3_SECRET_KEY"]
BUCKETS = ("raw", "lakehouse")


def call(method: str, endpoint: str, body: dict | None = None) -> dict:
    req = urllib.request.Request(
        f"{ADMIN}/v2/{endpoint}",
        method=method,
        data=json.dumps(body).encode() if body is not None else None,
        headers={"Authorization": f"Bearer {TOKEN}", "Content-Type": "application/json"},
    )
    with urllib.request.urlopen(req, timeout=10) as resp:
        payload = resp.read()
    return json.loads(payload) if payload else {}


def wait_for_admin_api() -> dict:
    for _ in range(60):
        try:
            return call("GET", "GetClusterStatus")
        except (urllib.error.URLError, ConnectionError):
            time.sleep(1)
    raise SystemExit("Garage admin API did not become reachable")


def ensure_layout(status: dict) -> None:
    node = status["nodes"][0]
    if node.get("role"):
        return
    call("POST", "UpdateClusterLayout", {
        "roles": [{"id": node["id"], "zone": "local", "capacity": 10 * 1024**3, "tags": []}],
    })
    call("POST", "ApplyClusterLayout", {"version": status["layoutVersion"] + 1})


def ensure_key() -> None:
    try:
        call("GET", f"GetKeyInfo?id={ACCESS_KEY}")
    except urllib.error.HTTPError as err:
        if err.code not in (400, 404):
            raise
        call("POST", "ImportKey", {
            "accessKeyId": ACCESS_KEY, "secretAccessKey": SECRET_KEY, "name": "dbt-full-example",
        })


def ensure_bucket(alias: str) -> None:
    try:
        bucket = call("GET", f"GetBucketInfo?globalAlias={alias}")
    except urllib.error.HTTPError as err:
        if err.code not in (400, 404):
            raise
        bucket = call("POST", "CreateBucket", {"globalAlias": alias})
    call("POST", "AllowBucketKey", {
        "bucketId": bucket["id"],
        "accessKeyId": ACCESS_KEY,
        "permissions": {"read": True, "write": True, "owner": True},
    })


if __name__ == "__main__":
    ensure_layout(wait_for_admin_api())
    ensure_key()
    for name in BUCKETS:
        ensure_bucket(name)
    print("garage ready:", ", ".join(BUCKETS))
