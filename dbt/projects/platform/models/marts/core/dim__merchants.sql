select
    merchant_id,
    cast(merchant_name as varchar) as merchant_name,
    cast(country_code as varchar) as country_code,
    cast(currency_code as varchar) as currency_code,
    cast(timezone as varchar) as timezone
from {{ ref('stg__shop__merchants') }}
