select
    refunds.customer_id,
    customers.country_code,
    refunds.currency_code,
    count(*) as refund_count,
    cast(sum(refunds.amount) as decimal(18, 4)) as refunded_amount
from {{ ref('int__refunds__refunds_with_orders') }} as refunds
inner join {{ ref('stg__platform__customers') }} as customers
    on refunds.customer_id = customers.customer_id
group by refunds.customer_id, customers.country_code, refunds.currency_code
