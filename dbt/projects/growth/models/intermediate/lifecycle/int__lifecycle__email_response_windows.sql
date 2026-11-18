{#- Completed orders from sent_date through response_window_end (inclusive) count as a response. -#}
select
    email_send_id,
    customer_id,
    cast(sent_at as date) as sent_date,
    cast(
        {{ dbt.dateadd('day', var('email_response_days'), 'cast(sent_at as date)') }} as date
    ) as response_window_end
from {{ ref('stg__marketing__email_sends') }}
