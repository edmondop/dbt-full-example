select
    date_day,
    currency_code,
    max(published_rate_date) over (
        partition by currency_code
        order by date_day
        rows between unbounded preceding and current row
    ) as source_rate_date
from {{ ref('int__fx_rates__currency_days') }}
