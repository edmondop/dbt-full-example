with months as (
    select distinct month_start as activity_month
    from {{ ref('stg__platform__calendar') }}
)

select
    months.activity_month,
    coalesce(activity.active_customers, 0) as active_customers
from months
left join {{ ref('int__retention__active_customer_months') }} as activity
    on months.activity_month = activity.activity_month
