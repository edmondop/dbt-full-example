select
    date_day,
    currency_count,
    covered_currency_count,
    coalesce(published_currency_count, 0) as published_currency_count,
    currency_count - covered_currency_count as missing_currency_count
from {{ ref('int__fx_monitoring__coverage_with_publications') }}
