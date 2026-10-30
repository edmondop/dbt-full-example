from scripts.check_model_dag import unused_models


def test_owned_dag_reaches_a_mart() -> None:
    manifest = {
        "nodes": {
            "model.platform.stg": {
                "package_name": "platform", "resource_type": "model",
                "original_file_path": "models/staging/shop/stg__shop__orders.sql", "name": "stg__shop__orders",
            },
            "model.platform.int": {
                "package_name": "platform", "resource_type": "model",
                "original_file_path": "models/intermediate/orders/int__orders__valued.sql", "name": "int__orders__valued",
            },
            "model.platform.mart": {
                "package_name": "platform", "resource_type": "model",
                "original_file_path": "models/marts/core/fct__orders.sql", "name": "fct__orders",
            },
            "test.platform.stg": {"package_name": "platform", "resource_type": "test"},
        },
        "child_map": {
            "model.platform.stg": ["model.platform.int", "test.platform.stg"],
            "model.platform.int": ["model.platform.mart"],
        },
    }
    assert unused_models(manifest, "platform") == []

    manifest["child_map"]["model.platform.int"] = ["test.platform.stg"]
    assert unused_models(manifest, "platform") == [
        ("int__orders__valued", "models/intermediate/orders/int__orders__valued.sql")
    ]
