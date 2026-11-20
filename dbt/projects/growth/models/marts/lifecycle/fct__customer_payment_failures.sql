select
    customer_id,
    count(*) as failed_payment_attempts
from {{ ref('int__purchases__failed_attempts_with_customer') }}
group by customer_id
