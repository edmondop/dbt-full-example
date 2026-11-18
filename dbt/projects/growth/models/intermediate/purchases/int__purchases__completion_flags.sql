select
    order_id,
    customer_id,
    case when order_status = 'completed' then 1 else 0 end as completed_order
from {{ ref('stg__platform__orders') }}
