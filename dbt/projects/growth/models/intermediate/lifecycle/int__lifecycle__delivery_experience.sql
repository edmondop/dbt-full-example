select
    customer_id,
    count(*) as shipments,
    cast(avg(delivery_days) as decimal(9, 2)) as average_delivery_days,
    sum(case when delivery_days > 3 then 1 else 0 end) as delayed_shipments
from {{ ref('stg__platform__shipments') }}
group by customer_id
