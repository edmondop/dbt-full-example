select
    shipment_id,
    order_id,
    merchant_id,
    delivery_days,
    failed_attempts
from {{ ref('int__fulfillment__shipments_with_delivery') }}
where delivery_days > 3
