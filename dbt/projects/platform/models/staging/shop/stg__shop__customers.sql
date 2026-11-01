select
    id as customer_id,
    lower(email) as email,
    upper(country) as country_code,
    created_at,
    updated_at
from {{ source('shop', 'customers') }}
