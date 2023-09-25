SELECT
    genre_name,
    artist_name,
    area_name,
    geoname,
    a.feature_code,
    feature_name,
    population,
    artist_rows_total
FROM
    {{ref('geo_artists_genres')}} a
JOIN
    {{ ref('stats_genres_artists_areas__aggregated_to_genres_artists') }} b
    ON a.genre_id = b.genre_id AND a.artist_id = b.artist_id
JOIN
    {{ ref('stg_geonames__feature_codes') }} c
    ON a.feature_code = c.feature_code
WHERE artist_rows_total > 1
ORDER BY artist_rows_total DESC, a.genre_id, a.artist_id
