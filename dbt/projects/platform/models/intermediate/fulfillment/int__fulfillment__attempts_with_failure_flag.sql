select
    shipment_id,
    case when outcome = 'failed' then 1 else 0 end as is_failed_attempt
from {{ ref('stg__fulfillment__delivery_attempts') }}
