WITH source AS (
    SELECT * FROM {{ source( 'musicbrainz', 'urls' ) }}
),
renamed AS (
    SELECT
        id AS url_id,
        url
    FROM source
)
SELECT * FROM renamed
