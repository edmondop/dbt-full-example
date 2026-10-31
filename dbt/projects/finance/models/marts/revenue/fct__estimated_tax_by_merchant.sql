select
    merchant_id,
    currency_code,
    count(*) as completed_orders,
    cast(sum(estimated_tax) as decimal(18, 4)) as estimated_tax
from {{ ref('int__revenue__taxed_orders') }}
group by merchant_id, currency_code
