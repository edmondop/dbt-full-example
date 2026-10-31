select
    date_day,
    currency_code,
    source_rate_date,
    has_rate
from {{ ref('int__fx__currency_day_coverage') }}
where not has_rate
