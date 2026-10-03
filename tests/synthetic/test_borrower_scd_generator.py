"""
Unit tests for ingestion/synthetic/borrower_scd_generator.py.

TODO: test that generated borrower snapshots are plausible (e.g., no wild
income swings between consecutive snapshots) and that the output shape
matches what stg_borrowers / the SCD2 snapshot expects.
"""

import pytest


@pytest.mark.skip(reason="TODO: implement once borrower_scd_generator.py is built")
def test_generated_history_is_plausible():
    ...
