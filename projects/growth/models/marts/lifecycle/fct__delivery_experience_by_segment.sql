select
    s.lifecycle_segment,
    count(*) as customers,
    cast(avg(d.average_delivery_days) as decimal(9, 2)) as average_delivery_days
from {{ ref('int__lifecycle__segments') }} as s
inner join {{ ref('int__lifecycle__delivery_experience') }} as d on s.customer_id = d.customer_id
group by s.lifecycle_segment
