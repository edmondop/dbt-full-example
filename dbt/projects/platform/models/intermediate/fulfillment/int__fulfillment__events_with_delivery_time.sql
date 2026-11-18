select
    shipment_id,
    event_at,
    case when event_status = 'delivered' then event_at end as delivered_event_at
from {{ ref('stg__fulfillment__shipment_events') }}
