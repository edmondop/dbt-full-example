{#-
  Resolve a model's logical materialization to what the current adapter and
  run mode should actually build. Models declare intent; this macro decides:

    {{ config(materialized=marketplace_macros.materialization_for('ephemeral')) }}

  - `ephemeral` becomes `view` when `var('unit_testing')` is true. dbt (1.12)
    can unit test an ephemeral model itself, but a model that *consumes* one
    must mock that input with `format: sql` fixtures (dict/csv fail to compile).
    As a view, the input accepts ordinary dict fixtures like any other ref.
    dbt-trino also needs it for the model itself: it creates the unit test
    relation in the model's schema, which an ephemeral model never creates.
  - `incremental` stays incremental on Trino (Iceberg MERGE) and becomes `table`
    on DuckDB, where a full rebuild of the local dataset is cheaper than merging.
    Unit tests still exercise the incremental branch through
    `overrides: {macros: {is_incremental: true}}`.

  Projects override per adapter by defining `<adapter>__materialization_for`
  and listing themselves first in the `dispatch` search order.
-#}
{% macro materialization_for(kind) -%}
  {{ return(adapter.dispatch('materialization_for', 'marketplace_macros')(kind)) }}
{%- endmacro %}

{% macro default__materialization_for(kind) -%}
  {%- set known = ['view', 'table', 'incremental', 'ephemeral'] -%}
  {%- if kind not in known -%}
    {{ exceptions.raise_compiler_error("materialization_for: unknown kind '" ~ kind ~ "', expected one of " ~ known) }}
  {%- endif -%}
  {%- if kind == 'ephemeral' and var('unit_testing', false) | as_bool -%}
    {{ return('view') }}
  {%- endif -%}
  {{ return(kind) }}
{%- endmacro %}

{% macro duckdb__materialization_for(kind) -%}
  {%- if kind == 'incremental' -%}
    {{ return('table') }}
  {%- endif -%}
  {{ return(marketplace_macros.default__materialization_for(kind)) }}
{%- endmacro %}
