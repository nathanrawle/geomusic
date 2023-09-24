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
deduplicated AS (
    SELECT source.*
    FROM source
    JOIN duplicate_ids
        USING(area_id)
    WHERE
        population > 0
        AND feature_class = 'P'
)
SELECT *
FROM one_to_one
UNION ALL
SELECT *
FROM deduplicated
