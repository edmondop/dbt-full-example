{#-
  A carried-forward rate older than var('fx_max_carry_forward_days') becomes
  null, so a stale rate never silently prices revenue.

  Ephemeral in normal runs (inlined as a CTE into its consumers); a view when
  var('unit_testing') is true so consumers' unit tests can mock it with dict fixtures.
-#}
{{ config(materialized=marketplace_macros.materialization_for('ephemeral')) }}

select
    date_day as rate_date,
    currency_code,
    '{{ var('reporting_currency') | upper }}' as reporting_currency_code,
    source_rate_date,
    days_carried_forward,
    case
        when days_carried_forward <= {{ var('fx_max_carry_forward_days') }}
            then source_rate_to_reporting
    end as rate_to_reporting
from {{ ref('int__fx_rates__carried_cross_rates') }}
