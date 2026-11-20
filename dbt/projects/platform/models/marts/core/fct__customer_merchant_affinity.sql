select
    customer_id,
    merchant_id,
    count(*) as completed_orders
from {{ ref('int__orders__completed') }}
group by customer_id, merchant_id
