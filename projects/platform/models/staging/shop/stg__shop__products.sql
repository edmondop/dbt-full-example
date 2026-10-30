select
    sku,
    category_id,
    list_price_minor
from {{ source('shop', 'products') }}
