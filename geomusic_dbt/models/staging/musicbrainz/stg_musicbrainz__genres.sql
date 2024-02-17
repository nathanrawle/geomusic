WITH genres AS (
    SELECT
        genre_id,
        genre_name
    FROM {{ ref('base_musicbrainz__genres') }}
),
tags AS (
    SELECT
        tag_id,
        tag_name AS tag_name,
        tag_ref_count
    FROM {{ ref('stg_musicbrainz__tags') }}
)
SELECT
    t.tag_id AS genre_tag_id,
    g.genre_id,
    g.genre_name,
    t.tag_ref_count AS genre_tag_ref_count
FROM
    tags t
    JOIN
    genres g
    ON LOWER(TRIM(t.tag_name)) = LOWER(g.genre_name)
