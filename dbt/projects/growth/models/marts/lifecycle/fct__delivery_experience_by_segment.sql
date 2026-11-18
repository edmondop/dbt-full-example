select
    lifecycle_segment,
    count(*) as customers,
    cast(avg(average_delivery_days) as decimal(9, 2)) as average_delivery_days
from {{ ref('int__lifecycle__segment_delivery') }}
group by lifecycle_segment
