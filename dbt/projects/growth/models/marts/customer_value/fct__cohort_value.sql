select
    cohort_month,
    currency_code,
    cast(sum(gross_spend) as decimal(18, 4)) as gross_spend
from {{ ref('int__cohorts__cohort_spend') }}
group by cohort_month, currency_code
