select
    quoted.rate_date,
    quoted.currency_code,
    quoted.units_per_eur,
    reporting.reporting_units_per_eur
from {{ ref('int__reference__fx_units_per_eur') }} as quoted
inner join {{ ref('int__reference__fx_reporting_units_per_eur') }} as reporting
    on quoted.rate_date = reporting.rate_date
