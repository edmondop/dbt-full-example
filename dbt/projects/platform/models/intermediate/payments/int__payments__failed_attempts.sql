select
    payment_id,
    order_id,
    currency_code,
    amount_minor,
    amount,
    payment_status,
    created_at,
    loaded_at
from {{ ref('stg__psp__payments') }}
where payment_status = 'failed'
