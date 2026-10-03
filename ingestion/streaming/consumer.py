"""
Streaming consumer / windowed aggregation entry point.

Maps to: FR-6 (Streaming Extension — windowed aggregation, late-event handling)
Week:    10-11

TODO:
  1. Consume events from the topic producer.py publishes to.
  2. Land raw events into Bronze's streaming zone (append-only, same
     convention as batch Bronze).
  3. Implement windowed aggregation (tumbling/sliding — your choice,
     documented) using your chosen stream-processing tool (Spark
     Structured Streaming, Flink, or ksqlDB) rather than plain Python,
     since watermarking/late-event semantics are a core requirement here.
  4. Route processed streaming data through the SAME Silver/Gold dbt
     models the batch path uses — do not fork the logic.
"""


def run_streaming_pipeline() -> None:
    raise NotImplementedError(
        "Implement streaming consumption + windowed aggregation (FR-6)."
    )


if __name__ == "__main__":
    run_streaming_pipeline()
