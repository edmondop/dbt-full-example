select
    customer_id,
    last_order_date
from {{ ref('int__retention__dormant_customers') }}
