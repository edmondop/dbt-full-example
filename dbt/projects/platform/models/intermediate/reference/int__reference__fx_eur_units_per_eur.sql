{#- EUR is the ECB base currency and never appears as an export column. -#}
select
    rate_date,
    'EUR' as currency_code,
    cast(1 as decimal(18, 6)) as units_per_eur
from {{ ref('int__reference__fx_publication_dates') }}
