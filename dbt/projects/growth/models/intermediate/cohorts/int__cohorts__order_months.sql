select
    cohorts.customer_id,
    cohorts.cohort_month,
    orders.order_month as activity_month,
    orders.currency_code,
    orders.order_amount
from {{ ref('int__cohorts__first_order_by_customer') }} as cohorts
inner join {{ ref('int__purchases__completed_orders') }} as orders
    on cohorts.customer_id = orders.customer_id
