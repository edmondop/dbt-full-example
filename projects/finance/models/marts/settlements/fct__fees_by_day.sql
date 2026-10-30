select
    payout_date,
    merchant_id,
    currency_code,
    cast(sum(fee_amount) as decimal(18, 4)) as fee_amount
from {{ ref('int__settlements__fees_by_payment') }}
group by payout_date, merchant_id, currency_code
