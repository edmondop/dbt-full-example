select
    cohort_month,
    cast(months_since_first_order as integer) as months_since_first_order,
    cast(cohort_size as bigint) as cohort_size,
    cast(active_customers as bigint) as active_customers,
    cast(
        cast(active_customers as decimal(18, 4)) / cohort_size
        as decimal(9, 4)
    ) as retention_rate
from {{ ref('int__cohorts__retention_with_cohort_size') }}
