# Contributing to RiskLens

This repo is worked on solo, but it's still built like a team would build it —
following these conventions is part of the assignment, not optional polish.

## Workflow

1. Create a feature branch off `main`: `git checkout -b feat/bronze-ingestion`.
2. Make your changes with small, meaningful commits (see below).
3. Open a pull request into `main`. CI (`.github/workflows/ci.yml`) must pass
   before merging — see `docs/runbook.md` if a check fails and you're not
   sure why.
4. Squash-merge once green.

## Commit messages

Use a short imperative summary, optionally followed by a body:

```
feat(bronze): add idempotent loader for accepted loans

Uses a merge-on-load key so re-running the ingestion job for the
same ingestion_date does not duplicate rows.
```

Prefixes: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `infra`.

## Before opening a PR

- [ ] `make lint` passes locally
- [ ] `make dbt-test` passes locally (or against CI's ephemeral target)
- [ ] New models/scripts have at least minimal docs/comments
- [ ] `docs/data_dictionary.md` updated if you added/changed a model's schema
