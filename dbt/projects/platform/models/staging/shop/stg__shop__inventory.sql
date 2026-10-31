select
    sku,
    warehouse_id,
    on_hand
from {{ source('shop', 'inventory') }}
