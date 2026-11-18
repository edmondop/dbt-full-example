select
    rate_date,
    units_per_eur as reporting_units_per_eur
from {{ ref('int__reference__fx_units_per_eur') }}
where currency_code = '{{ var('reporting_currency') | upper }}'
