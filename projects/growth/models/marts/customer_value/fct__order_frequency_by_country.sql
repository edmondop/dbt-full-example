select
    c.country_code,
    count(*) as customers,
    cast(avg(o.completed_orders) as decimal(9, 2)) as average_completed_orders
from {{ ref('stg__platform__customers') }} as c
left join {{ ref('int__lifecycle__order_counts') }} as o on c.customer_id = o.customer_id
group by c.country_code
