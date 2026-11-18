select
    customer_id,
    coalesce(completed_orders, 0) as completed_orders,
    case
        when coalesce(completed_orders, 0) >= 10 then 'loyal'
        when coalesce(completed_orders, 0) >= 2 then 'repeat'
        when coalesce(completed_orders, 0) = 1 then 'new'
        else 'prospect'
    end as lifecycle_segment
from {{ ref('int__lifecycle__customers_with_order_counts') }}
