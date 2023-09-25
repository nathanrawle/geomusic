WITH geo_artists AS (
    SELECT * FROM {{ ref('geo_artists') }}
),
artist_tags_genres AS (
    SELECT * FROM {{ ref('int_artist_tags_genres__joined') }}
)
SELECT *
FROM geo_artists ag
JOIN artist_tags_genres atg
    USING (artist_id)
