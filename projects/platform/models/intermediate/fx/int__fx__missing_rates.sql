select * from {{ ref('int__fx__currency_day_coverage') }}
where not has_rate
