{#- Epoch seconds to a naive UTC timestamp, independent of the session time zone. -#}
{% macro epoch_seconds_to_timestamp(column) -%}
  {{ return(adapter.dispatch('epoch_seconds_to_timestamp', 'marketplace_macros')(column)) }}
{%- endmacro %}

{% macro duckdb__epoch_seconds_to_timestamp(column) -%}
  make_timestamp(cast({{ column }} as bigint) * 1000000)
{%- endmacro %}

{% macro trino__epoch_seconds_to_timestamp(column) -%}
  cast(from_unixtime({{ column }}, 'UTC') as timestamp(6))
{%- endmacro %}
