{#-
  Convert an integer amount in ISO 4217 minor units (cents, pence) to a decimal
  amount in major units. Exponents come from `var('currency_minor_units')`;
  currencies not listed use `default`. JPY has exponent 0: 1500 minor = 1500 JPY.
  The outer cast matters: DuckDB's `/` on decimals returns DOUBLE.
-#}
{% macro minor_units_to_major(amount_column, currency_column) -%}
  {%- set exponents = var('currency_minor_units') -%}
  cast(cast({{ amount_column }} as decimal(18, 4)) / case upper({{ currency_column }})
    {%- for currency, exponent in exponents.items() if currency != 'default' %}
    when '{{ currency }}' then {{ 10 ** exponent }}
    {%- endfor %}
    else {{ 10 ** exponents['default'] }}
  end as decimal(18, 4))
{%- endmacro %}
