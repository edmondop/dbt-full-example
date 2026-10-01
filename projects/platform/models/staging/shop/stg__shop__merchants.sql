select
    id as merchant_id,
    name as merchant_name,
    upper(country) as country_code,
    upper(currency) as currency_code,
    timezone,
    created_at
from {{ source('shop', 'merchants') }}
