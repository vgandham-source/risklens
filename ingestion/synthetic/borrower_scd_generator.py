"""
Synthetic generator: simulated borrower attribute changes over time.

Maps to: FR-2 (Slowly Changing Dimensions — SCD Type 2)
Week:    4

Why this exists: the raw Lending Club dataset is a single static snapshot
per loan — it has no history of a borrower's income, DTI, or employment
length changing over time. To meaningfully implement and test SCD Type 2
in Silver, you need a dataset that actually has changes to track.

TODO:
  1. Pick a subset of borrowers from the raw data.
  2. Generate plausible periodic snapshots (e.g., quarterly) of their
     annual_inc, dti, emp_length, and credit fields, with small realistic
     drifts over time (not random noise — think about what's plausible:
     income tends to rise gradually, DTI shifts with it, etc.).
  3. Land the generated snapshots into Bronze in a way Silver's SCD Type 2
     logic can consume (e.g., one row per borrower per snapshot date).

This script's OUTPUT is synthetic; its LOGIC is a required deliverable —
document your assumptions about what "plausible drift" means.
"""


def generate_borrower_history() -> None:
    raise NotImplementedError(
        "Implement synthetic borrower attribute history generation (FR-2 / SCD2)."
    )


if __name__ == "__main__":
    generate_borrower_history()
