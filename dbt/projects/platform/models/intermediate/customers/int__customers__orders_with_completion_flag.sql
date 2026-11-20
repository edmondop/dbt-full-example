select
    customer_id,
    case when order_status = 'completed' then 1 else 0 end as is_completed_order
from {{ ref('int__orders__with_amounts') }}
