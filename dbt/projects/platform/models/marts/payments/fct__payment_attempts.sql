select
    payments.payment_id,
    payments.order_id,
    orders.merchant_id,
    cast(payments.currency_code as varchar) as currency_code,
    cast(payments.amount as decimal(18, 4)) as amount,
    cast(payments.payment_status as varchar) as payment_status,
    payments.created_at
from {{ ref('stg__psp__payments') }} as payments
inner join {{ ref('stg__shop__orders') }} as orders on payments.order_id = orders.order_id
