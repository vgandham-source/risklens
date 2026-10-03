# Data quality & observability configs

Maps to: FR-3 | Week: 9

This is where your Great Expectations (or Soda) suite configuration lives —
whichever tool you choose per the Project Charter's reference tech stack.

TODO:
- Expectation suites for Silver (valid ranges, referential integrity,
  accepted values) and Gold (aggregate reconciliation).
- Anomaly-detection checks (e.g., unusual day-over-day shifts in default
  rate or ingestion volume) — document your threshold logic in
  docs/runbook.md, since "what counts as anomalous" is a judgment call
  you're expected to make and justify.
- Wire failures to the alerting channel configured via SLACK_WEBHOOK_URL
  in .env.example.
