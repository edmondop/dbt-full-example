select
    payout_id,
    payment_id,
    merchant_id,
    paid_at
from {{ ref('int__settlements__unmatched_payouts') }}
