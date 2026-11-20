select
    products.sku,
    products.category_id,
    categories.category_name
from {{ ref('stg__shop__products') }} as products
left join {{ ref('stg__shop__categories') }} as categories on products.category_id = categories.category_id
