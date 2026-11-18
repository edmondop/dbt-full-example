select
    payments.payment_id,
    payments.order_id,
    orders.merchant_id,
    payments.currency_code,
    payments.amount,
    payments.payment_status,
    payments.created_at,
    payments.loaded_at
from {{ ref('stg__psp__payments') }} as payments
inner join {{ ref('stg__shop__orders') }} as orders on payments.order_id = orders.order_id
