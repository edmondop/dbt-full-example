select
    date_day,
    label as holiday_label
from {{ source('reference', 'holidays') }}
