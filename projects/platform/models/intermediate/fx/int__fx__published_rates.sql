select
    rate_date,
    currency_code,
    units_per_eur,
    currency_code = '{{ var('reporting_currency') | upper }}' as is_reporting_currency
from {{ ref('stg__reference__fx_rates') }}
