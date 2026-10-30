select
    date_day,
    count(*) as currency_count,
    sum(case when has_rate then 1 else 0 end) as covered_currency_count
from {{ ref('int__fx__currency_day_coverage') }}
group by date_day
