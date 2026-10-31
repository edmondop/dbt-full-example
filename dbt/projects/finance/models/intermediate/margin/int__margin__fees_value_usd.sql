{{ marketplace_macros.assert_reporting_currency('USD') }}
select
    f.payment_id,
    f.merchant_id,
    f.payout_date,
    cast(f.fee_amount * fx.rate_to_usd as decimal(18, 4)) as fee_usd
from {{ ref('int__settlements__fees_by_payment') }} as f
left join {{ ref('stg__platform__fx_rates_by_day') }} as fx
    on f.payout_date = fx.rate_date and f.currency_code = fx.currency_code
