with spine as (
    {{ marketplace_macros.date_spine_days(var('start_date'), var('end_date')) }}
)

select
    spine.date_day,
    cast({{ dbt.date_trunc('month', 'spine.date_day') }} as date) as month_start,
    cast(year(spine.date_day) as integer) as calendar_year,
    cast({{ marketplace_macros.iso_day_of_week('spine.date_day') }} as integer) as iso_day_of_week,
    {{ marketplace_macros.iso_day_of_week('spine.date_day') }} >= 6 as is_weekend,
    holidays.date_day is not null as is_holiday
from spine
left join {{ ref('stg__reference__holidays') }} as holidays on spine.date_day = holidays.date_day
