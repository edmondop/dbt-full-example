select
    date_day,
    cast({{ dbt.date_trunc('month', 'date_day') }} as date) as month_start,
    cast(year(date_day) as integer) as calendar_year,
    cast({{ marketplace_macros.iso_day_of_week('date_day') }} as integer) as iso_day_of_week,
    {{ marketplace_macros.iso_day_of_week('date_day') }} >= 6 as is_weekend,
    holiday_date is not null as is_holiday
from {{ ref('int__reference__calendar_days_with_holidays') }}
