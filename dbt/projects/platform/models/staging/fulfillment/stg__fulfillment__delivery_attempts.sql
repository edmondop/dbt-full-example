select
    shipment_id,
    attempt_at,
    outcome
from {{ source('fulfillment', 'delivery_attempts') }}
