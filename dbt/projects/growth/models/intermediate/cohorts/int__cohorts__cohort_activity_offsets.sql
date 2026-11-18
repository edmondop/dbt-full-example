select
    customer_id,
    cohort_month,
    -- dbt.datediff renders as one long expression on DuckDB.
    {{ dbt.datediff('cohort_month', 'activity_month', 'month') }} as months_since_first_order  -- noqa: LT05
from {{ ref('int__cohorts__cohort_activity') }}
