select
    country_code,
    rate_percent
from {{ source('billing', 'tax_rates') }}
