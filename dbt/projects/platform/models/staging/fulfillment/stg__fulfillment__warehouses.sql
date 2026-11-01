select
    id as warehouse_id,
    upper(country) as country_code
from {{ source('fulfillment', 'warehouses') }}
