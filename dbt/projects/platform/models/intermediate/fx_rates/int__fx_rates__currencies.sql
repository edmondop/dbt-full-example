select currency_code
from {{ ref('int__reference__fx_cross_rates') }}
group by currency_code
