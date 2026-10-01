with cohorts as (
    select
        customer_id,
        cohort_month
    from {{ ref('int__cohorts__first_order_by_customer') }}
),

activity as (
    select distinct
        customer_id,
        cast({{ dbt.date_trunc('month', 'order_date') }} as date) as activity_month
    from {{ ref('stg__platform__orders') }}
    where order_status = 'completed'
),

cohort_sizes as (
    select
        cohort_month,
        count(*) as cohort_size
    from cohorts
    group by cohort_month
),

activity_by_offset as (
    select
        cohorts.cohort_month,
        activity.customer_id,
        -- dbt.datediff renders as one long expression on DuckDB.
        {{ dbt.datediff('cohorts.cohort_month', 'activity.activity_month', 'month') }} as months_since_first_order  -- noqa: LT05
    from cohorts
    inner join activity
        on cohorts.customer_id = activity.customer_id
),

active_by_offset as (
    select
        cohort_month,
        months_since_first_order,
        count(distinct customer_id) as active_customers
    from activity_by_offset
    group by cohort_month, months_since_first_order
)

select
    active_by_offset.cohort_month,
    cast(active_by_offset.months_since_first_order as integer) as months_since_first_order,
    cast(cohort_sizes.cohort_size as bigint) as cohort_size,
    cast(active_by_offset.active_customers as bigint) as active_customers,
    cast(
        cast(active_by_offset.active_customers as decimal(18, 4)) / cohort_sizes.cohort_size
        as decimal(9, 4)
    ) as retention_rate
from active_by_offset
inner join cohort_sizes
    on active_by_offset.cohort_month = cohort_sizes.cohort_month
