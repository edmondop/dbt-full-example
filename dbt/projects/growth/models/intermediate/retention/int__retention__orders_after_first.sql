select
    orders.customer_id,
    first_orders.first_order_date,
    orders.order_date
from {{ ref('int__purchases__completed_orders') }} as orders
inner join {{ ref('int__cohorts__first_order_by_customer') }} as first_orders
    on
        orders.customer_id = first_orders.customer_id
        and orders.order_date > first_orders.first_order_date
