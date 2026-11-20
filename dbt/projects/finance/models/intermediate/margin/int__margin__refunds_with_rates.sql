select
    refunds.refund_id,
    refunds.merchant_id,
    refunds.refund_date,
    refunds.amount,
    fx.rate_to_usd
from {{ ref('int__refunds__dated_refunds') }} as refunds
left join {{ ref('stg__platform__fx_rates_by_day') }} as fx
    on
        refunds.refund_date = fx.rate_date
        and refunds.currency_code = fx.currency_code
