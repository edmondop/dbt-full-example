select
    id as category_id,
    cast(name as varchar) as category_name
from {{ source('shop', 'categories') }}
