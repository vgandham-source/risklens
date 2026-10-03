-- State/region reference dimension. Maps to: FR-2 | Week: 6
-- TODO: this is the "lightweight reference data" mentioned in the Dataset
-- Definition doc (state code -> state name -> region) — build or source a
-- small static table and seed it (see dbt seeds, or a static CTE here).

select
    null as geography_key  -- TODO
