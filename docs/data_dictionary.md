# Data dictionary

TODO: this should end up auto-generated where possible (dbt's built-in
docs/lineage graph covers most of Silver and Gold — see `make dbt-docs`).
Use this file for anything dbt docs doesn't capture on its own:

- The primary data source, exact date range, and sampling approach you
  used (this was intentionally left for you to decide — see the Dataset
  Info Sheet — document your reasoning here).
- What the synthetic generators produce and why (borrower history,
  late-arrival injection, streaming events) — these aren't real data, so
  anyone reading dashboard numbers later needs to know that.
- Any field-level decisions worth flagging (e.g., how you handled a
  messy or ambiguous raw column).
