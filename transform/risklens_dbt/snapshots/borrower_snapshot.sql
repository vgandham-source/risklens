-- SCD Type 2 snapshot for borrower attributes.
-- Maps to: FR-2 (Slowly Changing Dimensions) | Week: 4
--
-- dbt's native `snapshot` feature is the recommended way to implement SCD
-- Type 2 here — it manages valid_from/valid_to and is_current for you.
-- TODO: point this at stg_borrowers (fed by the synthetic history
-- generator) and choose an appropriate strategy (`timestamp` if the source
-- has a reliable updated_at, `check` against specific columns otherwise).

{% snapshot borrower_snapshot %}

{{
    config(
      target_schema='silver',
      unique_key='borrower_id',
      strategy='timestamp',
      updated_at='updated_at',
    )
}}

select * from {{ ref('stg_borrowers') }}

{% endsnapshot %}
