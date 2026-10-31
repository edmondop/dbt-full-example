{#-
  Settled money per (business day, merchant, currency) in the original
  currency: succeeded payments in, succeeded refunds out.

  Incremental with a lookback: PSP events reach the export up to days after
  they happen, so each run recomputes every day touched by an event loaded
  within var('incremental_lookback_days') of the newest load already in the
  table, and merges those day-groups over the previous values. Days are
  recomputed from all their events, so a late refund corrects its day.
  An existing but empty table (max() is null) reprocesses everything; without
  the coalesce, `loaded_at > null` would select nothing, silently, forever.
-#}
{{ config(
    materialized=marketplace_macros.materialization_for('incremental'),
    incremental_strategy='merge',
    unique_key=['payment_date', 'merchant_id', 'currency_code'],
) }}

with orders as (
    select
        order_id,
        merchant_id
    from {{ ref('stg__shop__orders') }}
),

payments as (
    select
        payment_id,
        order_id
    from {{ ref('stg__psp__payments') }}
),

events as (
    select
        succeeded.created_at as event_at,
        succeeded.loaded_at,
        orders.merchant_id,
        succeeded.currency_code,
        succeeded.amount as gross_amount,
        cast(0 as decimal(18, 4)) as refunded_amount
    from {{ ref('stg__psp__payments') }} as succeeded
    inner join orders
        on succeeded.order_id = orders.order_id
    where succeeded.payment_status = 'succeeded'

    union all

    select
        refunds.refunded_at as event_at,
        refunds.loaded_at,
        orders.merchant_id,
        refunds.currency_code,
        cast(0 as decimal(18, 4)) as gross_amount,
        refunds.amount as refunded_amount
    from {{ ref('stg__psp__refunds') }} as refunds
    inner join payments
        on refunds.payment_id = payments.payment_id
    inner join orders
        on payments.order_id = orders.order_id
    where refunds.refund_status = 'succeeded'
),

events_by_day as (
    select
        {{ marketplace_macros.local_day_in_business_tz('event_at') }} as payment_date,
        merchant_id,
        currency_code,
        gross_amount,
        refunded_amount,
        loaded_at
    from events
)

{%- if is_incremental() %},

days_to_reprocess as (
    select distinct payment_date
    from events_by_day
    where loaded_at > (
        select coalesce(
            {{ dbt.dateadd('day', -1 * var('incremental_lookback_days'), 'max(max_loaded_at)') }},
            cast('1900-01-01' as timestamp)
        )
        from {{ this }}
    )
)
{%- endif %}

select
    payment_date,
    merchant_id,
    currency_code,
    cast(sum(gross_amount) as decimal(18, 4)) as gross_amount,
    cast(sum(refunded_amount) as decimal(18, 4)) as refunded_amount,
    cast(sum(gross_amount) - sum(refunded_amount) as decimal(18, 4)) as net_amount,
    max(loaded_at) as max_loaded_at
from events_by_day
{%- if is_incremental() %}
where payment_date in (select payment_date from days_to_reprocess)
{%- endif %}
group by payment_date, merchant_id, currency_code
