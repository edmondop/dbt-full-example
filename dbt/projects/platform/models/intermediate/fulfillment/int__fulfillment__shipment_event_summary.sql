select
    shipment_id,
    min(event_at) as first_event_at,
    max(delivered_event_at) as delivered_at,
    count(*) as event_count
from {{ ref('int__fulfillment__events_with_delivery_time') }}
group by shipment_id
