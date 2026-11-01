select
    currency_code,
    minor_units
from {{ source('reference', 'currencies') }}
