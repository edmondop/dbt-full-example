{#-
  One row per calendar day in [start_date, end_date], column `date_day`.
  dbt core ships no date spine; the two engines generate series differently.
-#}
{% macro date_spine_days(start_date, end_date) -%}
  {{ return(adapter.dispatch('date_spine_days', 'marketplace_macros')(start_date, end_date)) }}
{%- endmacro %}

{% macro duckdb__date_spine_days(start_date, end_date) -%}
  select cast(range as date) as date_day
  from range(date '{{ start_date }}', date '{{ end_date }}' + interval 1 day, interval 1 day)
{%- endmacro %}

{% macro trino__date_spine_days(start_date, end_date) -%}
  {#- sequence() is capped at 10,000 elements (~27 years of days). -#}
  select date_day
  from unnest(sequence(date '{{ start_date }}', date '{{ end_date }}', interval '1' day)) as spine (date_day)
{%- endmacro %}
