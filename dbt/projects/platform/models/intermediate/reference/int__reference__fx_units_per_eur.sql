select
    rate_date,
    currency_code,
    units_per_eur
from {{ ref('int__reference__fx_published_units_per_eur') }}

union all

select
    rate_date,
    currency_code,
    units_per_eur
from {{ ref('int__reference__fx_eur_units_per_eur') }}
