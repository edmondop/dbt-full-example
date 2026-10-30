# dbt at scale

Public dbt examples such as `jaffle_shop` are one project on one warehouse with
a dozen models. They teach `ref`, `source` and a few generic tests, and they
leave out what a dbt deployment shared by several teams depends on:

- one team's project referencing another team's models;
- contracts, access levels and versions on the models other teams consume;
- macros that compile on more than one engine;
- unit tests for incremental and time-zone logic;
- CI that builds only the models a change affects, across projects.

This repository puts those features in one codebase that runs end to end on a
laptop, on DuckDB and on Trino with Iceberg, from the same SQL.

## Domain

A marketplace whose merchants sell in EUR, GBP, USD and JPY. Shop, payment,
fulfillment, billing and marketing feeds connect through orders, payments and
customers. A payment provider exports events, about 8% of them one to five days
late. Finance reports in USD at the daily ECB reference rate. The data forces
the models to handle FX carry-forward over weekends, JPY with no minor unit,
business-time-zone day boundaries, late arrivals and attribution windows.

`generator/generate.py` produces the data deterministically (2,000 customers,
50 merchants, 20,000 orders over 2024–2025) using the real ECB rates in
`generator/reference/`. The default graph has 178 SQL models in 33 model
folders; each populated folder has 5–9 models.

Refund and payout events can fall in January 2026, after the supplied ECB file
ends. Those rows keep a null USD value; the platform build reports the
`net_amount_usd` not-null test as a warning so the missing-rate boundary stays
visible.

## Projects

Three dbt projects, owned by three notional teams:

| Project | Owns | Publishes |
|---|---|---|
| `platform` | shop, payment, fulfillment and reference feeds; shared contracts | customers, products, orders, order lines, payment attempts, refunds, payouts, shipments and FX |
| `finance` | billing feed; revenue, settlements, refunds and contribution | merchant and daily financial marts |
| `growth` | marketing feed; acquisition, cohorts, retention and lifecycle | campaign, customer value and lifecycle marts |

`packages/marketplace_macros` is an internal dbt package that all three
install.

## What it demonstrates

### Cross-project refs

`finance` and `growth` call `ref('platform', 'fct__orders')` without
containing platform's code. dbt Cloud resolves cross-project refs natively;
this repo uses [dbt-loom](https://github.com/nicholasyager/dbt-loom), which
injects the public nodes of platform's `manifest.json` into the consumer's
DAG (`projects/*/dbt_loom.config.yml`).

Consumers reach platform only through local import models in
`models/staging/platform/` (`stg__platform__*`). Version pins live in one file,
and unit tests can mock the import model.

### Governance on shared models

Every mart folder in `platform` is a dbt group (`core`, `fx`, `payments`, `operations`).
Marts that other projects consume are `access: public` with
`contract: {enforced: true}`, so a column type change fails platform's build
before it reaches a consumer. Intermediate models keep the default
`protected` access, or `private` when only their own group may use them.

`fct__fx_rates_by_day` has two versions. v2 renamed `rate_to_usd` to
`rate_to_reporting`; v1 carries a `deprecation_date`, and `finance` still pins
v1 to show what a consumer sees during a migration
(`projects/platform/models/marts/fx/_marts__fx.yml`).

### One codebase, two engines

The same models build on DuckDB and on Trino (Iceberg tables in Garage object
storage, catalogued by Lakekeeper). Engine differences live in dispatched
macros under `packages/marketplace_macros/macros/cross_engine/`: date spines,
epoch conversion, local-day truncation, ISO day of week.

Each project's `dispatch:` search order lists itself before the package, so a
project can override one adapter's implementation without forking the package.

`materialization_for()` picks a materialization per adapter and run mode:
incremental models become tables on DuckDB, and ephemeral models become views
when unit tests run.

### Incremental models with late data

`int__payments__net_by_day` merges on `(payment_date, merchant_id,
currency_code)` and reprocesses every day within `incremental_lookback_days`
of the newest load, so events that arrive late update the days they belong to.

### Unit tests

Unit tests sit next to the models they test, in
`_<layer>__<folder>__unit_tests.yml`. They cover the incremental branch
(`is_incremental`, `this`, an empty target), FX carry-forward limits,
per-currency minor units, epoch-to-UTC conversion and business-time-zone day
boundaries. Tests that depend on a var, such as the carry-forward limit, set
it in the test with `overrides: vars:`.

### Slim CI across projects

`state:modified+ --defer` works inside one project. In a mesh, a change to a
platform model must also rebuild its descendants in `finance` and `growth`.
`scripts/slim_ci.sh` builds the PR's changed models plus
`platform.<changed model>+` in each consumer, deferring everything else to
the `main` baseline.

### Model layout and naming

Each project's `models/` directory follows the same three layers. Staging is
partitioned by **source system**: `shop`, `psp`, `fulfillment` and `reference`
in platform; `billing` in finance; `marketing` in growth. `platform` under
finance or growth staging is a source boundary too: its models import one
public platform contract each with `ref('platform', ...)`.

Intermediate folders group transformations by **function or use case**. For
example, platform has `orders`, `payments`, `fx`, `fulfillment` and `customers`;
finance has `revenue`, `settlements`, `refunds` and `margin`. Mart folders group
consumer-facing relations by **reporting use case**, such as `revenue`,
`profitability`, `acquisition` or `retention`. A mart area can contain several
facts and dimensions at different documented grains.

```
projects/
  platform/models/
    staging/shop/               stg__shop__orders.sql, _stg__shop.yml
    staging/psp/                stg__psp__payments.sql, _stg__psp.yml
    intermediate/payments/      int__payments__net_by_day.sql, _int__payments.yml
    marts/payments/             fct__payments_by_day__usd_total.sql, _marts__payments.yml
  finance/models/
    staging/platform/           stg__platform__orders.sql, _stg__platform.yml
    staging/billing/            stg__billing__invoices.sql, _stg__billing.yml
    intermediate/settlements/   int__settlements__fees_by_payment.sql, _int__settlements.yml
    marts/profitability/        fct__contribution_by_day__usd_total.sql, _marts__profitability.yml
  growth/models/
    staging/marketing/          stg__marketing__campaigns.sql, _stg__marketing.yml
    intermediate/acquisition/   int__acquisition__attributed_orders.sql, _int__acquisition.yml
    marts/retention/            fct__cohort_retention_by_month.sql, _marts__retention.yml
```

Names join semantic segments with `__`; words *inside* a segment use single
underscores. Staging and intermediate models repeat the folder name as their
second segment. Mart names start with `fct__` or `dim__` and state the entity,
grain and, when relevant, units: `stg__psp__payments`,
`int__settlements__fees_by_payment`, `fct__payments_by_day__usd_total`.
Versioned public mart files append `_v1`, `_v2`, and so on, while `ref()` uses
the logical model name plus `v=`.

Each leaf folder holds 5–15 SQL models and one properties file named
`_<prefix>__<folder>.yml`, where `prefix` is `stg`, `int` or `marts`. Unit tests
live beside their models in `_<prefix>__<folder>__unit_tests.yml`; the test
file may target only models in that folder. The properties file declares every
model, its grain and any public contract, column tests or source definitions.
`scripts/check_naming.py` enforces the folder size, names and YAML placement in
CI. This is a layout rule for this example, not a dbt requirement.

Names also encode units: models ending in `__usd_total` call
`assert_reporting_currency('USD')`, so overriding `reporting_currency` fails
at compile time instead of writing EUR into a USD column.

## Running it

Requirements: Docker with Compose, [uv](https://docs.astral.sh/uv/) and
[mise](https://mise.jdx.dev/).

```bash
mise run demo
```

`demo` generates and loads the data, then on DuckDB runs the naming check,
unit tests, builds and SQLFluff for every project. It then starts the Trino
stack and runs unit tests and builds again on Trino. Projects run in
dependency order: platform first, because consumers read the manifest it
writes.

| Task | Runs |
|---|---|
| `mise run ci:duckdb` | the DuckDB half of `demo` |
| `mise run ci:trino` | the Trino half of `demo` |
| `mise run ci:slim` | slim CI against `BASE_REF` (default `origin/main`) |
| `PROJECT=finance DBT_TARGET=trino mise run unit` | one project's unit tests on one engine |
| `PROJECT=growth mise run build` | `dbt build` for one project |
| `mise run infra:down` | stops the stack and deletes its volumes |

`.github/workflows/ci.yml` runs the same tasks. `infra/.env` contains
credentials for the local Compose stack only.
