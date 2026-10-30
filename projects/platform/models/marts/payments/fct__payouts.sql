select
    payouts.payout_id,
    payouts.merchant_id,
    payouts.payment_id,
    payouts.paid_at,
    balance.net_minor
from {{ ref('stg__psp__payouts') }} as payouts
inner join {{ ref('stg__psp__balance_transactions') }} as balance on payouts.payment_id = balance.payment_id
