{#-
  Calendar date of a naive UTC timestamp in a given IANA time zone.
  Both arguments are SQL expressions, so the zone can be a literal
  (`"'Asia/Tokyo'"`) or a column (`'merchants.timezone'`).
  Use `local_day_in_business_tz(ts)` for the project-wide reporting zone.
-#}
{% macro to_local_day(timestamp_expr, timezone_expr) -%}
  {{ return(adapter.dispatch('to_local_day', 'marketplace_macros')(timestamp_expr, timezone_expr)) }}
{%- endmacro %}

{% macro duckdb__to_local_day(timestamp_expr, timezone_expr) -%}
  {#- timezone('UTC', ts) reads the naive value as UTC (-> timestamptz);
      timezone(zone, tstz) renders it as wall-clock time in `zone`. -#}
  cast(timezone({{ timezone_expr }}, timezone('UTC', {{ timestamp_expr }})) as date)
{%- endmacro %}

{% macro trino__to_local_day(timestamp_expr, timezone_expr) -%}
  cast(at_timezone(with_timezone({{ timestamp_expr }}, 'UTC'), {{ timezone_expr }}) as date)
{%- endmacro %}

{% macro local_day_in_business_tz(timestamp_expr) -%}
  {{ marketplace_macros.to_local_day(timestamp_expr, "'" ~ var('business_timezone') ~ "'") }}
{%- endmacro %}
