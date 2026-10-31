select
    customer_id,
    completed_orders,
    lifecycle_segment
from {{ ref('int__lifecycle__segments') }}
