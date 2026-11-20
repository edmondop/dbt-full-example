{{ marketplace_macros.assert_reporting_currency('USD') }}
select
    refund_id,
    merchant_id,
    refund_date,
    cast(amount * rate_to_usd as decimal(18, 4)) as refunded_usd
from {{ ref('int__margin__refunds_with_rates') }}
