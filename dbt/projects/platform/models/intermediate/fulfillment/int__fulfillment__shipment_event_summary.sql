select
    shipment_id,
    min(event_at) as first_event_at,
    max(case when event_status = 'delivered' then event_at end) as delivered_at,
    count(*) as event_count
from {{ ref('stg__fulfillment__shipment_events') }}
group by shipment_id
