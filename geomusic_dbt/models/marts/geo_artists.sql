WITH areas_geonamed AS (
    SELECT *
    FROM {{ ref('int_areas_geonamed__deduplicated') }}
),
artists AS (
    SELECT *
    FROM {{ ref('stg_musicbrainz__artists') }}
)
SELECT *
FROM artists a
JOIN areas_geonamed ag
    ON a.artist_canonical_area_id = ag.area_id
