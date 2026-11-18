select
    rate_date,
    currency_code,
    units_per_eur
from {{ ref('int__reference__fx_quoted_units_per_eur') }}
where units_per_eur is not null
