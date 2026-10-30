"""Enforce the repository's model naming and layout conventions.

Layout (per project):

    models/<layer>/<group>/<model>.sql
    models/<layer>/<group>/_<prefix>__<group>.yml              properties of every model in the folder
    models/<layer>/<group>/_<prefix>__<group>__unit_tests.yml  unit tests of models in the folder (optional)

Each model-bearing folder contains 5-15 SQL models. Staging groups by source
system; intermediate and marts group by transformation or reporting use case.

Names are segments joined by `__`; each segment is lower snake_case:

    layer       folder prefix   model name
    staging     stg             stg__<source>__<entity>[__<qualifier>]
    intermediate int            int__<domain>__<entity>[__<qualifier>]
    marts       marts           (fct|dim)__<entity>[__<qualifier>]   (+ `_v<N>` for versions)

For staging and intermediate the second segment must equal the folder: it is
the source or domain the model belongs to.
"""

from __future__ import annotations

import re
import sys
from dataclasses import dataclass
from pathlib import Path

import yaml

LAYERS = {
    "staging": ("stg", ("stg",)),
    "intermediate": ("int", ("int",)),
    "marts": ("marts", ("fct", "dim")),
}
SEGMENT = re.compile(r"^[a-z0-9]+(_[a-z0-9]+)*$")
WILDCARD_SELECT = re.compile(r"\bselect\s+(?:[a-z_][a-z0-9_]*\.)?\*", re.IGNORECASE)
VERSION_SUFFIX = re.compile(r"_v\d+$")
ROOT_YAML_ALLOWED = {"_groups.yml"}
MIN_MODELS_PER_FOLDER = 5
MAX_MODELS_PER_FOLDER = 15


@dataclass(frozen=True)
class Violation:
    path: Path
    message: str

    def __str__(self) -> str:
        return f"{self.path}: {self.message}"


def check_model_name(path: Path, layer: str, group: str) -> list[Violation]:
    _, allowed_types = LAYERS[layer]
    stem = VERSION_SUFFIX.sub("", path.stem) if layer == "marts" else path.stem
    segments = stem.split("__")
    problems = []
    if len(segments) < 2:
        problems.append(f"'{path.stem}' needs at least <type>__<name>")
    if any(not SEGMENT.match(segment) for segment in segments):
        problems.append(f"'{path.stem}' has an empty or non snake_case segment (use '__' only between segments)")
    if segments[0] not in allowed_types:
        problems.append(f"'{path.stem}' in {layer}/ must start with {' or '.join(t + '__' for t in allowed_types)}")
    elif layer != "marts" and len(segments) >= 2 and segments[1] != group:
        problems.append(f"'{path.stem}' lives in {layer}/{group}/ so its second segment must be '{group}'")
    return [Violation(path, p) for p in problems]


def _load_yaml(path: Path) -> dict:
    return yaml.safe_load(path.read_text()) or {}


def check_folder(folder: Path, layer: str) -> list[Violation]:
    prefix, _ = LAYERS[layer]
    group = folder.name
    properties_file = folder / f"_{prefix}__{group}.yml"
    unit_tests_file = folder / f"_{prefix}__{group}__unit_tests.yml"
    violations: list[Violation] = []
    for child in sorted(folder.iterdir()):
        if child.is_dir():
            violations.append(Violation(child, "models and YAML belong directly in the source or use-case folder"))

    models = sorted(folder.glob("*.sql"))
    if not MIN_MODELS_PER_FOLDER <= len(models) <= MAX_MODELS_PER_FOLDER:
        violations.append(
            Violation(
                folder,
                f"expected {MIN_MODELS_PER_FOLDER}-{MAX_MODELS_PER_FOLDER} SQL models, found {len(models)}",
            )
        )
    for model in models:
        violations += check_model_name(model, layer, group)
        if WILDCARD_SELECT.search(model.read_text()):
            violations.append(Violation(model, "use explicit projected columns instead of SELECT *"))

    if any(folder.iterdir()) and not properties_file.exists():
        violations.append(Violation(folder, f"missing properties file {properties_file.name}"))
        return violations

    declared: set[str] = set()
    for model in _load_yaml(properties_file).get("models", []):
        declared.add(model["name"])
        declared.update(f"{model['name']}_v{v['v']}" for v in model.get("versions", []))
    for model in models:
        if model.stem not in declared:
            violations.append(Violation(model, f"not declared in {properties_file.name}"))

    for yml in sorted(folder.glob("*.yml")):
        content = _load_yaml(yml)
        if yml == unit_tests_file:
            extra = set(content) - {"unit_tests"}
            if extra:
                violations.append(Violation(yml, f"unit test file must only contain unit_tests, found {sorted(extra)}"))
            for test in content.get("unit_tests", []):
                if test["model"] not in declared:
                    violations.append(Violation(yml, f"unit test '{test['name']}' targets a model outside this folder"))
        elif yml == properties_file:
            if "unit_tests" in content:
                violations.append(Violation(yml, f"move unit_tests to {unit_tests_file.name}"))
        else:
            violations.append(
                Violation(yml, f"unexpected file; use {properties_file.name} or {unit_tests_file.name}")
            )
    return violations


def check_project(models_dir: Path) -> list[Violation]:
    violations: list[Violation] = []
    for entry in sorted(models_dir.iterdir()):
        if entry.is_file():
            if entry.name not in ROOT_YAML_ALLOWED:
                violations.append(Violation(entry, "files belong in models/<layer>/<group>/"))
        elif entry.name not in LAYERS:
            violations.append(Violation(entry, f"unknown layer folder, expected one of {sorted(LAYERS)}"))
        else:
            for child in sorted(entry.iterdir()):
                if child.is_file():
                    violations.append(Violation(child, f"files belong in {entry.name}/<group>/, not {entry.name}/"))
                else:
                    violations += check_folder(child, entry.name)
    return violations


def main(argv: list[str]) -> int:
    roots = [Path(arg) for arg in argv] or sorted(Path("projects").glob("*/models"))
    violations = [v for root in roots for v in check_project(root)]
    for violation in violations:
        print(violation)
    print(f"checked {len(roots)} project(s): {len(violations)} violation(s)")
    return 1 if violations else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
