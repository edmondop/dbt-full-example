# dbt at scale: model graph expansion

## Goal

The repository should demonstrate how several teams organize and operate a substantial dbt graph. Every model-bearing folder under `staging`, `intermediate`, and `marts` should contain 5–15 useful SQL models. Each model needs a stated grain and a business or integration purpose. The example must still run end to end on DuckDB and Trino from one deterministic dataset.

## Audience and scope

The audience is a data engineer evaluating dbt project boundaries, source organization, model ownership, contracts, tests, and cross-project change propagation. The three existing projects remain: `platform` publishes shared entities and facts; `finance` owns financial reporting; `growth` owns acquisition and lifecycle reporting.

The expansion keeps the existing multi-project mesh, dbt-loom imports, adapter-dispatched macros, versioned FX contract, and `mise run demo` entry point. It adds source data and model families where they support distinct questions. It does not add placeholder models merely to meet a count.

## Data model and ownership

The marketplace keeps customers, merchants, orders, order lines, payments, refunds, and daily FX rates. Add connected data for product catalog and inventory, shipment and delivery events, payment disputes and settlements, billing adjustments, and marketing campaigns and touchpoints. Generated IDs and timestamps connect these records to the existing orders and customers. The generator remains deterministic, and the ECB FX rate values retain their real reference input.

`platform` owns the shared source and integration graph. Its source folders are `shop`, `psp`, `fulfillment`, and `reference`; `reference` is the repository's ingested reference-data feed, including ECB rates and currency/calendar metadata. `finance` owns a `billing` feed and imports selected public platform models. `growth` owns a `marketing` feed and imports selected public platform models. A consumer imports platform relations through its own `staging/platform` models and uses only public contracted platform marts for cross-project `ref` calls.

Each fact declares its grain in its properties file. Core grains include order, order line, payment attempt, refund, shipment event, settlement entry, customer touchpoint, and calendar day. Aggregates state their grouping keys and measure units. Reconciliation models connect gross order amounts, captured payments, refunds, fees, and net settlement amounts; acquisition models connect touchpoints to customers and orders using a documented attribution window.

## Model layout and target size

Each leaf folder below has 5–15 SQL models. Counts are design targets, adjusted only when a model has a distinct grain or transformation purpose.

| Project | Staging by source | Intermediate by function | Marts by reporting area | Approximate total |
| --- | --- | --- | --- | ---: |
| `platform` | `shop` 9, `psp` 6, `fulfillment` 6, `reference` 5 | `orders`, `payments`, `fulfillment`, `fx`, `customers`: 5 each | `core` 9, `payments` 6, `fx` 5, `operations` 5 | 76 |
| `finance` | `platform` 8, `billing` 5 | `revenue` 6, `settlements` 5, `refunds` 5, `margin` 5 | `revenue` 7, `settlements` 5, `profitability` 5, `refunds` 5 | 56 |
| `growth` | `platform` 8, `marketing` 5 | `acquisition`, `cohorts`, `retention`, `lifecycle`: 5 each | `acquisition` 5, `retention` 5, `customer_value` 6, `lifecycle` 7 | 56 |

The graph has 188 SQL models across three projects. Folder-local properties and unit-test YAML stay beside the SQL they describe. The naming check walks all leaf folders, validates their names and YAML ownership, and reports empty or out-of-range folders. dbt groups and schemas remain explicitly configured at mart-area level.

## Interfaces and behavior

- Staging models normalize source-specific types, names, statuses, currencies, and timestamps. Staging models for owned feeds read raw relations; `staging/platform` models in consumers import one public platform relation each. Every staging model exposes a documented grain.
- Intermediate models implement joins, deduplication, attribution, currency conversion, reconciliation, and time windows. Their folder names denote the function, and their names retain the `int__<function>__...` convention.
- Mart models expose facts and dimensions for specific reporting questions. Only a deliberate subset is `access: public` with enforced contracts; versioned public models keep stable consumer behavior during migrations.
- `finance` uses platform's published order, payment, refund, settlement, and FX contracts. `growth` uses published customer, order, catalog, and fulfillment contracts. Their local imports pin versions where needed.
- Existing `reporting_currency`, `business_timezone`, FX carry-forward, and incremental lookback variables remain. New policy windows, such as attribution lookback, are explicit vars with unit tests for their boundaries.
- The repository README shows representative dependency paths and practical use of the folders. It stays an example-project README rather than a catalog of every model.

## Verification

1. Expand deterministic data generation and loading for the new feeds; verify foreign-key reachability, event ordering, and reproducible output.
2. Update the naming checker and its tests for the expanded set of source, function, and mart folders; enforce folder-local YAML, declared models, and the 5–15 model target.
3. Add focused dbt unit tests for joins, late arrivals, refund and settlement arithmetic, attribution windows, and FX boundaries. Add data tests for keys, accepted values, and relationships at source and published-contract boundaries.
4. Run the paved tasks: `mise run check:naming`, `mise run test:py`, `mise run ci:duckdb`, `mise run ci:trino`, and `mise run ci:slim`. Confirm the manifest contains the intended counts and that cross-project descendants are selected after a platform contract change.

The larger graph will increase local and CI runtime, especially with Trino materializations. Build timing is part of validation; materializations and sample volumes should be tuned without removing meaningful models or skipping either engine.
