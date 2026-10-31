select
    refund_id,
    payment_id,
    order_id,
    merchant_id,
    currency_code,
    amount,
    refunded_at
from {{ ref('platform', 'fct__refunds') }}
