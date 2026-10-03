"""
Unit tests for ingestion/sources/loans_accepted.py.

TODO: at minimum, test that:
  - re-running the loader for the same ingestion_date does not duplicate
    rows (idempotency, FR-1).
  - a malformed/missing source file fails loudly rather than silently
    loading partial data.
"""

import pytest


@pytest.mark.skip(reason="TODO: implement once loans_accepted.py is built")
def test_idempotent_load():
    ...
