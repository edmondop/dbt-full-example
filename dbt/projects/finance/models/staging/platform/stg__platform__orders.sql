select
    order_id,
    customer_id,
    merchant_id,
    order_date,
    order_status,
    currency_code,
    order_amount
from {{ ref('platform', 'fct__orders') }}
