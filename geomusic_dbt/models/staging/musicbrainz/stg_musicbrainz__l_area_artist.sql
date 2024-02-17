WITH source AS (
    SELECT * FROM {{ source( 'musicbrainz', 'l_area_artist' ) }}
),
renamed AS (
    SELECT
        id AS l_area_artist_id,
        link AS link_id,
        entity0 AS area_id,
        entity1 AS artist_id
    FROM source
)
SELECT * FROM renamed
