select
    windows.customer_id,
    windows.campaign_id,
    windows.channel,
    orders.order_id,
    orders.merchant_id,
    merchants.country_code as merchant_country_code,
    orders.order_date,
    orders.order_amount
from {{ ref('int__acquisition__attribution_windows') }} as windows
inner join {{ ref('int__purchases__completed_orders') }} as orders
    on
        windows.customer_id = orders.customer_id
        and orders.order_date between windows.attribution_date and windows.attribution_window_end
inner join {{ ref('stg__platform__merchants') }} as merchants
    on orders.merchant_id = merchants.merchant_id
