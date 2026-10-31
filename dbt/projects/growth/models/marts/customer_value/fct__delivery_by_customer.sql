select
    customer_id,
    shipments,
    average_delivery_days,
    delayed_shipments
from {{ ref('int__lifecycle__delivery_experience') }}
