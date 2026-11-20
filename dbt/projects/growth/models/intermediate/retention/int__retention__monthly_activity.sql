select
    customer_id,
    order_month as activity_month,
    count(*) as completed_orders
from {{ ref('int__purchases__completed_orders') }}
group by customer_id, order_month
