select
    order_id,
    customer_id,
    merchant_id,
    currency_code,
    order_date,
    order_amount,
    discount_amount_minor,
    applied_discount_percent,
    net_order_amount
from {{ ref('int__orders__with_discounts') }}
