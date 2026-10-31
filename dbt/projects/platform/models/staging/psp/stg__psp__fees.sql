select
    payment_id,
    fee_minor
from {{ source('psp', 'fees') }}
