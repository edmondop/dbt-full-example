with latest as (
    select
        currency_code,
        max(rate_date) as rate_date
    from {{ ref('int__fx__rates_by_day') }}
    where rate_to_reporting is not null
    group by currency_code
)

select
    rates.currency_code,
    rates.rate_date,
    rates.rate_to_reporting
from {{ ref('int__fx__rates_by_day') }} as rates
inner join latest
    on rates.currency_code = latest.currency_code and rates.rate_date = latest.rate_date
