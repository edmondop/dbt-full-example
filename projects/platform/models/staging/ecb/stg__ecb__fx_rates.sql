{#- One select per currency column; the column list is a project var, so adding
    a currency is a vars change plus a new column in the export. -#}
with unpivoted as (
    {%- for currency in var('fx_currencies') %}
        select
            cast(date as date) as rate_date,
            '{{ currency | upper }}' as currency_code,
            nullif(trim({{ currency | lower }}), 'N/A') as rate_text
        from {{ source('ecb', 'eurofxref') }}
        {%- if not loop.last %}
            union all
        {%- endif %}
    {%- endfor %}
)

select
    rate_date,
    currency_code,
    cast(rate_text as decimal(18, 6)) as units_per_eur
from unpivoted
where rate_text is not null
