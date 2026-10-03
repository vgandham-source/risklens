"""
Bronze ingestion: loan performance / payment records.

Maps to: FR-1 (Ingestion)
Week:    2

TODO: land raw performance/payment data into Bronze. This is also the table
that ingestion/synthetic/late_arrival_injector.py will inject deliberately
delayed records into later (Week 5) — keep the ingestion_date partitioning
here compatible with that.
"""


def load_payments() -> None:
    raise NotImplementedError("Implement Bronze ingestion for payment records (FR-1).")


if __name__ == "__main__":
    load_payments()
