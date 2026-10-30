select
    cast(refund_id as varchar) as refund_id,
    cast(payment_id as varchar) as payment_id,
    order_id,
    merchant_id,
    cast(currency_code as varchar) as currency_code,
    cast(amount as decimal(18, 4)) as amount,
    refunded_at
from {{ ref('int__payments__refunds_with_orders') }}
