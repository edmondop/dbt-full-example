select
    shipment_id,
    tracking_code
from {{ source('fulfillment', 'shipping_labels') }}
