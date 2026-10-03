"""
RiskLens end-to-end pipeline DAG.

Maps to: FR-4 (Orchestration & Reliability)
Week:    8

TODO:
  1. Implement Bronze -> Silver -> Gold as a proper task dependency chain
     (don't run Gold if Silver failed — see FR-4).
  2. Configure retries with backoff on tasks that call external systems
     (ingestion, warehouse queries).
  3. Configure this DAG to support backfills for an arbitrary historical
     date range (Airflow: schedule_interval + catchup semantics and/or an
     explicit backfill CLI invocation; Dagster: partitions).
  4. Add SLA tracking (Airflow: `sla` parameter per task / SLA miss
     callback; Dagster: run duration sensors or equivalent) and wire a
     failure notification (Slack/email/webhook - see .env.example for
     SLACK_WEBHOOK_URL) for both task failures and SLA misses.

This file assumes Airflow syntax as an example scaffold. If you chose
Dagster instead, replace this file with an equivalent job/asset definition
under orchestration/ and update docs/runbook.md accordingly.
"""

from datetime import datetime, timedelta

from airflow import DAG
from airflow.operators.python import PythonOperator

default_args = {
    "owner": "risklens",
    "retries": 3,
    "retry_delay": timedelta(minutes=5),
}


def ingest_bronze(**context):
    raise NotImplementedError("Wire up ingestion/sources/*.py (FR-1).")


def run_silver(**context):
    raise NotImplementedError("Trigger dbt run --select staging+ (FR-2).")


def test_silver(**context):
    raise NotImplementedError("Trigger dbt test --select staging+ (FR-2/FR-3).")


def run_gold(**context):
    raise NotImplementedError("Trigger dbt run --select marts (FR-2/FR-5).")


def test_gold(**context):
    raise NotImplementedError("Trigger dbt test --select marts (FR-3).")


with DAG(
    dag_id="risklens_pipeline",
    default_args=default_args,
    description="Bronze -> Silver -> Gold batch pipeline for RiskLens",
    schedule_interval="@daily",
    start_date=datetime(2024, 1, 1),
    catchup=False,  # TODO: revisit for backfill support (FR-4)
    tags=["risklens", "bronze", "silver", "gold"],
) as dag:

    t_ingest = PythonOperator(task_id="ingest_bronze", python_callable=ingest_bronze)
    t_silver_run = PythonOperator(task_id="run_silver", python_callable=run_silver)
    t_silver_test = PythonOperator(task_id="test_silver", python_callable=test_silver)
    t_gold_run = PythonOperator(task_id="run_gold", python_callable=run_gold)
    t_gold_test = PythonOperator(task_id="test_gold", python_callable=test_gold)

    t_ingest >> t_silver_run >> t_silver_test >> t_gold_run >> t_gold_test
