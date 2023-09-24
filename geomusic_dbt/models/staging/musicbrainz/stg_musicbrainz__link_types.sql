WITH source AS (
    SELECT * FROM {{ source( 'musicbrainz', 'link_types' ) }}
),
renamed AS (
    SELECT
        id AS link_type_id,
        parent AS link_type_parent_id,
        child_order AS link_type_child_order,
        gid AS link_type_gid,
        entity_type0 AS link_entity_type0,
        entity_type1 AS link_entity_type1,
        name AS link_type_name,
        description AS link_type_description,
        link_phrase,
        reverse_link_phrase,
        long_link_phrase,
        priority AS link_type_priority,
        last_updated AS link_type_last_updated,
        is_deprecated AS link_type_is_deprecated,
        has_dates AS link_type_has_dates,
        entity0_cardinality AS link_type_entity0_cardinality,
        entity1_cardinality AS link_type_entity1_cardinality
    FROM source
)
SELECT * FROM renamed
