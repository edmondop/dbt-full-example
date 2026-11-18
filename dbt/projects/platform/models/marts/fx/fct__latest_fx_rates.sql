select
    usable.currency_code,
    usable.rate_date,
    usable.rate_to_reporting
from {{ ref('int__fx_monitoring__usable_rates') }} as usable
inner join {{ ref('int__fx_monitoring__latest_rate_dates') }} as latest
    on
        usable.currency_code = latest.currency_code
        and usable.rate_date = latest.rate_date
