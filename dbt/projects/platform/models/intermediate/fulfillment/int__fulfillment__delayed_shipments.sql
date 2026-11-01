select
    shipment_id,
    order_id,
    customer_id,
    merchant_id,
    warehouse_id,
    carrier_id,
    shipped_at,
    delivered_at,
    delivery_days,
    failed_attempts
from {{ ref('int__fulfillment__shipments_with_delivery') }}
where delivery_days > 3
