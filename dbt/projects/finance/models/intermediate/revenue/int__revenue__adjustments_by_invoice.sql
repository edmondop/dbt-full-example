select
    invoice_id,
    sum(amount_minor) as adjustment_minor
from {{ ref('stg__billing__adjustments') }}
group by invoice_id
