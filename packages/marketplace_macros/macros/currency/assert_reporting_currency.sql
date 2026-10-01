{#-
  Model names encode their unit (`fct__payments_by_day__usd_total`). Guard
  them so overriding var('reporting_currency') fails at compile time instead
  of writing EUR amounts into columns named *_usd.
-#}
{% macro assert_reporting_currency(expected) -%}
  {%- if var('reporting_currency') | upper != expected | upper -%}
    {{ exceptions.raise_compiler_error(
        model.name ~ " is denominated in " ~ expected ~ " but var('reporting_currency') is "
        ~ var('reporting_currency') ~ "; add a model for that currency instead.") }}
  {%- endif -%}
{%- endmacro %}
