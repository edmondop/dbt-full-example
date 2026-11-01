with coverage as (
    select
        date_day,
        count(*) as currency_count,
        sum(case when has_rate then 1 else 0 end) as covered_currency_count
    from {{ ref('int__fx__currency_day_coverage') }}
    group by date_day
),

publications as (
    select
        rate_date,
        count(*) as published_currency_count
    from {{ ref('int__fx__published_rates') }}
    group by rate_date
),

missing as (
    select
        date_day,
        count(*) as missing_currency_count
    from {{ ref('int__fx__missing_rates') }}
    group by date_day
)

select
    coverage.date_day,
    coverage.currency_count,
    coverage.covered_currency_count,
    coalesce(publications.published_currency_count, 0) as published_currency_count,
    coalesce(missing.missing_currency_count, 0) as missing_currency_count
from coverage
left join publications on coverage.date_day = publications.rate_date
left join missing on coverage.date_day = missing.date_day
