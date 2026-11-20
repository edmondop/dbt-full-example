select
    carried.date_day,
    carried.currency_code,
    carried.source_rate_date,
    carried.days_carried_forward,
    published.rate_to_reporting as source_rate_to_reporting
from {{ ref('int__fx_rates__carry_forward_days') }} as carried
left join {{ ref('int__reference__fx_cross_rates') }} as published
    on
        carried.source_rate_date = published.rate_date
        and carried.currency_code = published.currency_code
