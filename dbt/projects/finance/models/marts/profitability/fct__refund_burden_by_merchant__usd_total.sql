{{ marketplace_macros.assert_reporting_currency('USD') }}
select
    merchant_id,
    cast(sum(refunded_usd) as decimal(18, 4)) as refunded_usd
from {{ ref('int__margin__refund_value_usd') }}
group by merchant_id
