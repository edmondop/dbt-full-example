select
    currency_code,
    rate_date,
    rate_to_reporting
from {{ ref('int__fx__latest_rates') }}
