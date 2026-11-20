select
    cast(sku as varchar) as sku,
    category_id
from {{ source('shop', 'products') }}
