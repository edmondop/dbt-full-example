select
    refund_date,
    merchant_id,
    currency_code,
    count(*) as refund_count,
    cast(sum(amount) as decimal(18, 4)) as refunded_amount
from {{ ref('int__refunds__dated_refunds') }}
group by refund_date, merchant_id, currency_code
