"""
Bronze ingestion: rejected loan applications.

Maps to: FR-1 (Ingestion)
Week:    2

TODO: same requirements as loans_accepted.py — land raw, idempotent,
partitioned by ingestion_date. Note the rejected-loans schema is smaller
and different from the accepted-loans schema; don't force them into one
table at Bronze.
"""


def load_rejected_loans() -> None:
    raise NotImplementedError("Implement Bronze ingestion for rejected loans (FR-1).")


if __name__ == "__main__":
    load_rejected_loans()
