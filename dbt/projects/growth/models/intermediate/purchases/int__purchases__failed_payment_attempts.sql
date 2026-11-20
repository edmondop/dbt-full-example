select
    payment_id,
    order_id
from {{ ref('stg__platform__payment_attempts') }}
where payment_status = 'failed'
