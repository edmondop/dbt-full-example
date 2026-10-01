select
    id as order_id,
    customer_id,
    merchant_id,
    upper(currency) as currency_code,
    status as order_status,
    ordered_at,
    updated_at
from {{ source('shop', 'orders') }}
