select
    shipment_id,
    order_id,
    merchant_id,
    delivery_days,
    failed_attempts
from {{ ref('int__fulfillment__delayed_shipments') }}
