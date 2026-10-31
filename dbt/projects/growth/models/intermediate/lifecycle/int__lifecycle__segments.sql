select
    c.customer_id,
    coalesce(o.completed_orders, 0) as completed_orders,
    case
        when coalesce(o.completed_orders, 0) >= 10 then 'loyal'
        when coalesce(o.completed_orders, 0) >= 2 then 'repeat'
        when coalesce(o.completed_orders, 0) = 1 then 'new'
        else 'prospect'
    end as lifecycle_segment
from {{ ref('stg__platform__customers') }} as c
left join {{ ref('int__lifecycle__order_counts') }} as o on c.customer_id = o.customer_id
