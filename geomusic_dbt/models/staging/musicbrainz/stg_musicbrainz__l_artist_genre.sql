WITH source AS (
    SELECT * FROM {{ source( 'musicbrainz', 'l_artist_genre' ) }}
),
renamed AS (
    SELECT
        id AS l_artist_genre_id,
        link AS link_id,
        entity0 AS artist_id,
        entity1 AS genre_id,
        edits_pending AS l_artist_genre_edits_pending,
        last_updated AS l_artist_genre_last_updated,
        link_order AS l_artist_genre_link_order,
        entity0_credit AS l_artist_genre_entity0_credit,
        entity1_credit AS l_artist_genre_entity1_credit
    FROM source
)
SELECT * FROM renamed
