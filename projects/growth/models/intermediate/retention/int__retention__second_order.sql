select
    o.customer_id,
    min(o.order_date) as second_order_date
from {{ ref('stg__platform__orders') }} as o
inner join {{ ref('int__cohorts__first_order_by_customer') }} as c
    on o.customer_id = c.customer_id
where
    o.order_status = 'completed'
    and o.order_date > c.first_order_date
group by o.customer_id
