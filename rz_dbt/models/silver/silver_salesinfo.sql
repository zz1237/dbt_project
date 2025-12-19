with sales as (
    select
        sales_id
        , product_sk
        , customer_sk
        , gross_amount
        , payment_method
        , {{multiply('unit_price','quantity')}} as calculated_gross_amount
    from {{ ref('bronze_sales') }}
)
, product as (
    select
        product_sk
        , category
    from {{ ref('bronze_product') }}
)
, customer as (
    select
        customer_sk
        , gender
    from {{ ref('bronze_customer') }}
)
, joined_query as (
    select
        s.sales_id
        , s.gross_amount
        , s.payment_method
        , p.category
        , c.gender
        , s.calculated_gross_amount
    from sales s
    join product p  
        on s.product_sk=p.product_sk
    join customer c 
        on s.customer_sk=c.customer_sk
)
select
    category
    , gender
    , sum(gross_amount) as total_sales
from joined_query
group by 1,2
order by 3 desc
;