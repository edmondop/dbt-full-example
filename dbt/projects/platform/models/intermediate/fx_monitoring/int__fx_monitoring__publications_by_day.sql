select
    rate_date,
    count(*) as published_currency_count
from {{ ref('int__reference__fx_published_units_per_eur') }}
group by rate_date
