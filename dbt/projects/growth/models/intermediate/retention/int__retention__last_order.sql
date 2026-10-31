select
    customer_id,
    max(order_date) as last_order_date
from {{ ref('stg__platform__orders') }}
where order_status = 'completed'
group by customer_id
