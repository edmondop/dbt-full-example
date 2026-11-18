select
    refunds.refund_id,
    refunds.customer_id,
    customers.country_code,
    refunds.currency_code,
    refunds.amount
from {{ ref('int__refunds__refunds_with_orders') }} as refunds
inner join {{ ref('stg__platform__customers') }} as customers
    on refunds.customer_id = customers.customer_id
