select
    id as carrier_id,
    name as carrier_name
from {{ source('fulfillment', 'carriers') }}
