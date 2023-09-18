WITH source AS (
    SELECT * FROM {{ source( 'musicbrainz', 'tags' ) }}
),
renamed AS (
    SELECT
        id AS tag_id,
        TRIM(name) AS tag_name,
        ref_count AS tag_ref_count
    FROM source
)
SELECT * FROM renamed
