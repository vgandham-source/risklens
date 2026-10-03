-- Intermediate: current + historical borrower attributes, ready for the
-- Gold-layer dim_borrower to consume.
-- Maps to: FR-2 | Week: 4, 6
--
-- TODO: select from {{ ref('borrower_snapshot') }}, exposing dbt_valid_from /
-- dbt_valid_to / dbt_scd_id as effective-dating columns dim_borrower can
-- use directly, renamed to something more business-friendly if you prefer
-- (e.g., valid_from, valid_to, is_current).

select
    null as borrower_id  -- TODO
