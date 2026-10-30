select * from {{ ref('stg__psp__payments') }}
where payment_status = 'failed'
