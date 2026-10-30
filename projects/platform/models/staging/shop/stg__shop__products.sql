select
    sku,
    category_id
from {{ source('shop', 'products') }}
