select
    order_id,
    merchant_id,
    order_date,
    order_amount_usd
from {{ ref('int__revenue__orders_settled') }}
