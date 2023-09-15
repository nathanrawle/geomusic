WITH source AS (
    SELECT * FROM {{ source( 'musicbrainz', 'urls' ) }}
),
renamed AS (
    SELECT
        id AS url_id,
        gid AS url_gid,
        url,
        edits_pending AS url_edits_pending,
        last_updated AS url_last_updated
    FROM source
)
SELECT * FROM renamed
