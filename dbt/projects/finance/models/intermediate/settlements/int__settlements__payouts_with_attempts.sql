select
    p.payout_id,
    p.payment_id,
    p.merchant_id,
    p.paid_at,
    p.net_minor,
    a.order_id,
    a.amount as gross_amount,
    a.created_at,
    o.currency_code
from {{ ref('stg__platform__payouts') }} as p
left join {{ ref('stg__platform__payment_attempts') }} as a on p.payment_id = a.payment_id
left join {{ ref('stg__platform__orders') }} as o on a.order_id = o.order_id
