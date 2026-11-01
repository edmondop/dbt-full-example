select
    customer_id,
    cast({{ dbt.datediff('first_order_date', 'second_order_date', 'day') }} as integer) as days_to_second_order  -- noqa: LT05
from {{ ref('int__retention__second_order') }}
