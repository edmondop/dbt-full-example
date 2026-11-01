select
    shipments.shipment_id,
    shipments.order_id,
    shipments.customer_id,
    shipments.merchant_id,
    shipments.shipped_at,
    shipments.delivered_at,
    shipments.delivery_days,
    labels.tracking_code
from {{ ref('int__fulfillment__shipments_with_delivery') }} as shipments
left join {{ ref('stg__fulfillment__shipping_labels') }} as labels
    on shipments.shipment_id = labels.shipment_id
