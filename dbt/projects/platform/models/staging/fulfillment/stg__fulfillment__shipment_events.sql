select
    shipment_id,
    status as event_status,
    event_at
from {{ source('fulfillment', 'shipment_events') }}
