WITH source AS (
    SELECT * FROM {{ source('musicbrainz','links') }}
),
renamed AS (
    SELECT
        id AS link_id,
        link_type AS link_type_id
    FROM source
)
SELECT * FROM renamed
