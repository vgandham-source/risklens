# Custom / anomaly-detection checks

Maps to: FR-3 | Week: 9

If you implement anomaly detection outside of Great Expectations/Soda
(e.g., a small Python script comparing today's default rate to a rolling
average), put that logic here rather than burying it in a dbt model or the
DAG file, so it's easy to find and test independently.
