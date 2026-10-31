{#- v1 (deprecated): USD-only column name. Kept until consumers migrate to v2. -#}
{{ marketplace_macros.assert_reporting_currency('USD') }}

select
    rate_date,
    cast(currency_code as varchar) as currency_code,
    rate_to_reporting as rate_to_usd,
    source_rate_date
from {{ ref('int__fx__rates_by_day') }}
