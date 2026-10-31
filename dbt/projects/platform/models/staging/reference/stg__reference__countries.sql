select
    country_code,
    currency_code
from {{ source('reference', 'countries') }}
