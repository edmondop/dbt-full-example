select
    orders.customer_id,
    count(*) as failed_payment_attempts
from {{ ref('stg__platform__payment_attempts') }} as attempts
inner join {{ ref('stg__platform__orders') }} as orders on attempts.order_id = orders.order_id
where attempts.payment_status = 'failed'
group by orders.customer_id
