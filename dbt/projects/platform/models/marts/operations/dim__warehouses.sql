select
    warehouse_id,
    country_code
from {{ ref('stg__fulfillment__warehouses') }}
