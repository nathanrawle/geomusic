WITH source AS (
    SELECT * FROM {{ source( 'musicbrainz', 'link_types' ) }}
),
renamed AS (
    SELECT
        id AS link_type_id,
        parent AS link_type_parent_id,
        name AS link_type_name,
        description AS link_type_description
    FROM source
)
SELECT * FROM renamed
