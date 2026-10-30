select
    sku,
    category_id,
    category_name
from {{ ref('platform', 'dim__products') }}
