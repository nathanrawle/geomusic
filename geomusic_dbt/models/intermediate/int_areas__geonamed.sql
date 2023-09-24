{{
    config(
        materialized = "table"
    )
}}

WITH areas_gnid_extracted AS (
    SELECT
        *,
        SUBSTRING("url", '[0-9]+')::integer AS geoname_id
    FROM {{ ref('int_areas_urls__joined') }}
    WHERE LOWER(link_type_name) = 'geonames'
),
geonames AS (
    SELECT *
    FROM {{ ref('stg_geonames__geonames') }}
)
SELECT *
FROM areas_gnid_extracted age_
JOIN geonames g
    USING (geoname_id)
