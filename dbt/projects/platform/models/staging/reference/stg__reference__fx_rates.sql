{#- One column per currency in var('fx_currencies'), so adding a currency is a
    vars change plus a new column in the export. `N/A` (no publication) becomes null. -#}
select
    {%- for currency in var('fx_currencies') %}
        cast(nullif(trim({{ currency | lower }}), 'N/A') as decimal(18, 6)) as {{ currency | lower }}_per_eur,
    {%- endfor %}
    cast(date as date) as rate_date
from {{ source('reference', 'fx_rates') }}
