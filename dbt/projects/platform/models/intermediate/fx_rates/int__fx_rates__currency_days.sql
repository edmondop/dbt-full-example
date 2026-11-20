select
    calendar.date_day,
    currencies.currency_code,
    published.rate_date as published_rate_date
from {{ ref('int__reference__calendar_days') }} as calendar
cross join {{ ref('int__fx_rates__currencies') }} as currencies
left join {{ ref('int__reference__fx_cross_rates') }} as published
    on
        calendar.date_day = published.rate_date
        and currencies.currency_code = published.currency_code
