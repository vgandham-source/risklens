-- Point-in-time correct feature mart.
-- Maps to: Scope (feature-store mart) | Week: 7
--
-- TODO: build a feature table (e.g., one row per loan at issuance) using
-- ONLY information knowable at that point in time. This is the same
-- point-in-time-correctness discipline as fact_loans (FR-2) — the risk
-- here is accidentally including a feature computed from later data
-- (e.g., final loan_status), which would make this unusable for a real
-- future model.

select
    null as loan_id  -- TODO
