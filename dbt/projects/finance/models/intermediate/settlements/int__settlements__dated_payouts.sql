select
    payout_id,
    merchant_id,
    cast(paid_at as date) as payout_date,
    net_minor
from {{ ref('int__settlements__payouts_with_attempts') }}
