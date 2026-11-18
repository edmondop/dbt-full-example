select
    payouts.payout_id,
    payouts.merchant_id,
    payouts.payment_id,
    payouts.paid_at,
    balance.net_minor,
    fees.currency_code,
    fees.fee_amount
from {{ ref('stg__psp__payouts') }} as payouts
inner join {{ ref('stg__psp__balance_transactions') }} as balance on payouts.payment_id = balance.payment_id
inner join {{ ref('int__payments__fees_by_payment') }} as fees on payouts.payment_id = fees.payment_id
