select
    shipment_id,
    order_id,
    customer_id,
    merchant_id,
    shipped_at,
    delivered_at,
    delivery_days
from {{ ref('platform', 'fct__shipments') }}
