WITH source AS (
    SELECT * FROM {{ source('musicbrainz','links') }}
),
renamed AS (
    SELECT
        id AS link_id,
        link_type AS link_type_id,
        begin_date_year AS link_begin_date_year,
        begin_date_month AS link_begin_date_month,
        begin_date_day AS link_begin_date_day,
        end_date_year AS link_end_date_year,
        end_date_month AS link_end_date_month,
        end_date_day AS link_end_date_day,
        attribute_count,
        created AS link_created,
        ended AS link_ended
    FROM source
)
SELECT * FROM renamed
