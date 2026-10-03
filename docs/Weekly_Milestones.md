# RiskLens — Week-by-Week Milestones
### For Engineers

---

## 1. Sequencing Philosophy

Given the full scope locked in Step 1 (FR-1 through FR-7, Medallion architecture, streaming extension, and full engineering rigor), this 12-week plan is sequenced so that:

- **Foundational layers come first** (Bronze → Silver → Gold) before anything that depends on them (orchestration, quality/observability, streaming).
- **Heavier, higher-risk work** (SCD Type 2, late-arriving data, streaming) is placed mid-program, once the engineer has a working baseline pipeline to build on top of — not attempted cold in Week 1.
- **Infrastructure/CI-CD/containerization** is threaded in progressively rather than dumped in one week, since it's most naturally built alongside the thing it's supporting.
- **Week 12 is a hardening/buffer week**, not new-feature work — given the scope, some slippage into it should be expected and planned for, not treated as failure.

Each week now has three parts:
- **What you'll learn** — the underlying data engineering concepts/theory behind the week's work, so the build isn't just following steps blindly.
- **What you'll implement** — the concrete objectives for the week.
- **Deliverables** — what must exist by the end of the week, and which Charter requirement(s) (FR-#) it maps to.

---

## Week 1 — Foundations & Setup
**Maps to:** Program setup (precedes FR-1)

**What you'll learn**
- The end-to-end data engineering lifecycle (source systems → ingestion → transformation → serving) and where each piece of RiskLens sits in it.
- Why Medallion (Bronze/Silver/Gold) architecture exists as a pattern, and what problem it solves versus a single-layer pipeline.
- Why sampling and date-range decisions matter — the tradeoff between representativeness, cost, and iteration speed.

**What you'll implement**
- Set up warehouse account (Snowflake or BigQuery), Git repo, local dev environment.
- Download and explore the primary dataset; make and document the date-range/sampling decision.
- Draft an initial architecture diagram (Bronze/Silver/Gold + streaming, even if empty boxes at this stage).

**Deliverables**
- Repo initialized with base folder structure and README stub.
- Dataset downloaded, explored, sampling decision documented.
- Architecture diagram v1 committed.

---

## Week 2 — Bronze Ingestion
**Maps to:** FR-1, FR-7 (IaC groundwork)

**What you'll learn**
- Bronze-layer principles: schema-on-read, immutability, and why raw data should never be transformed on the way in.
- Idempotency — why an ingestion job must be safe to re-run, and common patterns for achieving it (upserts, partition overwrite, dedup keys).
- Infrastructure as Code fundamentals: why declarative, version-controlled infra provisioning beats manual ("click-ops") setup.

**What you'll implement**
- Build ingestion scripts to land raw loan, performance, and rejected-loan data into Bronze.
- Ensure ingestion is idempotent (safe to re-run without duplication).
- Begin provisioning the warehouse/schemas via Infrastructure as Code (Terraform or equivalent).

**Deliverables**
- Bronze tables populated from raw source data.
- Ingestion script is re-runnable without creating duplicates.
- IaC scripts provision at least the Bronze schema/dataset.

---

## Week 3 — Silver Layer: Cleaning & Conforming
**Maps to:** FR-2 (core cleaning)

**What you'll learn**
- Data cleaning and standardization principles: type casting, null handling, deduplication strategy.
- What a "conformed" entity means and why Silver's job is to produce one consistent shape of `loans`/`borrowers`/`payments`, regardless of source quirks.
- dbt project structure (sources, staging models) and test-driven data modeling — writing tests as part of building a model, not after.

**What you'll implement**
- Build dbt staging models that clean, standardize, and conform Bronze data into consistent entities (`loans`, `borrowers`, `payments`).
- Implement first round of dbt tests (not-null, accepted values, referential integrity).

**Deliverables**
- Silver conformed tables in place.
- dbt staging models documented and passing tests.

---

## Week 4 — Silver Layer: Slowly Changing Dimensions
**Maps to:** FR-2 (SCD Type 2)

**What you'll learn**
- Slowly Changing Dimensions: Type 1 (overwrite) vs Type 2 (historized) vs Type 3 (limited history), and why Type 2 is the standard for auditable financial data.
- Effective-dating concepts (valid-from/valid-to, current-flag) used to implement SCD Type 2.
- Basics of synthetic data generation for simulating realistic change-over-time when the source data is a static snapshot.

**What you'll implement**
- Build the synthetic borrower-attribute-change generator (simulating periodic updates to income, DTI, employment length, credit fields).
- Implement SCD Type 2 logic on the borrower dimension so historical changes are tracked, not overwritten.

**Deliverables**
- Synthetic generator script committed to the repo.
- `dim_borrower` implemented as SCD Type 2, with at least one borrower demonstrably having tracked history.

---

## Week 5 — Silver Layer: Late-Arriving Data
**Maps to:** FR-2 (late-arriving data handling)

**What you'll learn**
- Late-arriving/out-of-order data as a real-world phenomenon — why records don't always arrive in event order, and why naive pipelines silently produce wrong aggregates when this happens.
- Event-time vs. processing-time, a foundational distinction that will matter again in the streaming weeks.
- Idempotent reprocessing — how to correct an aggregate when new information arrives, without duplicating or corrupting what's already there.

**What you'll implement**
- Build a script that deliberately re-lands a subset of payment records later than their true event date.
- Implement Silver-layer logic that correctly reprocesses affected aggregates when late data arrives, without corrupting existing history.

**Deliverables**
- Late-arrival injector script committed.
- A documented before/after test case showing a late record being correctly incorporated.

---

## Week 6 — Gold Layer: Dimensional Model
**Maps to:** FR-2 (point-in-time correctness), FR-5 (foundation)

**What you'll learn**
- Dimensional modeling fundamentals: star schema, fact vs. dimension tables, grain, and surrogate keys.
- Point-in-time correctness and data leakage — why a risk metric must reflect what was knowable *at the time*, not information from the future.
- How SCD Type 2 dimensions (built in Week 4) get joined correctly in a fact table without silently using "current" values for historical rows.

**What you'll implement**
- Build the Gold-layer dimensional model: `fact_loans` plus supporting dimensions (`dim_borrower` [SCD2], `dim_time`, `dim_credit_grade`, `dim_loan_purpose`, `dim_geography`).
- Ensure Gold marts are point-in-time correct — reflecting what was known at loan issuance, not retroactively updated values.

**Deliverables**
- Fact/dimension tables built and validated (row counts and key totals reconciled against Silver).
- Point-in-time correctness explicitly tested/documented for at least one mart.

---

## Week 7 — Gold Layer: Analytics Marts & Dashboard
**Maps to:** FR-5, feature-store mart (Scope §5/§6)

**What you'll learn**
- The analytics engineering mindset: a Gold mart is a contract with its consumers (dashboards, analysts) — stable, documented, and intentional about what it exposes.
- Basics of survival analysis (how long something "survives" before an event, here: default) as a way of summarizing time-to-event data.
- Why a feature-store mart must be point-in-time correct if it's ever going to responsibly feed a future ML model, and why that's a data engineering concern, not a data science one.

**What you'll implement**
- Build all required analytics marts: default rate by grade, purpose, geography, borrower segment (income × DTI), loan term, home-ownership status, and issue vintage, plus cohort survival analysis and portfolio KPIs.
- Build the point-in-time correct `ml_features` mart.
- Connect a BI tool and build the dashboard surfacing all required views.

**Deliverables**
- All required Gold marts built, tested, and documented.
- `ml_features` mart in place.
- Working BI dashboard covering every required view (pipeline-health view comes in Week 9, once observability exists).

---

## Week 8 — Orchestration & Reliability
**Maps to:** FR-4

**What you'll learn**
- Orchestration fundamentals: DAGs, task dependencies, and why pipelines should fail loudly and stop rather than silently propagate bad data downstream.
- Retry and backoff strategies, and the difference between a transient failure (worth retrying) and a systemic one (retrying won't help).
- Backfills and SLAs as operational concepts — how real pipelines get "fixed" for the past, and how teams define and monitor "on time."

**What you'll implement**
- Build the orchestration DAG (Airflow or Dagster) automating the full Bronze → Silver → Gold pipeline, respecting task dependencies.
- Implement retry policies and graceful partial-failure handling.
- Implement backfill support for a specific historical date range.
- Implement SLA tracking/reporting for pipeline runs.

**Deliverables**
- Scheduled DAG runs end-to-end successfully.
- A demonstrated backfill of a past date range on demand.
- Retry behavior demonstrated (e.g., a deliberately failing task recovers on retry).

---

## Week 9 — Data Quality & Observability
**Maps to:** FR-3

**What you'll learn**
- The difference between data *tests* (fixed rules: not-null, accepted values) and data *observability* (detecting the unexpected, which you didn't write an explicit rule for).
- Basic anomaly detection approaches (e.g., statistical thresholds on day-over-day change) and their limits.
- Data lineage — why being able to trace a Gold-layer number back to its Bronze source is essential for trust and debugging, not just documentation for its own sake.

**What you'll implement**
- Extend the Silver/Gold test suite with anomaly detection (e.g., unusual day-over-day shifts in default rate or ingestion volume).
- Build a data quality dashboard showing test pass/fail history over time.
- Implement alerting for pipeline or quality-test failures.
- Document/visualize table- or column-level lineage.
- Build the Gold-layer pipeline-health view (completing the last of the 9 required FR-5 views).

**Deliverables**
- Anomaly detection demonstrably flags an injected bad-data scenario.
- Quality-history dashboard live.
- Alerting fires on a deliberate failure.
- Lineage graph/documentation produced.

---

## Week 10 — Streaming Extension: Ingestion & Integration
**Maps to:** FR-6 (core)

**What you'll learn**
- Streaming fundamentals: publish/subscribe, topics, and partitions, and how they differ conceptually from a batch file/table.
- Change Data Capture (CDC) as a pattern for turning "state changes in a system" into an event stream.
- The core batch-vs-streaming tradeoff: latency and freshness versus simplicity and cost.

**What you'll implement**
- Build the CDC-style event replay/generator script simulating new loan applications or payment events.
- Set up Kafka or Redpanda and land streaming events into a Bronze streaming zone.
- Route streaming data through the existing Silver/Gold logic (reuse, don't fork).

**Deliverables**
- Streaming generator running and publishing events.
- Streaming events flowing end-to-end into Gold using the same pipeline logic as the batch path.

---

## Week 11 — Streaming Depth, CI/CD & Containerization
**Maps to:** FR-6 (completion), FR-7

**What you'll learn**
- Windowing strategies in stream processing (tumbling, sliding, session windows) and when each is appropriate.
- Watermarking — how streaming systems decide "how late is too late" for an event to still be included in a window.
- CI/CD principles (why tests should gate merges, not just exist) and containerization principles (why "works on my machine" is a real engineering risk to design against), plus environment promotion (dev → staging → prod) as a governance pattern.

**What you'll implement**
- Implement windowed aggregation (e.g., rolling default counts/application volume over a defined window).
- Implement late/out-of-order event handling (watermarking or equivalent) in the streaming path.
- Build the CI/CD pipeline (e.g., GitHub Actions) running dbt tests and lint checks on every pull request.
- Containerize ingestion, dbt, and orchestration for local development (Docker/docker-compose).
- Implement dev/staging/prod-style environment separation with a documented promotion process.

**Deliverables**
- Windowed aggregation and late-event handling demonstrated with a test case.
- CI pipeline green on a pull request.
- `docker-compose` (or equivalent) spins up a working local dev stack.
- Environment separation documented and demonstrated.

---

## Week 12 — Hardening, Documentation & Final Review
**Maps to:** Non-Functional Requirements, Definition of Done (all FRs)

**What you'll learn**
- Why documentation, runbooks, and reproducibility are treated as first-class engineering deliverables in real teams, not "nice to have" afterthoughts.
- How to self-assess a build against a Definition of Done rather than assuming "it runs on my machine" is sufficient.
- How to communicate a technical system concisely to someone who didn't build it (the demo walkthrough).

**What you'll implement**
- Buffer week for catching up on any slipped work from Weeks 1–11.
- Finalize README, architecture diagram, data dictionary, and runbook.
- Self-check the full build against the Charter's Definition of Done (Section 10).
- Prepare a short demo walkthrough of the platform.

**Deliverables**
- Complete, documented, reproducible repository.
- Definition of Done self-checklist completed.
- Demo-ready platform.

---

## 2. Milestone Summary Table

| Week | Focus | Primary FR(s) |
|---|---|---|
| 1 | Foundations & setup | — |
| 2 | Bronze ingestion | FR-1, FR-7 |
| 3 | Silver: cleaning & conforming | FR-2 |
| 4 | Silver: SCD Type 2 | FR-2 |
| 5 | Silver: late-arriving data | FR-2 |
| 6 | Gold: dimensional model | FR-2, FR-5 |
| 7 | Gold: analytics marts & dashboard | FR-5 |
| 8 | Orchestration & reliability | FR-4 |
| 9 | Data quality & observability | FR-3 |
| 10 | Streaming: ingestion & integration | FR-6 |
| 11 | Streaming depth, CI/CD, containerization | FR-6, FR-7 |
| 12 | Hardening & documentation | All (DoD check) |
