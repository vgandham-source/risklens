-- Fact table: one row per loan. Point-in-time correct (FR-2).
-- Maps to: FR-2, FR-5 | Week: 6
--
-- TODO: join stg_loans / stg_payments to the dimension keys below, being
-- careful that any borrower attribute pulled in here reflects the borrower's
-- state AT LOAN ISSUANCE (i.e., join dim_borrower on the effective-dated
-- key, not just borrower_id) to avoid data leakage from the future.

select null as loan_id  -- TODO
