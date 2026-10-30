{{ marketplace_macros.assert_reporting_currency('USD') }}
select
    r.refund_id,
    r.merchant_id,
    cast(r.refunded_at as date) as refund_date,
    cast(r.amount * fx.rate_to_usd as decimal(18, 4)) as refunded_usd
from {{ ref('int__refunds__refunds_with_orders') }} as r
left join {{ ref('stg__platform__fx_rates_by_day') }} as fx
    on cast(r.refunded_at as date) = fx.rate_date and r.currency_code = fx.currency_code
