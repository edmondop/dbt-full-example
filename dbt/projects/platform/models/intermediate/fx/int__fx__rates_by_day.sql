{#-
  Daily FX rate from every currency into the reporting currency, for every
  calendar day. ECB publishes rates per 1 EUR on business days only, so:

  1. cross-rate:  units of reporting currency per 1 unit of X
                  = reporting_per_eur / x_per_eur   (EUR itself has x_per_eur = 1)
  2. carry forward the last published cross-rate over weekends and holidays,
     up to var('fx_max_carry_forward_days'); a longer gap yields null, so a
     stale rate never silently prices revenue.

  Ephemeral in normal runs (inlined as a CTE into its consumers); a view when
  var('unit_testing') is true so consumers' unit tests can mock it with dict fixtures.
-#}
{{ config(materialized=marketplace_macros.materialization_for('ephemeral')) }}

{%- set reporting = var('reporting_currency') | upper %}

with published as (
    select
        rate_date,
        currency_code,
        units_per_eur
    from {{ ref('stg__reference__fx_rates') }}
    union all
    -- EUR is the ECB base currency and never appears as a column.
    select distinct
        rate_date,
        'EUR' as currency_code,
        cast(1 as decimal(18, 6)) as units_per_eur
    from {{ ref('stg__reference__fx_rates') }}
),

cross_rates as (
    select
        quoted.rate_date,
        quoted.currency_code,
        cast(reporting.units_per_eur / quoted.units_per_eur as decimal(18, 8)) as rate_to_reporting
    from published as quoted
    inner join published as reporting
        on
            quoted.rate_date = reporting.rate_date
            and reporting.currency_code = '{{ reporting }}'
),

spine as (
    {{ marketplace_macros.date_spine_days(var('start_date'), var('end_date')) }}
),

currencies as (
    select distinct currency_code from cross_rates
),

days_by_currency as (
    select
        spine.date_day,
        currencies.currency_code,
        max(cross_rates.rate_date) over (
            partition by currencies.currency_code
            order by spine.date_day
            rows between unbounded preceding and current row
        ) as source_rate_date
    from spine
    cross join currencies
    left join cross_rates
        on
            spine.date_day = cross_rates.rate_date
            and currencies.currency_code = cross_rates.currency_code
),

carried as (
    select
        date_day,
        currency_code,
        source_rate_date,
        -- dbt.datediff renders as one long expression on DuckDB.
        {{ dbt.datediff('source_rate_date', 'date_day', 'day') }} as days_carried_forward  -- noqa: LT05
    from days_by_currency
)

select
    carried.date_day as rate_date,
    carried.currency_code,
    '{{ reporting }}' as reporting_currency_code,
    carried.source_rate_date,
    carried.days_carried_forward,
    case
        when carried.days_carried_forward <= {{ var('fx_max_carry_forward_days') }}
            then cross_rates.rate_to_reporting
    end as rate_to_reporting
from carried
left join cross_rates
    on
        carried.source_rate_date = cross_rates.rate_date
        and carried.currency_code = cross_rates.currency_code
