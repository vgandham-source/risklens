# RiskLens — Loan Portfolio Risk Analytics Platform
###  Data Engineering Industry Program — Project Charter (Step 1 of 4)

---

## 1. Program Context

- **Format:** 12-week, self-directed project-based learning. No classroom sessions.
- **Working mode:** Solo implementation, individually assigned.
- **Philosophy:** Engineers learn data engineering principles *through building*, not through lectures. This document — plus the dataset spec, weekly milestones, and GitHub starter repo that follow — is their primary source of truth.

---

## 2. Project Title & One-Line Summary

**RiskLens** — a batch-first data platform that ingests historical loan application and performance data, models it through a Medallion (Bronze/Silver/Gold) architecture, and produces portfolio risk analytics that a bank's risk and finance teams would actually use — with a real-time streaming extension and production-grade engineering practices built in as core requirements.

---

## 3. Business Context (the "why")

Lending institutions need to continuously answer: *"Where in our loan portfolio is risk concentrated, and is it getting worse?"* Risk and finance teams use this kind of analysis for:

- **Risk-based pricing** — setting interest rates by grade/segment
- **Underwriting policy** — tightening or loosening approval criteria for risky segments
- **Loss provisioning** — reserving capital against expected defaults
- **Portfolio concentration limits** — capping exposure to any one risky segment
- **Early-warning monitoring** — spotting deteriorating loan vintages before losses materialize

RiskLens simulates the data platform a bank's data engineering team would build to make all of the above possible — **not** a credit-scoring or loan-approval model. The engineer is not building a predictive model; they are building the reliable, well-modeled, quality-checked, production-grade data foundation that risk/finance analytics depends on.

---

## 4. Project Goals

### 4.1 Learning goals (what the engineer must demonstrate)
1. Design and build a multi-layer (Bronze/Silver/Gold) data pipeline from raw source data to business-ready marts.
2. Apply data modeling principles — including slowly changing dimensions and point-in-time correctness — to a real-world financial dataset.
3. Implement automated, reliable orchestration of a multi-step pipeline (Airflow or Dagster), including retries, backfills, and failure handling.
4. Implement transformation logic using dbt, including tests, documentation, and incremental models.
5. Implement data quality checks, anomaly detection, and observability — not just pass/fail tests, but visibility into pipeline health over time.
6. Load and query data in a cloud warehouse (Snowflake or BigQuery).
7. Produce business-ready analytics outputs (dashboards/marts) that answer real risk questions.
8. Build a streaming ingestion path with windowed aggregation and late-arriving/out-of-order event handling, and articulate the tradeoffs between batch and streaming.
9. Practice full engineering rigor: version control, CI/CD, infrastructure as code, containerization, environment separation, and documentation.

### 4.2 Business/product goals (what the platform must deliver)
1. Answer: *"Which segments of our loan portfolio are highest risk?"* (by grade, purpose, geography, borrower profile, loan term, home-ownership status)
2. Answer: *"Is portfolio risk improving or worsening over time?"* (vintage/cohort trend, survival analysis)
3. Provide a reliable, tested, documented, observable data foundation — not a one-off analysis notebook.
4. Demonstrate a live event feed flowing through the same architecture as the batch path, with correct handling of real-world streaming complications (late data, windowing).
5. Demonstrate that the platform is operable: deployable via CI/CD, provisioned via code, and monitored.

---

## 5. Scope

### In scope
- Batch ingestion of historical loan application, origination, and performance data
- Bronze → Silver → Gold pipeline using dbt, including incremental models where appropriate
- Slowly Changing Dimensions (SCD Type 2) on borrower attributes, with point-in-time correct marts
- Late-arriving data handling in the batch path
- Orchestration with backfill support, retry/failure-handling policies, and SLA monitoring
- Data quality tests, anomaly detection, a quality/observability dashboard, and failure alerting
- Gold-layer analytics marts covering: risk by grade, purpose, geography, borrower segment (income × DTI), loan term, home-ownership status, and issue vintage, plus cohort survival analysis
- A dashboard (BI tool of choice) surfacing all required analytics views and pipeline health
- A streaming extension with windowed aggregation and late/out-of-order event handling (CDC-style event simulation)
- A point-in-time correct feature-store mart (`ml_features`) demonstrating DE's role in a future ML handoff, without training a model
- Infrastructure as Code for warehouse/orchestration provisioning
- CI/CD pipeline running dbt tests and lint checks on every change
- Containerized local development environment
- Dev/staging/prod-style environment separation
- Documentation: architecture diagram, data dictionary, README, runbook

### Out of scope
- Building or training any predictive/ML credit-scoring model
- Guaranteed low-latency/production SLA throughput on the streaming path (concept and correctness matter more than raw performance)
- Column-level access control, data masking, and audit logging
- Formal cost and performance optimization (partitioning/clustering strategy, cost tracking, tuning)
- Any real customer/PII data — dataset is public/synthetic only

---

## 6. High-Level Architecture

### 6.1 Medallion layers (mandatory)

| Layer | Purpose | Contents |
|---|---|---|
| **Bronze** | Raw, immutable, as-ingested | Raw loan applications, raw performance/payment records, raw rejected-loan records, raw streaming events — landed with minimal transformation, retaining full history |
| **Silver** | Cleaned, validated, conformed | Standardized types, deduplicated, validated, conformed into consistent entities (`loans`, `borrowers`, `payments`), with SCD Type 2 history on borrower attributes and late-arriving data reprocessing logic |
| **Gold** | Business-ready, aggregated | Dimensional model (fact/dim tables), point-in-time correct analytics marts, feature-store mart, and pipeline-observability marts |

### 6.2 Reference tech stack
- **Storage/Warehouse:** Snowflake or BigQuery (engineer's choice, standardized per engineer for the duration of their project)
- **Transformation:** dbt (staging → intermediate → marts, mirroring Silver → Gold), using incremental models where appropriate
- **Orchestration:** Airflow or Dagster, with retry, backfill, and SLA-monitoring configuration
- **Data quality & observability:** dbt tests + Great Expectations or Soda, plus anomaly-detection checks and a quality-history dashboard
- **Streaming:** Kafka or Redpanda, with stream processing (Spark Structured Streaming, Flink, or ksqlDB) for windowed aggregation
- **Infrastructure as Code:** Terraform (or equivalent) for warehouse/orchestration provisioning
- **CI/CD:** GitHub Actions (or equivalent) running dbt tests/lint on every pull request
- **Containerization:** Docker for local development reproducibility
- **BI/Serving:** Metabase, Looker Studio, or equivalent
- **Version control:** Git/GitHub (starter skeleton repo provided separately)

### 6.3 High-level flow

```
Raw sources (loan applications, performance data, rejected loans)
        |
        v
   BRONZE  (raw landing, append-only, ingestion-date partitioned)
        |  [cleaning, validation, conforming, SCD Type 2, late-data handling]
        v
   SILVER  (conformed entities: loans, borrowers, payments)
        |  [dimensional modeling, business logic, aggregation, feature mart]
        v
   GOLD    (fact/dim tables + risk analytics marts + feature-store mart + observability marts)
        |
        v
   BI Dashboard  (risk segmentation, vintage trend, borrower segment views, pipeline health)

   [Streaming: live/CDC-style events -> Bronze (streaming) -> same Silver/Gold path,
    with windowed aggregation and late-event handling]

   [Underpinning all layers: CI/CD, Infra as Code, containerized dev environment,
    dev/staging/prod separation]
```

---

## 7. Functional Requirements

### FR-1: Ingestion
- Ingest raw loan application, performance, and rejected-loan data into Bronze.
- Ingestion must be repeatable/idempotent (re-running should not duplicate data).
- Bronze must preserve an immutable, auditable copy of source data.

### FR-2: Transformation & Modeling
- Silver layer must clean, standardize, and conform data into well-defined entities.
- Silver layer must implement **SCD Type 2** on borrower attributes (income, DTI, employment length, credit profile), so changes over time are tracked, not overwritten.
- Silver layer must correctly handle **late-arriving data** (e.g., payment records arriving out of order or delayed), reprocessing affected aggregates without corrupting history.
- Gold layer must implement a dimensional model: at minimum one fact table (`fact_loans`) and supporting dimensions (`dim_borrower` [SCD2], `dim_time`, `dim_credit_grade`, `dim_loan_purpose`, `dim_geography`).
- Gold-layer marts must be **point-in-time correct** — metrics must reflect what was known at the time a loan was issued, avoiding data leakage from future information.
- At least one dbt model must be **incremental** rather than full-refresh, with the tradeoff documented.
- All transformations implemented as version-controlled dbt models with documentation.

### FR-3: Data Quality & Observability
- Automated tests at Silver (e.g., valid ranges, referential integrity, not-null, accepted values) and Gold (e.g., aggregate reconciliation).
- **Anomaly detection**: flag unusual day-over-day shifts in default rate or ingestion volume.
- **Data quality dashboard**: a view showing test pass/fail history over time, not just current-run results.
- **Alerting**: pipeline or quality-test failures must trigger a notification (Slack/email/webhook).
- **Lineage**: table- or column-level lineage must be documented/visualized (e.g., via dbt's lineage graph or an OpenLineage-compatible tool), so a bad Gold-layer number can be traced back to its Bronze source.

### FR-4: Orchestration & Reliability
- End-to-end pipeline must run via a scheduled, orchestrated DAG — not manual script execution.
- DAG must handle task dependencies and failure states sensibly (e.g., don't run Gold if Silver failed).
- **Backfill support**: a specific historical date range must be reprocessable on demand without manual intervention.
- **Retry & failure-handling policies**: task-level retries and graceful partial-failure handling (e.g., a Silver failure must not corrupt existing Gold tables).
- **SLA monitoring**: track and report whether each pipeline run completed within an expected time window.

### FR-5: Analytics Outputs (Gold/BI)
Required views:
1. Default rate by loan grade
2. Default rate by loan purpose
3. Default rate by geography (state)
4. Default rate by borrower risk segment (income × DTI)
5. Default rate by loan term and by home-ownership status
6. Default rate trend by issue vintage (quarterly cohort)
7. Cohort survival analysis — how long loans typically survive before defaulting, by grade/vintage
8. Portfolio summary KPIs (total loans, overall default rate, portfolio value, average interest rate)
9. Pipeline health view (data quality test history, ingestion volume trend, SLA adherence)

### FR-6: Streaming Extension
- Simulate a live, **CDC-style** feed of loan application or payment events (a replay/generator script simulating change events is acceptable — no real live API required).
- Land streaming events into a Bronze streaming zone.
- Implement **windowed aggregation** (e.g., rolling default counts or application volume over a defined time window) using a stream-processing tool.
- Implement handling for **late/out-of-order events** (watermarking or equivalent logic).
- Flow streaming data through the existing Silver/Gold logic (reuse, don't fork, the pipeline).
- Document the batch vs. streaming tradeoffs observed.

### FR-7: Infrastructure, CI/CD & Environments
- Provision warehouse and orchestration infrastructure using **Infrastructure as Code** (e.g., Terraform).
- Implement a **CI/CD pipeline** (e.g., GitHub Actions) that runs dbt tests and lint checks on every pull request before merge.
- **Containerize** ingestion scripts, dbt, and orchestration for reproducible local development.
- Implement **dev/staging/prod-style environment separation** (schemas or projects), with a documented promotion process between them.

---

## 8. Non-Functional Requirements

- **Reproducibility:** A fresh clone of the repo + documented setup steps should be able to run the full pipeline end-to-end, including infra provisioning via IaC and local dev via containers.
- **Idempotency:** Re-running any stage should not corrupt or duplicate downstream data.
- **Documentation:** README, architecture diagram, data dictionary (auto-generated), and a runbook are mandatory deliverables.
- **Version control discipline:** Meaningful commit history; changes flow through CI/CD before merging.
- **Cost-awareness:** Engineer should track and manage warehouse compute/storage costs (e.g., free-tier limits, sampling large source files, incremental models).
- **Testability:** dbt tests and quality checks must be runnable independently and produce clear pass/fail output, with history retained.

---

## 9. Deliverables Checklist

- [ ] Working Bronze/Silver/Gold pipeline in a cloud warehouse, provisioned via Infrastructure as Code
- [ ] dbt project with staging, intermediate, and mart models — documented, tested, with at least one incremental model
- [ ] SCD Type 2 implementation on borrower dimension, with point-in-time correct marts
- [ ] Late-arriving data handling logic in the Silver layer
- [ ] Orchestration DAG with backfill support, retry/failure handling, and SLA monitoring
- [ ] Data quality test suite, anomaly detection, quality-history dashboard, and failure alerting
- [ ] Lineage documentation/visualization
- [ ] BI dashboard covering all 9 required analytics views (FR-5), including pipeline health
- [ ] Streaming extension with windowed aggregation and late-event handling, flowing through shared Silver/Gold logic
- [ ] Point-in-time correct feature-store mart (`ml_features`)
- [ ] CI/CD pipeline running tests/lint on every change
- [ ] Containerized local development environment
- [ ] Dev/staging/prod environment separation with documented promotion process
- [ ] README, architecture diagram, data dictionary, runbook
- [ ] Public or program-shared GitHub repository with clean commit history

---

## 10. Definition of Done

The project is considered complete when:
1. A fresh environment can clone the repo and run the pipeline end-to-end following the README, with infra provisioned via code and no undocumented manual steps.
2. All FR-1 through FR-7 requirements are functionally demonstrated.
3. Data quality tests, anomaly detection, and lineage exist and are visible; failures trigger alerts.
4. The dashboard correctly reflects Gold-layer data and answers all 9 required analytics views, including pipeline health.
5. The streaming extension is demonstrably running through the same Silver/Gold logic as the batch path, with windowed aggregation and late-event handling shown working.
6. CI/CD, containerization, and environment separation are all demonstrably in place, not just described.
7. Documentation is sufficient for a new engineer to understand and operate the system without asking the original builder.

---

## 11. Required Skillset / Technical Stack

### 11.1 Prerequisite skills (expected before starting)
- **SQL**: comfortable writing joins, aggregations, window functions, and CTEs.
- **Python**: comfortable with scripting, working with files/APIs, and basic data manipulation (e.g., pandas).
- **Git/GitHub**: comfortable with clone, branch, commit, pull request workflows.
- **Command line basics**: navigating a shell, running scripts, managing environment variables.

### 11.2 Skills built during the project (learned by doing, not prerequisites)
- Data modeling: dimensional modeling (fact/dimension design), Slowly Changing Dimensions (SCD Type 2), point-in-time correctness.
- Analytics engineering: dbt (models, tests, documentation, incremental models, lineage graph).
- Orchestration: Airflow or Dagster (DAG design, retries, backfills, scheduling).
- Data quality & observability: Great Expectations or Soda, anomaly-detection logic, alerting integrations.
- Streaming fundamentals: Kafka or Redpanda, stream processing (Spark Structured Streaming, Flink, or ksqlDB), windowing, watermarking.
- Cloud data warehousing: Snowflake or BigQuery (schema design, querying, basic administration).
- Infrastructure as Code: Terraform (or equivalent) fundamentals.
- CI/CD: GitHub Actions (or equivalent) pipeline authoring.
- Containerization: Docker fundamentals (Dockerfile, docker-compose for local multi-service setups).
- BI/visualization: Metabase, Looker Studio, or equivalent dashboard building.

### 11.3 Reference technical stack

| Layer | Tool(s) |
|---|---|
| Version control | Git / GitHub |
| Ingestion scripting | Python |
| Warehouse | Snowflake or BigQuery |
| Transformation | dbt |
| Orchestration | Airflow or Dagster |
| Data quality | dbt tests + Great Expectations or Soda |
| Streaming | Kafka or Redpanda |
| Stream processing | Spark Structured Streaming, Flink, or ksqlDB |
| Infrastructure as Code | Terraform (or equivalent) |
| CI/CD | GitHub Actions (or equivalent) |
| Containerization | Docker |
| BI / Dashboard | Metabase, Looker Studio, or equivalent |

> Engineers may substitute any tool in a row for a close equivalent (e.g., Dagster instead of Airflow, Flink instead of Spark Structured Streaming) as long as the underlying concept required by the FRs is still demonstrated.

---

