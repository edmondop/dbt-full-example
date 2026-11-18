select
    currency_code,
    rate_date,
    rate_to_reporting
from {{ ref('int__fx_rates__rates_by_day') }}
where rate_to_reporting is not null
