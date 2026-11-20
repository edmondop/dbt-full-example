{#- Every day in [var('start_date'), var('end_date')]; unit tests narrow the window through vars. -#}
{{ marketplace_macros.date_spine_days(var('start_date'), var('end_date')) }}
