from pathlib import Path

import pytest

from scripts.check_naming import check_project


def write(root: Path, relative: str, content: str = "") -> None:
    path = root / relative
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content)


@pytest.fixture
def models(tmp_path: Path) -> Path:
    root = tmp_path / "models"
    write(root, "_groups.yml", "groups: []\n")
    write(root, "staging/shop/stg__shop__orders.sql")
    write(root, "staging/shop/_stg__shop.yml", "models:\n  - name: stg__shop__orders\n")
    write(
        root,
        "staging/shop/_stg__shop__unit_tests.yml",
        "unit_tests:\n  - name: t\n    model: stg__shop__orders\n",
    )
    write(root, "marts/fx/fct__fx_rates_by_day_v1.sql")
    write(root, "marts/fx/fct__fx_rates_by_day_v2.sql")
    write(
        root,
        "marts/fx/_marts__fx.yml",
        "models:\n  - name: fct__fx_rates_by_day\n    versions: [{v: 1}, {v: 2}]\n",
    )
    return root


def messages(root: Path) -> list[str]:
    return [v.message for v in check_project(root)]


def test_conforming_project_has_no_violations(models: Path) -> None:
    assert messages(models) == []


@pytest.mark.parametrize(
    ("relative", "expected"),
    [
        ("staging/shop/stg_shop_customers.sql", "needs at least"),
        ("staging/shop/stg__shop___customers.sql", "non snake_case segment"),
        ("staging/shop/stg__psp__payments.sql", "second segment must be 'shop'"),
        ("staging/shop/int__shop__orders.sql", "must start with stg__"),
        ("marts/fx/agg__fx__daily.sql", "must start with fct__ or dim__"),
    ],
)
def test_bad_model_names_are_reported(models: Path, relative: str, expected: str) -> None:
    write(models, relative)
    assert any(expected in m for m in messages(models)), messages(models)


def test_undeclared_model_is_reported(models: Path) -> None:
    write(models, "staging/shop/stg__shop__customers.sql")
    assert "not declared in _stg__shop.yml" in messages(models)


def test_missing_properties_file_is_reported(models: Path) -> None:
    write(models, "intermediate/fx/int__fx__rates_by_day.sql")
    assert "missing properties file _int__fx.yml" in messages(models)


def test_unit_tests_outside_their_file_are_reported(models: Path) -> None:
    write(
        models,
        "staging/shop/_stg__shop.yml",
        "models:\n  - name: stg__shop__orders\nunit_tests:\n  - name: t\n    model: stg__shop__orders\n",
    )
    assert "move unit_tests to _stg__shop__unit_tests.yml" in messages(models)


def test_unit_test_for_model_in_another_folder_is_reported(models: Path) -> None:
    write(
        models,
        "staging/shop/_stg__shop__unit_tests.yml",
        "unit_tests:\n  - name: t\n    model: stg__psp__payments\n",
    )
    assert "unit test 't' targets a model outside this folder" in messages(models)


def test_unexpected_yaml_and_flat_layout_are_reported(models: Path) -> None:
    write(models, "staging/shop/schema.yml", "models: []\n")
    write(models, "staging/stg__shop__orders.sql")
    found = messages(models)
    assert any("unexpected file" in m for m in found)
    assert any("files belong in staging/<group>/" in m for m in found)
