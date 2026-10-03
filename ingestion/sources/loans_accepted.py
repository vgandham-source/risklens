"""
Bronze ingestion: accepted loans (loan applications that were funded).

Maps to: FR-1 (Ingestion)
Week:    2

TODO:
  1. Read the raw accepted-loans file (see docs/data_dictionary.md for the
     expected source and date-range/sampling decision you documented in
     Week 1).
  2. Land it into the Bronze schema, partitioned by an ingestion_date column
     (do not transform/clean here — that's Silver's job).
  3. Make this idempotent: re-running for the same ingestion_date must not
     create duplicate rows. A common pattern is "delete + insert" or a
     merge on (ingestion_date, natural key) rather than blind append.

Do not hardcode credentials. Read warehouse connection details from
environment variables (see .env.example).
"""


def load_accepted_loans() -> None:
    raise NotImplementedError("Implement Bronze ingestion for accepted loans (FR-1).")


if __name__ == "__main__":
    load_accepted_loans()
