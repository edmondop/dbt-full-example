select
    o.order_id,
    o.merchant_id,
    o.order_date,
    o.currency_code,
    o.order_amount,
    t.rate_percent,
    cast(o.order_amount * t.rate_percent / 100 as decimal(18, 4)) as estimated_tax
from {{ ref('stg__platform__orders') }} as o
inner join {{ ref('stg__platform__merchants') }} as m on o.merchant_id = m.merchant_id
inner join {{ ref('stg__billing__tax_rates') }} as t on m.country_code = t.country_code
where o.order_status = 'completed'
