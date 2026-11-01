select
    merchant_id,
    cast(avg(lag_days) as decimal(9, 2)) as average_lag_days,
    max(lag_days) as maximum_lag_days
from {{ ref('int__settlements__settlement_lag') }}
group by merchant_id
