{{
    config(
        materialized = "materialized_view",
        indexes = [
            {"columns": ["geoname_id"], "unique": True}
        ]
    )
}}

SELECT * FROM {{ source( 'geonames', 'geonames' ) }}
