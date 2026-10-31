select
    cast(refunded_at as date) as refund_date,
    merchant_id,
    currency_code,
    count(*) as refund_count,
    cast(sum(amount) as decimal(18, 4)) as refunded_amount
from {{ ref('int__refunds__refunds_with_orders') }}
group by cast(refunded_at as date), merchant_id, currency_code
