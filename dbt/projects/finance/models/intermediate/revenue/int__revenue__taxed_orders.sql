select
    order_id,
    merchant_id,
    order_date,
    currency_code,
    order_amount,
    rate_percent,
    cast(order_amount * rate_percent / 100 as decimal(18, 4)) as estimated_tax
from {{ ref('int__revenue__completed_orders_with_tax_rates') }}
