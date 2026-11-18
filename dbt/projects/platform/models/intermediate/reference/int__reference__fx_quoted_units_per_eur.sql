{#- One branch per currency column in var('fx_currencies'). -#}
{%- for currency in var('fx_currencies') %}
    select
        rate_date,
        '{{ currency | upper }}' as currency_code,
        {{ currency | lower }}_per_eur as units_per_eur
    from {{ ref('stg__reference__fx_rates') }}
    {%- if not loop.last %}
        union all
    {%- endif %}
{%- endfor %}
