WITH artists_geonamed AS (
    SELECT *
    FROM {{ ref('int_artists_areas_geonamed__joined') }}
    WHERE
        feature_class = 'P'
    OR
        feature_code LIKE 'PCL%'
),
artist_tags_genres AS (
    SELECT *
    FROM {{ ref('int_artist_tags_genres__joined') }}
)
SELECT *
FROM artists_geonamed ag
JOIN artist_tags_genres atg
    USING (artist_id)
