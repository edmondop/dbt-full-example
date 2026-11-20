select
    date_day,
    currency_code,
    source_rate_date,
    -- dbt.datediff renders as one long expression on DuckDB.
    {{ dbt.datediff('source_rate_date', 'date_day', 'day') }} as days_carried_forward  -- noqa: LT05
from {{ ref('int__fx_rates__source_rate_dates') }}
