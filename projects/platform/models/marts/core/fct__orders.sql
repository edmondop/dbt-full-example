select
    order_id,
    customer_id,
    merchant_id,
    order_date,
    cast(order_status as varchar) as order_status,
    cast(currency_code as varchar) as currency_code,
    order_amount
from {{ ref('int__orders__with_amounts') }}
