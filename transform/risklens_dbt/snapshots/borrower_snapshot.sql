-- SCD Type 2 snapshot for borrower attributes.
-- Maps to: FR-2 (Slowly Changing Dimensions) | Week: 4
--
-- dbt's native `snapshot` feature is the recommended way to implement SCD
-- Type 2 here — it manages valid_from/valid_to and is_current for you.
-- TODO: point this at stg_borrowers (fed by the synthetic history
-- generator) and switch to strategy='timestamp' + updated_at='updated_at'
-- once that column is implemented upstream. Using 'check' for now since
-- stg_borrowers is still a stub with only borrower_id.

{% snapshot borrower_snapshot %}

{{
    config(
      target_schema='silver',
      unique_key='borrower_id',
      strategy='check',
      check_cols=['borrower_id'],
    )
}}

select * from {{ ref('stg_borrowers') }}

{% endsnapshot %}
