select * from {{ ref('int__orders__with_amounts') }}
where order_status = 'completed'
