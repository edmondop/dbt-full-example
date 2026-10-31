select
    refunds.refund_id,
    refunds.payment_id,
    payments.order_id,
    orders.merchant_id,
    refunds.currency_code,
    refunds.amount,
    refunds.refunded_at,
    refunds.loaded_at
from {{ ref('stg__psp__refunds') }} as refunds
inner join {{ ref('stg__psp__payments') }} as payments on refunds.payment_id = payments.payment_id
inner join {{ ref('stg__shop__orders') }} as orders on payments.order_id = orders.order_id
where refunds.refund_status = 'succeeded'
