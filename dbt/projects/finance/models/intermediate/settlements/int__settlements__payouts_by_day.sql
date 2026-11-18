select
    payout_date,
    merchant_id,
    count(*) as payout_count,
    sum(net_minor) as net_minor
from {{ ref('int__settlements__dated_payouts') }}
group by payout_date, merchant_id
