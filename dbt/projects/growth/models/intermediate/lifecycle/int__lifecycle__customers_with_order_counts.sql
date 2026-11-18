select
    customers.customer_id,
    customers.country_code,
    order_counts.completed_orders
from {{ ref('stg__platform__customers') }} as customers
left join {{ ref('int__lifecycle__order_counts') }} as order_counts
    on customers.customer_id = order_counts.customer_id
