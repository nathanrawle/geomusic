WITH source AS (
    SELECT * FROM {{ source( 'musicbrainz', 'l_area_url' ) }}
),
renamed AS (
    SELECT
        id AS l_area_url_id,
        link AS link_id,
        entity0 AS area_id,
        entity1 AS url_id
    FROM source
)
SELECT * FROM renamed
