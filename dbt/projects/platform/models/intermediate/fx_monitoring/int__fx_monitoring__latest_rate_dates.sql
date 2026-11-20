select
    currency_code,
    max(rate_date) as rate_date
from {{ ref('int__fx_monitoring__usable_rates') }}
group by currency_code
