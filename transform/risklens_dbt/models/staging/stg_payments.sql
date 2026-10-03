-- Staging: cleaned/standardized payment/performance records.
-- Maps to: FR-2 | Week: 3, 5
--
-- TODO: conform payment records from {{ source('bronze', 'payments_raw') }}.
-- This is also where late-arriving records (from
-- ingestion/synthetic/late_arrival_injector.py) enter the pipeline — think
-- carefully about which timestamp (event date vs. ingestion date) downstream
-- aggregates should key off of.

select null as payment_id  -- TODO
