{{ marketplace_macros.assert_reporting_currency('USD') }}
select
    payment_id,
    merchant_id,
    payout_date,
    cast(fee_amount * rate_to_usd as decimal(18, 4)) as fee_usd
from {{ ref('int__margin__fees_with_rates') }}
