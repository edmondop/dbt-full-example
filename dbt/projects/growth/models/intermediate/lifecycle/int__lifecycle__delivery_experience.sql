select
    customer_id,
    count(*) as shipments,
    cast(avg(delivery_days) as decimal(9, 2)) as average_delivery_days,
    sum(delayed_shipment) as delayed_shipments
from {{ ref('int__lifecycle__shipment_delays') }}
group by customer_id
