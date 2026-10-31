select
    payout_date,
    merchant_id,
    payout_count,
    net_minor
from {{ ref('int__settlements__payouts_by_day') }}
