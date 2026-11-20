select
    active.cohort_month,
    active.months_since_first_order,
    sizes.cohort_size,
    active.active_customers
from {{ ref('int__cohorts__active_customers_by_offset') }} as active
inner join {{ ref('int__cohorts__cohort_sizes') }} as sizes
    on active.cohort_month = sizes.cohort_month
