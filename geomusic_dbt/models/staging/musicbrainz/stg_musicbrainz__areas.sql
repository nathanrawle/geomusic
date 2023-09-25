WITH source AS (
    SELECT * FROM {{ source( 'musicbrainz', 'areas' ) }}
),
renamed AS (
    SELECT
        id AS area_id,
        name AS area_name,
        type AS area_type,
        comment AS area_comment
    FROM source
)
SELECT * FROM renamed
