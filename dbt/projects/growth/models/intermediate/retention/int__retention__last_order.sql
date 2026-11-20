select
    customer_id,
    max(order_date) as last_order_date
from {{ ref('int__purchases__completed_orders') }}
group by customer_id
