select
    payment_id,
    order_id,
    merchant_id,
    currency_code,
    amount,
    payment_status,
    created_at
from {{ ref('platform', 'fct__payment_attempts') }}
