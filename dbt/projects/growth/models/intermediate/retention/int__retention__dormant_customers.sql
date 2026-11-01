select
    customer_id,
    last_order_date
from {{ ref('int__retention__last_order') }}
where {{ dbt.datediff('last_order_date', "cast('" ~ var('end_date') ~ "' as date)", 'day') }} > {{ var('dormancy_days') }}  -- noqa: LT05
