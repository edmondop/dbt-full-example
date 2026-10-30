select * from {{ ref('int__margin__merchant_day_margin') }}
where contribution_usd < 0
