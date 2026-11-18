select
    segments.customer_id,
    segments.lifecycle_segment,
    delivery.average_delivery_days
from {{ ref('int__lifecycle__segments') }} as segments
inner join {{ ref('int__lifecycle__delivery_experience') }} as delivery
    on segments.customer_id = delivery.customer_id
