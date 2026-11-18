select
    payment_id,
    order_id,
    merchant_id,
    cast(currency_code as varchar) as currency_code,
    cast(amount as decimal(18, 4)) as amount,
    cast(payment_status as varchar) as payment_status,
    created_at
from {{ ref('int__payments__attempts_with_merchant') }}
