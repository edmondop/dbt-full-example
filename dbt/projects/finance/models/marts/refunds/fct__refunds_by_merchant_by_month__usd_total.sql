{{ marketplace_macros.assert_reporting_currency('USD') }}

select
    refund_month,
    merchant_id,
    cast(sum(refunded_amount_usd) as decimal(18, 4)) as refunded_amount_usd,
    cast(sum(gross_amount_usd) as decimal(18, 4)) as gross_amount_usd
from {{ ref('int__refunds__payment_days_with_month') }}
group by refund_month, merchant_id
