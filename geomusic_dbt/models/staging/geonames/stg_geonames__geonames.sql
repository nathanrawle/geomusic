{{
    config(
        materialized = "incremental",
        unique_key = "geoname_id",
        indexes = [
            {"columns": ["geoname_id"], "unique": True}
        ]
    )
}}

SELECT *

FROM {{ source( 'geonames', 'geonames' ) }}

{% if is_incremental() %}

  -- this filter will only be applied on an incremental run
  -- (uses > to include records whose timestamp occurred since the last run of this model)
  where gn_modification_date > (select max(gn_modification_date) from {{ this }})

{% endif %}
