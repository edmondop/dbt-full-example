select
    cast(paid_at as date) as payout_date,
    merchant_id,
    count(*) as payout_count,
    sum(net_minor) as net_minor
from {{ ref('int__settlements__payouts_with_attempts') }}
group by cast(paid_at as date), merchant_id
