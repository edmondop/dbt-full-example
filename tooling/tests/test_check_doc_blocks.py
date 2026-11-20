from pathlib import Path

import pytest

from scripts.check_doc_blocks import check


def write(root: Path, relative: str, content: str) -> None:
    path = root / relative
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content)


def block(name: str) -> str:
    return f"{{% docs {name} %}}\n{name}.\n{{% enddocs %}}\n"


def properties(*names: str) -> str:
    columns = "".join(f"      - name: {n}\n        description: '{{{{ doc(\"{n}\") }}}}'\n" for n in names)
    return f"models:\n  - name: m\n    columns:\n{columns}"


@pytest.fixture
def repo(tmp_path: Path) -> Path:
    write(tmp_path, "shared/docs/keys.md", block("order_id"))
    write(tmp_path, "platform/docs/fx.md", block("rate_to_reporting"))
    write(tmp_path, "finance/docs/billing.md", block("invoice_id"))
    write(tmp_path, "platform/models/_m.yml", properties("order_id", "rate_to_reporting"))
    write(tmp_path, "finance/models/_m.yml", properties("order_id", "invoice_id"))
    return tmp_path


def problems(repo: Path) -> list[str]:
    return check(repo / "shared/docs", [repo / "platform", repo / "finance"])


def test_blocks_in_their_owners_pass(repo: Path) -> None:
    assert problems(repo) == []


def test_shared_block_used_by_one_project_is_reported(repo: Path) -> None:
    write(repo, "shared/docs/billing.md", block("credit_note_id"))
    write(repo, "finance/models/_n.yml", properties("credit_note_id"))
    assert any("credit_note_id is referenced by ['finance'], move it to dbt/projects/finance/docs/" in p
               for p in problems(repo)), problems(repo)


def test_project_block_used_by_another_project_is_reported(repo: Path) -> None:
    write(repo, "finance/models/_n.yml", properties("rate_to_reporting"))
    found = problems(repo)
    assert any("rate_to_reporting is also referenced by ['finance']" in p for p in found), found
    assert "finance: doc('rate_to_reporting') has no block in finance/docs or " + str(repo / "shared/docs") in found


def test_unreferenced_project_block_is_reported(repo: Path) -> None:
    write(repo, "platform/docs/extra.md", block("warehouse_id"))
    assert any("warehouse_id is unreferenced" in p for p in problems(repo))


def test_project_block_shadowing_shared_block_is_reported(repo: Path) -> None:
    write(repo, "finance/docs/keys.md", block("order_id"))
    assert any("order_id shadows the shared block" in p for p in problems(repo))


def test_duplicate_block_is_reported(repo: Path) -> None:
    write(repo, "platform/docs/more.md", block("rate_to_reporting"))
    assert any("rate_to_reporting: defined more than once" in p for p in problems(repo))
