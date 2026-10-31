select
    id as payout_id,
    merchant_id,
    payment_id,
    paid_at
from {{ source('psp', 'payouts') }}
