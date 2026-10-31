select
    calendar.date_day,
    currencies.currency_code,
    rates.source_rate_date,
    rates.rate_to_reporting is not null as has_rate
from {{ ref('stg__reference__calendar') }} as calendar
cross join {{ ref('stg__reference__currencies') }} as currencies
left join {{ ref('int__fx__rates_by_day') }} as rates
    on calendar.date_day = rates.rate_date and currencies.currency_code = rates.currency_code
