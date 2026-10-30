select
    date_day,
    month_start,
    calendar_year,
    iso_day_of_week,
    is_weekend
from {{ ref('platform', 'dim__calendar') }}
