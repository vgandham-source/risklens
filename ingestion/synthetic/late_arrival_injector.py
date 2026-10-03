"""
Synthetic generator: deliberately late-arriving payment records.

Maps to: FR-2 (late-arriving data handling)
Week:    5

TODO:
  1. Take a subset of real payment/performance records.
  2. Re-land them into Bronze with an ingestion_date LATER than their true
     event date (e.g., a March payment event that shows up in the April
     ingestion batch).
  3. Use this to test that your Silver-layer logic correctly reprocesses
     affected aggregates without corrupting already-computed history —
     that correctness logic lives in Silver, not here. This script's only
     job is to realistically simulate the lateness.
"""


def inject_late_arrivals() -> None:
    raise NotImplementedError(
        "Implement late-arriving payment record injection (FR-2)."
    )


if __name__ == "__main__":
    inject_late_arrivals()
