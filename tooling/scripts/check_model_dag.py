"""Reject source and intermediate models that do not feed another owned model."""

from __future__ import annotations

import json
import sys
from pathlib import Path


def unused_models(manifest: dict, project: str) -> list[tuple[str, str]]:
    nodes = manifest["nodes"]
    owned_models = {
        unique_id: node
        for unique_id, node in nodes.items()
        if node.get("package_name") == project and node.get("resource_type") == "model"
    }
    dangling = []
    for unique_id, node in owned_models.items():
        path = node["original_file_path"]
        if not path.startswith(("models/staging/", "models/intermediate/")):
            continue
        children = manifest["child_map"].get(unique_id, [])
        if not any(child in owned_models for child in children):
            dangling.append((node["name"], path))
    return sorted(dangling)


def main(argv: list[str]) -> int:
    if len(argv) != 2:
        print("usage: check_model_dag.py <manifest.json> <project>", file=sys.stderr)
        return 2
    path, project = argv
    dangling = unused_models(json.loads(Path(path).read_text()), project)
    for name, model_path in dangling:
        print(f"{project}: {name} ({model_path}) has no downstream model")
    print(f"{project}: {len(dangling)} unused staging/intermediate model(s)")
    return 1 if dangling else 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
