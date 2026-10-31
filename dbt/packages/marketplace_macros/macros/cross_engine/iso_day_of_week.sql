{#- ISO day of week: Monday = 1 ... Sunday = 7. -#}
{% macro iso_day_of_week(date_expr) -%}
  {{ return(adapter.dispatch('iso_day_of_week', 'marketplace_macros')(date_expr)) }}
{%- endmacro %}

{% macro duckdb__iso_day_of_week(date_expr) -%}
  isodow({{ date_expr }})
{%- endmacro %}

{% macro trino__iso_day_of_week(date_expr) -%}
  day_of_week({{ date_expr }})
{%- endmacro %}
