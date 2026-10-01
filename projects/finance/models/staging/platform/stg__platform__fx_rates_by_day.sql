{#- Pinned to deprecated v1 (column rate_to_usd); migrating means changing this
    one file to v=2 and renaming rate_to_reporting, not every consumer model. -#}
select * from {{ ref('platform', 'fct__fx_rates_by_day', v=1) }}
