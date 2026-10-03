-- SCD Type 2 borrower dimension.
-- Maps to: FR-2 | Week: 4, 6
--
-- TODO: select from {{ ref('int_borrower_scd2') }} and expose a clean,
-- documented interface (surrogate key + natural key + effective-dating
-- columns + is_current flag) for fact_loans to join against.

select null as borrower_key  -- TODO
