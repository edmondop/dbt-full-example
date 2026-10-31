select
    order_id,
    customer_id,
    merchant_id,
    currency_code,
    order_status,
    ordered_at,
    order_date,
    order_amount_minor,
    order_amount
from {{ ref('int__orders__with_amounts') }}
where order_status = 'completed'
