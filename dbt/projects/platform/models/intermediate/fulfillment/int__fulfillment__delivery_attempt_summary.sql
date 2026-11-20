select
    shipment_id,
    count(*) as attempt_count,
    sum(is_failed_attempt) as failed_attempts
from {{ ref('int__fulfillment__attempts_with_failure_flag') }}
group by shipment_id
