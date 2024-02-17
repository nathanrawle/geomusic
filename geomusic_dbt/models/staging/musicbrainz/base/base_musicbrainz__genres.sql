WITH source AS (
    SELECT * FROM {{ source( 'musicbrainz', 'genres' ) }}
),
renamed AS (
    SELECT
        id AS genre_id,
        gid AS genre_gid,
        name AS genre_name,
        edits_pending AS genre_edits_pending,
        last_updated AS genre_last_updated,
        comment AS genre_comment
    FROM source
)
SELECT * FROM renamed
