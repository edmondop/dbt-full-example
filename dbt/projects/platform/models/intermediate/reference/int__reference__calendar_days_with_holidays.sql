select
    calendar.date_day,
    holidays.date_day as holiday_date
from {{ ref('int__reference__calendar_days') }} as calendar
left join {{ ref('stg__reference__holidays') }} as holidays on calendar.date_day = holidays.date_day
