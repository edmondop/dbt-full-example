select
    date_day,
    count(*) as currency_count,
    count(rate_to_reporting) as covered_currency_count
from {{ ref('int__fx_monitoring__currency_days_with_rates') }}
group by date_day
