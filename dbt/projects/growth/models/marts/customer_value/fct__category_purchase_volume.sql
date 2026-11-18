select
    category_id,
    category_name,
    currency_code,
    sum(quantity) as units_sold,
    sum(line_amount_minor) as gross_amount_minor
from {{ ref('int__purchases__completed_lines_with_category') }}
group by category_id, category_name, currency_code
