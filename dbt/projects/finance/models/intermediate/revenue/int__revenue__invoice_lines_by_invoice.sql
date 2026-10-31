select
    invoice_id,
    count(*) as line_count,
    sum(amount_minor) as invoiced_amount_minor
from {{ ref('stg__billing__invoice_lines') }}
group by invoice_id
