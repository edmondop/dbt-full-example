select
    customers.customer_id,
    customers.country_code,
    customers.home_currency_code,
    customers.created_at,
    first_order.first_order_date,
    order_counts.completed_order_count
from {{ ref('int__customers__with_country_currency') }} as customers
left join {{ ref('int__customers__first_order') }} as first_order
    on customers.customer_id = first_order.customer_id
left join {{ ref('int__customers__order_counts') }} as order_counts
    on customers.customer_id = order_counts.customer_id
