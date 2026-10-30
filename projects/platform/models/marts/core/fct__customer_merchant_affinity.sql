select
    customer_id,
    merchant_id,
    completed_orders
from {{ ref('int__customers__merchant_affinity') }}
