select
    payout_id,
    merchant_id,
    cast({{ dbt.datediff('created_at', 'paid_at', 'day') }} as integer) as lag_days  -- noqa: LT05
from {{ ref('int__settlements__payouts_with_attempts') }}
where created_at is not null
