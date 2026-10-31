select
    shipment_id,
    count(*) as attempt_count,
    sum(case when outcome = 'failed' then 1 else 0 end) as failed_attempts
from {{ ref('stg__fulfillment__delivery_attempts') }}
group by shipment_id
