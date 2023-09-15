WITH source AS (
    SELECT * FROM {{ source( 'musicbrainz', 'areas' ) }}
),
renamed AS (
    SELECT
        id AS area_id,
        gid AS area_gid,
        name AS area_name,
        type AS area_type,
        edits_pending AS area_edits_pending,
        last_updated AS area_last_updated,
        begin_date_year AS area_begin_date_year,
        begin_date_month AS area_begin_date_month,
        begin_date_day AS area_begin_date_day,
        end_date_year AS area_end_date_year,
        end_date_month AS area_end_date_month,
        end_date_day AS area_end_date_day,
        ended AS area_ended,
        comment AS area_comment
    FROM source
)
SELECT * FROM renamed
