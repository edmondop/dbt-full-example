select
    id as dispute_id,
    payment_id,
    amount_minor,
    status as dispute_status
from {{ source('psp', 'disputes') }}
