select
    f.customer_id,
    cast({{ dbt.datediff('f.first_order_date', 's.second_order_date', 'day') }} as integer) as days_to_second_order  -- noqa: LT05
from {{ ref('int__cohorts__first_order_by_customer') }} as f
inner join {{ ref('int__retention__second_order') }} as s on f.customer_id = s.customer_id
