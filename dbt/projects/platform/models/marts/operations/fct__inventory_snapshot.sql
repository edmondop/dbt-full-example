select
    inventory.sku,
    inventory.warehouse_id,
    products.category_id,
    inventory.on_hand
from {{ ref('stg__shop__inventory') }} as inventory
inner join {{ ref('stg__shop__products') }} as products on inventory.sku = products.sku
