with dedupe as (
    select
        *
        , row_number() over(partition by id order by updateDate desc) as dedupe_id
    from {{ source('source', 'items') }}
)
select
    id
    , name
    , category
    , updateDate
from dedupe
where dedupe_id = 1
;
