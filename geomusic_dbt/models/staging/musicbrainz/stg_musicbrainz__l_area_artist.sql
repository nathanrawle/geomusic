WITH source AS (
    SELECT * FROM {{ source( 'musicbrainz', 'l_area_artist' ) }}
),
renamed AS (
    SELECT
        id AS l_area_artist_id,
        link AS link_id,
        entity0 AS area_id,
        entity1 AS artist_id,
        edits_pending AS l_area_artist_edits_pending,
        last_updated AS l_area_artist_last_updated,
        link_order AS l_area_artist_link_order,
        entity0_credit AS l_area_artist_entity0_credit,
        entity1_credit AS l_area_artist_entity1_credit
    FROM source
)
SELECT * FROM renamed
