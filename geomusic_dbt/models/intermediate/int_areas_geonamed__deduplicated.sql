WITH source AS (
    SELECT * FROM {{ ref('int_areas__geonamed') }}
),
area_geonames_counted AS (
    SELECT
        area_id,
        count(*) AS area_row_count
    FROM
        source
    GROUP BY area_id
),
one_to_one_ids AS (
    SELECT area_id
    FROM area_geonames_counted
    WHERE area_row_count = 1
),
one_to_one AS (
    SELECT source.*
    FROM source
    JOIN one_to_one_ids
        USING(area_id)
),
duplicate_ids AS (
    SELECT area_id
    FROM area_geonames_counted
    WHERE area_row_count > 1
),
duplicates_ranked AS (
    SELECT
        area_id,
        geoname_id,
        ROW_NUMBER() OVER (
            PARTITION BY area_id
            ORDER BY
                population DESC,
                feature_class DESC,
                feature_code
        ) AS geoname_id_rank
    FROM source
    JOIN duplicate_ids
        USING(area_id)
),
deduplicated_ids AS (
    SELECT area_id, geoname_id
    FROM duplicates_ranked
    WHERE geoname_id_rank = 1
),
deduplicated AS (
    SELECT source.*
    FROM source
    JOIN deduplicated_ids
        USING(area_id, geoname_id)
)
SELECT *
FROM one_to_one
UNION ALL
SELECT *
FROM deduplicated
