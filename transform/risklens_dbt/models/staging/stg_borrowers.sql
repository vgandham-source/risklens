-- Staging: cleaned/standardized borrower attributes (pre-SCD2).
-- Maps to: FR-2 | Week: 3-4
--
-- TODO: conform borrower fields from {{ source('bronze', 'loans_accepted_raw') }}
-- and {{ source('bronze', 'borrower_history_raw') }} into one consistent shape.
-- The SCD Type 2 logic itself belongs in snapshots/borrower_snapshot.sql,
-- not here.

select
    null as borrower_id  -- TODO
