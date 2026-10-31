select
    lifecycle_segment,
    count(*) as customers
from {{ ref('int__lifecycle__segments') }}
group by lifecycle_segment
