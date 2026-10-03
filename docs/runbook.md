# Runbook

TODO: write this as if handing the system to another engineer who has
never seen it. At minimum, cover:

## Running the pipeline
- How to run the full Bronze -> Silver -> Gold pipeline locally
  (`make docker-up`, then...?).
- How to run it in a scheduled/production context.

## Backfilling
- How to backfill a specific historical date range (FR-4).

## Responding to failures
- Where alerts show up (Slack/email/webhook) and what to check first for:
  - A failed DAG task
  - A failed dbt test
  - An anomaly-detection flag
  - A missed SLA

## Environments
- How dev -> staging -> prod promotion actually works in this repo (FR-7).

## Known limitations
- Be honest here. Every real system has known gaps — document yours
  rather than letting someone discover them the hard way.
