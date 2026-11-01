select
    payout_id,
    merchant_id,
    payment_id,
    paid_at,
    net_minor,
    currency_code
from {{ ref('platform', 'fct__payouts') }}
