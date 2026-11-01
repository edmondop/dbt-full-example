select
    rate_date,
    cast(currency_code as varchar) as currency_code,
    cast(reporting_currency_code as varchar) as reporting_currency_code,
    rate_to_reporting,
    source_rate_date,
    days_carried_forward > 0 as is_carried_forward
from {{ ref('int__fx__rates_by_day') }}
