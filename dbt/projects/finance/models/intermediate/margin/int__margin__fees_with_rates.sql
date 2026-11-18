select
    fees.payment_id,
    fees.merchant_id,
    fees.payout_date,
    fees.fee_amount,
    fx.rate_to_usd
from {{ ref('int__settlements__fees_by_payment') }} as fees
left join {{ ref('stg__platform__fx_rates_by_day') }} as fx
    on
        fees.payout_date = fx.rate_date
        and fees.currency_code = fx.currency_code
