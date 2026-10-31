select
    merchant_id,
    count(*) as payout_count,
    sum(net_minor) as net_minor
from {{ ref('int__settlements__payouts_with_attempts') }}
group by merchant_id
