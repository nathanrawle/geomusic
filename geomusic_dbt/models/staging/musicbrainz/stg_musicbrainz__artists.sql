WITH source AS (
    SELECT * FROM {{ source( 'musicbrainz', 'artists' ) }}
),
renamed AS (
    SELECT
        id AS artist_id,
        name AS artist_name,
        sort_name AS artist_sort_name,
        begin_date_year AS artist_begin_date_year,
        begin_date_month AS artist_begin_date_month,
        begin_date_day AS artist_begin_date_day,
        end_date_year AS artist_end_date_year,
        end_date_month AS artist_end_date_month,
        end_date_day AS artist_end_date_day,
        type AS artist_type,
        gender AS artist_gender,
        comment AS artist_comment,
        ended AS artist_ended,
        COALESCE(begin_area, end_area, area) AS artist_canonical_area_id
    FROM source
)
SELECT * FROM renamed
