"""Keep each column doc block in the package or project that owns it.

    dbt/packages/marketplace_docs/docs/   blocks referenced by two or more projects
    dbt/projects/<project>/docs/          blocks referenced only by that project

dbt resolves `doc()` from the current project, then from installed packages.
dbt-loom imports platform's models but not its doc blocks, so a block that
two projects reference has to live in the package all of them install.
"""

from __future__ import annotations

import re
import sys
from collections import defaultdict
from pathlib import Path

DOC_REFERENCE = re.compile(r"""\{\{\s*doc\(\s*["'](\w+)["']\s*\)\s*\}\}""")
DOC_BLOCK = re.compile(r"\{%-?\s*docs\s+(\w+)\s*-?%\}")
SHARED_PACKAGE = Path("dbt/packages/marketplace_docs")


def defined_blocks(docs_dir: Path) -> dict[str, list[Path]]:
    blocks: dict[str, list[Path]] = defaultdict(list)
    for path in sorted(docs_dir.rglob("*.md")):
        for name in DOC_BLOCK.findall(path.read_text()):
            blocks[name].append(path)
    return blocks


def referenced_blocks(models_dir: Path) -> set[str]:
    return {name for path in models_dir.rglob("*.yml") for name in DOC_REFERENCE.findall(path.read_text())}


def check(shared_docs: Path, projects: list[Path]) -> list[str]:
    shared = defined_blocks(shared_docs)
    owned = {project.name: defined_blocks(project / "docs") for project in projects}
    references = {project.name: referenced_blocks(project / "models") for project in projects}
    users: dict[str, set[str]] = defaultdict(set)
    for project, names in references.items():
        for name in names:
            users[name].add(project)

    problems = []
    for blocks in [shared, *owned.values()]:
        for name, paths in sorted(blocks.items()):
            if len(paths) > 1:
                problems.append(f"{name}: defined more than once in {', '.join(map(str, paths))}")
    for name, paths in sorted(shared.items()):
        if len(users[name]) < 2:
            target = f"dbt/projects/{next(iter(users[name]))}/docs/" if users[name] else "nowhere; delete it"
            problems.append(f"{paths[0]}: {name} is referenced by {sorted(users[name])}, move it to {target}")
    for project, blocks in sorted(owned.items()):
        for name, paths in sorted(blocks.items()):
            if name in shared:
                problems.append(f"{paths[0]}: {name} shadows the shared block in {shared[name][0]}")
            elif users[name] != {project}:
                others = sorted(users[name] - {project})
                where = f"also referenced by {others}, move it to {shared_docs}" if others else "unreferenced"
                problems.append(f"{paths[0]}: {name} is {where}")
    for project, names in sorted(references.items()):
        for name in sorted(names - set(shared) - set(owned[project])):
            problems.append(f"{project}: doc('{name}') has no block in {project}/docs or {shared_docs}")
    return problems


def main(argv: list[str]) -> int:
    projects = [Path(arg) for arg in argv] or sorted(p for p in Path("dbt/projects").iterdir() if p.is_dir())
    problems = check(SHARED_PACKAGE / "docs", projects)
    for problem in problems:
        print(problem)
    print(f"checked {len(projects)} project(s): {len(problems)} doc block problem(s)")
    return 1 if problems else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
