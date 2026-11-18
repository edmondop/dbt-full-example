select
    customer_id,
    currency_code,
    cast(sum(order_amount) as decimal(18, 4)) as gross_spend
from {{ ref('int__purchases__completed_orders') }}
group by customer_id, currency_code
