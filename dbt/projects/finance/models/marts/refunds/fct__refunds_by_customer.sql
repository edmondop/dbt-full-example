select
    customer_id,
    country_code,
    currency_code,
    count(*) as refund_count,
    cast(sum(amount) as decimal(18, 4)) as refunded_amount
from {{ ref('int__refunds__refunds_with_customers') }}
group by customer_id, country_code, currency_code
