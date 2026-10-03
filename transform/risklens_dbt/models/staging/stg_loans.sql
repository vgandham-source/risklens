-- Staging: cleaned/standardized loan applications.
-- Maps to: FR-2 | Week: 3
--
-- TODO: select from {{ source('bronze', 'loans_accepted_raw') }}, cast types,
-- standardize categorical fields (grade, purpose, home_ownership, state),
-- and dedupe on the natural key. Do not join to other entities here — that
-- happens in intermediate/ or marts/.

select
    null as loan_id  -- TODO
