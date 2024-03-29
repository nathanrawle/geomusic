WITH source AS (
    SELECT * FROM {{ source( 'musicbrainz', 'artist_tags' ) }}
),
renamed AS (
    SELECT
        artist AS artist_id,
        tag AS tag_id,
        count AS artist_tag_count
    FROM source
)
SELECT * FROM renamed
