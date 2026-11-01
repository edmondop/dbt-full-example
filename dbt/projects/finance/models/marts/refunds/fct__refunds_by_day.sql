select
    refund_date,
    merchant_id,
    currency_code,
    refund_count,
    refunded_amount
from {{ ref('int__refunds__refunds_by_day') }}
