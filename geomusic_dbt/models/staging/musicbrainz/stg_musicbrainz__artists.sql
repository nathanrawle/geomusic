WITH source AS (
    SELECT * FROM {{ source( 'musicbrainz', 'artists' ) }}
),
renamed AS (
    SELECT
        id AS artist_id,
        gid AS artist_gid,
        name AS artist_name,
        sort_name AS artist_sort_name,
        begin_date_year AS artist_begin_date_year,
        begin_date_month AS artist_begin_date_month,
        begin_date_day AS artist_begin_date_day,
        end_date_year AS artist_end_date_year,
        end_date_month AS artist_end_date_month,
        end_date_day AS artist_end_date_day,
        type AS artist_type,
        area AS artist_area_id,
        gender AS artist_gender,
        comment AS artist_comment,
        edits_pending AS artist_edits_pending,
        last_updated AS artist_last_updated,
        ended AS artist_ended,
        begin_area AS artist_begin_area_id,
        end_area AS artist_end_area_id,
        COALESCE(begin_area, end_area, area) AS artist_canonical_area_id
    FROM source
)
SELECT * FROM renamed
