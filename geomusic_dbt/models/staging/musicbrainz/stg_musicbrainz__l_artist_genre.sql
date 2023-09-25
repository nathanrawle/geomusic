WITH source AS (
    SELECT * FROM {{ source( 'musicbrainz', 'l_artist_genre' ) }}
),
renamed AS (
    SELECT
        id AS l_artist_genre_id,
        link AS link_id,
        entity0 AS artist_id,
        entity1 AS genre_id
    FROM source
)
SELECT * FROM renamed
