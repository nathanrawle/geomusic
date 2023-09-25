WITH source AS (
    SELECT *
    FROM {{ ref('geo_artists_genres')}}
)
SELECT
    genre_id,
    artist_id,
    COUNT(*) AS rows_total,
    COUNT(artist_id) AS artist_rows_total,
    COUNT(DISTINCT artist_id) AS artists_unique,
    COUNT(area_id) AS area_rows_total,
    COUNT(DISTINCT area_id) AS areas_unique,
    COUNT(geoname_id) AS geoname_rows_total,
    COUNT(DISTINCT geoname_id) AS geonames_unique
FROM source
GROUP BY genre_id, artist_id
