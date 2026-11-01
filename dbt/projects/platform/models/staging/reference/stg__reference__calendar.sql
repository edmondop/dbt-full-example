select date_day
from {{ source('reference', 'calendar') }}
