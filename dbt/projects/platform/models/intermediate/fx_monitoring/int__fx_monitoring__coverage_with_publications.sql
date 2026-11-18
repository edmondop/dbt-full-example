select
    coverage.date_day,
    coverage.currency_count,
    coverage.covered_currency_count,
    publications.published_currency_count
from {{ ref('int__fx_monitoring__coverage_by_day') }} as coverage
left join {{ ref('int__fx_monitoring__publications_by_day') }} as publications
    on coverage.date_day = publications.rate_date
