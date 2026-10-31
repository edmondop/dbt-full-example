select
    disputes.dispute_id,
    disputes.payment_id,
    payments.order_id,
    disputes.dispute_status,
    disputes.amount_minor
from {{ ref('stg__psp__disputes') }} as disputes
inner join {{ ref('stg__psp__payments') }} as payments on disputes.payment_id = payments.payment_id
