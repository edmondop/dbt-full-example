"""Turn `dbt ls --output json --output-keys name version` lines into
`<project>.<model>[.v<N>]+` selectors for a downstream project, where
dbt-loom injects upstream models under exactly those names."""

import json
import sys

project = sys.argv[1]
selectors = []
for line in sys.stdin:
    if not line.startswith("{"):
        continue
    node = json.loads(line)
    version = f".v{node['version']}" if node.get("version") is not None else ""
    selectors.append(f"{project}.{node['name']}{version}+")
print(" ".join(selectors))
