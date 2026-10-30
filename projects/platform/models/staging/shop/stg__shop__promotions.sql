select
    id as promotion_id,
    merchant_id,
    discount_percent
from {{ source('shop', 'promotions') }}
