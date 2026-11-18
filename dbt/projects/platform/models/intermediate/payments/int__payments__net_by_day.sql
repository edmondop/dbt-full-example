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

  The is_incremental() filter is the one WHERE an aggregate model may carry:
  it reads {{ this }}, so no upstream model can apply it.
-#}
{{ config(
    materialized=marketplace_macros.materialization_for('incremental'),
    incremental_strategy='merge',
    unique_key=['payment_date', 'merchant_id', 'currency_code'],
) }}

select
    payment_date,
    merchant_id,
    currency_code,
    cast(sum(gross_amount) as decimal(18, 4)) as gross_amount,
    cast(sum(refunded_amount) as decimal(18, 4)) as refunded_amount,
    cast(sum(net_amount) as decimal(18, 4)) as net_amount,
    max(loaded_at) as max_loaded_at
from {{ ref('int__payments__settlement_events_by_day') }}
{%- if is_incremental() %}
    where payment_date in (
        select recent.payment_date
        from {{ ref('int__payments__settlement_events_by_day') }} as recent
        where recent.loaded_at > (
            select
                coalesce(
                    {{ dbt.dateadd('day', -1 * var('incremental_lookback_days'), 'max(max_loaded_at)') }},
                    cast('1900-01-01' as timestamp)
                )
            from {{ this }}
        )
    )
{%- endif %}
group by payment_date, merchant_id, currency_code
