select
    attempts.shipment_id,
    shipments.order_id,
    attempts.attempt_at,
    attempts.outcome,
    carriers.carrier_name
from {{ ref('stg__fulfillment__delivery_attempts') }} as attempts
inner join {{ ref('stg__fulfillment__shipments') }} as shipments on attempts.shipment_id = shipments.shipment_id
inner join {{ ref('stg__fulfillment__carriers') }} as carriers on shipments.carrier_id = carriers.carrier_id
