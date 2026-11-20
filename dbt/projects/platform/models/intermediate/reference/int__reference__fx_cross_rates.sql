{#- Units of reporting currency per 1 unit of currency_code = reporting_per_eur / quoted_per_eur. -#}
select
    rate_date,
    currency_code,
    cast(reporting_units_per_eur / units_per_eur as decimal(18, 8)) as rate_to_reporting
from {{ ref('int__reference__fx_units_with_reporting_units') }}
