select
    customer_id,
    days_to_second_order
from {{ ref('int__lifecycle__repeat_purchase_days') }}
