select
    order_id,
    merchant_id,
    order_date,
    currency_code,
    order_amount
from {{ ref('stg__platform__orders') }}
where order_status = 'completed'
