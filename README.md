# RiskLens

A batch-first loan portfolio risk analytics platform, built on a Bronze /
Silver / Gold (Medallion) architecture, with a real-time streaming
extension and full production-grade engineering practices.

This repo is a **skeleton** — folder structure, tooling configuration, and
scaffolding are in place; the actual pipeline logic is left for you to
implement against the Project Charter and Weekly Milestones documents you
were given separately.

## Before you start

Read these, in order, if you haven't already:
1. Project Charter (goals, scope, functional requirements, Definition of Done)
2. Dataset Info Sheet (source, and what's left for you to figure out)
3. Weekly Milestones (what to build, and what to learn, each week)

## Repository structure

```
.
├── .github/workflows/       CI: lint, unit tests, dbt build/test
├── docker/                  Dockerfiles for airflow, dbt, ingestion
├── docker-compose.yml       Local dev stack (orchestrator + Kafka/Redpanda)
├── infra/                   Terraform: environments (dev/staging/prod) + modules
├── ingestion/
│   ├── sources/             Bronze ingestion scripts (FR-1)
│   ├── synthetic/           SCD2 + late-arrival generators (FR-2)
│   └── streaming/           CDC-style producer/consumer (FR-6)
├── orchestration/
│   └── dags/                Pipeline DAG (FR-4)
├── transform/risklens_dbt/  dbt project: staging -> intermediate -> marts
├── quality/                 Data quality / observability configs (FR-3)
├── dashboards/               BI dashboard exports/links (FR-5)
├── docs/                     Architecture, data dictionary, runbook
└── tests/                    Python unit tests
```

## Getting started

```bash
cp .env.example .env        # fill in your warehouse credentials
make setup                  # install Python deps + pre-commit hooks
make docker-up               # start local orchestrator + Kafka/Redpanda
make tf-init && make tf-plan # review infra changes for your environment (ENV=dev make tf-plan)
```

See the `Makefile` (`make help`) for every available command, and
`docs/runbook.md` for day-to-day operational instructions once the
pipeline is built out.

## Conventions

- **Every substantive file in this skeleton has a `TODO` comment** stating
  what it needs, which FR it maps to, and which week it belongs to. Start
  by grepping for `TODO`:
  ```bash
  grep -rn "TODO" --include="*.py" --include="*.sql" --include="*.tf" .
  ```
- Raw data is never committed — see `.gitignore` and `docs/data_dictionary.md`.
- All changes go through a pull request; CI must pass before merge. See
  `CONTRIBUTING.md`.
- Don't commit secrets. Use `.env` (gitignored) locally and your CI/CD
  provider's secret store in pipelines.

## License

MIT — see `LICENSE`.
