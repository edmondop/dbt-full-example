select
    cohort_month,
    activity_month,
    currency_code,
    gross_amount
from {{ ref('int__cohorts__revenue_by_month') }}
