.PHONY: help setup lint dbt-deps dbt-run dbt-test dbt-docs dag-up dag-down \
        docker-up docker-down tf-init tf-plan tf-apply ingest-bronze \
        gen-synthetic streaming-produce test

help:
	@echo "RiskLens — common commands"
	@echo "  make setup            Install local Python dependencies + pre-commit hooks"
	@echo "  make lint             Run ruff + sqlfluff + terraform fmt checks"
	@echo "  make test             Run Python unit tests (ingestion + synthetic generators)"
	@echo "  make ingest-bronze    Run all Bronze ingestion scripts"
	@echo "  make gen-synthetic    Run synthetic data generators (SCD2, late-arrival, streaming seed)"
	@echo "  make dbt-deps         Install dbt packages"
	@echo "  make dbt-run          Run all dbt models"
	@echo "  make dbt-test         Run all dbt tests"
	@echo "  make dbt-docs         Generate and serve dbt docs (includes lineage graph)"
	@echo "  make docker-up        Start local dev stack (Airflow/Dagster, Kafka/Redpanda, etc.)"
	@echo "  make docker-down      Stop local dev stack"
	@echo "  make tf-init          Initialize Terraform for the current environment"
	@echo "  make tf-plan          Show Terraform plan for the current environment"
	@echo "  make tf-apply         Apply Terraform for the current environment"

setup:
	python -m pip install -r ingestion/requirements.txt
	pre-commit install

lint:
	ruff check .
	sqlfluff lint transform/risklens_dbt/models
	terraform fmt -check -recursive infra/

test:
	pytest tests/

ingest-bronze:
	python ingestion/sources/loans_accepted.py
	python ingestion/sources/loans_rejected.py
	python ingestion/sources/payments.py

gen-synthetic:
	python ingestion/synthetic/borrower_scd_generator.py
	python ingestion/synthetic/late_arrival_injector.py

streaming-produce:
	python ingestion/streaming/producer.py

dbt-deps:
	cd transform/risklens_dbt && dbt deps

dbt-run:
	cd transform/risklens_dbt && dbt run

dbt-test:
	cd transform/risklens_dbt && dbt test

dbt-docs:
	cd transform/risklens_dbt && dbt docs generate && dbt docs serve

docker-up:
	docker compose up -d

docker-down:
	docker compose down

tf-init:
	cd infra/environments/$${ENV:-dev} && terraform init

tf-plan:
	cd infra/environments/$${ENV:-dev} && terraform plan

tf-apply:
	cd infra/environments/$${ENV:-dev} && terraform apply
