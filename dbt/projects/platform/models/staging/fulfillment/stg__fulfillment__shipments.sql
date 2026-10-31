select
    id as shipment_id,
    order_id,
    warehouse_id,
    carrier_id,
    shipped_at
from {{ source('fulfillment', 'shipments') }}
