select
    attempts.payment_id,
    orders.customer_id
from {{ ref('int__purchases__failed_payment_attempts') }} as attempts
inner join {{ ref('stg__platform__orders') }} as orders on attempts.order_id = orders.order_id
