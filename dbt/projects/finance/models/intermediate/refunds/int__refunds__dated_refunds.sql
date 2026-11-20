select
    refund_id,
    payment_id,
    order_id,
    merchant_id,
    customer_id,
    currency_code,
    amount,
    refunded_at,
    cast(refunded_at as date) as refund_date
from {{ ref('int__refunds__refunds_with_orders') }}
