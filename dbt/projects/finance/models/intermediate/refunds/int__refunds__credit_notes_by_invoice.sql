select
    invoice_id,
    count(*) as credit_note_count,
    sum(amount_minor) as credited_minor
from {{ ref('stg__billing__credit_notes') }}
group by invoice_id
