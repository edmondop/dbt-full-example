select
    order_id,
    customer_id,
    merchant_id,
    order_date,
    cast({{ dbt.date_trunc('month', 'order_date') }} as date) as order_month,
    currency_code,
    order_amount
from {{ ref('stg__platform__orders') }}
where order_status = 'completed'
