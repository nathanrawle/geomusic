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
one_to_one AS (
    SELECT source.*
    FROM source
    JOIN area_geonames_counted
        USING (area_id)
    WHERE area_row_count = 1
),
duplicates AS (
    SELECT source.*
    FROM source
    JOIN area_geonames_counted
        USING (area_id)
    WHERE area_row_count > 1
),
deduplicated AS (
    SELECT *
    FROM duplicates
    WHERE
        population > 0
        AND feature_class = 'P'
)
SELECT *
FROM one_to_one
UNION ALL
SELECT *
FROM deduplicated
