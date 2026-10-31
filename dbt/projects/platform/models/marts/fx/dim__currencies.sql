select
    cast(currency_code as varchar) as currency_code,
    minor_units
from {{ ref('stg__reference__currencies') }}
