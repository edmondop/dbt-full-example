select
    id as email_send_id,
    customer_id,
    sent_at
from {{ source('marketing', 'email_sends') }}
