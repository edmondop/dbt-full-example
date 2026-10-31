select
    attempts.payment_id,
    attempts.order_id,
    orders.merchant_id,
    attempts.currency_code,
    attempts.amount,
    attempts.created_at
from {{ ref('int__payments__failed_attempts') }} as attempts
inner join {{ ref('stg__shop__orders') }} as orders on attempts.order_id = orders.order_id
