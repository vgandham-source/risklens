FROM apache/airflow:2.9.3-python3.11

USER airflow
COPY ingestion/requirements.txt /requirements-ingestion.txt
RUN pip install --no-cache-dir -r /requirements-ingestion.txt

# DAGs/plugins/config are bind-mounted in docker-compose.yml for local dev,
# so no COPY is needed here for those.
