select
    shipment_id,
    customer_id,
    delivery_days,
    case when delivery_days > 3 then 1 else 0 end as delayed_shipment
from {{ ref('stg__platform__shipments') }}
