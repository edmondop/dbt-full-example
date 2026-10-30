select
    r.refund_id,
    r.payment_id,
    r.order_id,
    r.merchant_id,
    o.customer_id,
    o.currency_code,
    r.amount,
    r.refunded_at
from {{ ref('stg__platform__refunds') }} as r
inner join {{ ref('stg__platform__orders') }} as o on r.order_id = o.order_id
