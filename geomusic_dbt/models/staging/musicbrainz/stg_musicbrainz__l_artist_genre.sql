WITH source AS (
    SELECT * FROM {{ source( 'musicbrainz', 'l_artist_genre' ) }}
),
renamed AS (
    SELECT
        id AS l_artist_genre_id,
        link AS link_id,
        entity0 AS artist_id,
        entity1 AS genre_id,
        edits_pending,
        last_updated,
        link_order,
        entity0_credit,
        entity1_credit
    FROM source
)
SELECT * FROM renamed
