"""
CDC-style streaming event producer.

Maps to: FR-6 (Streaming Extension)
Week:    10-11

Simulates a live feed of new loan application or payment events, since no
real live API exists for 2007-2018 historical data. Publishes to
Kafka/Redpanda on the topic configured via STREAMING_TOPIC (see .env.example).

TODO:
  1. Read from the historical dataset (or generate new synthetic rows in the
     same schema) and emit them as events at a configurable rate.
  2. Support deliberately emitting some events out of order / delayed, so
     the consumer side (Week 11) has something real to test watermarking
     against.
  3. Keep the event schema consistent with what Bronze's streaming zone and
     the shared Silver/Gold dbt logic expect (FR-6: "reuse, don't fork, the
     pipeline").
"""

import os

BOOTSTRAP_SERVERS = os.environ.get("KAFKA_BOOTSTRAP_SERVERS", "localhost:9092")
TOPIC = os.environ.get("STREAMING_TOPIC", "risklens.loan_events")


def produce_events() -> None:
    raise NotImplementedError(
        "Implement the CDC-style event producer (FR-6): read/generate events "
        "and publish them to Kafka/Redpanda."
    )


if __name__ == "__main__":
    produce_events()
