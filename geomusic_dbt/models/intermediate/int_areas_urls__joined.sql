WITH areas AS (
    SELECT * FROM {{ ref('stg_musicbrainz__areas') }}
),
l_area_url AS (
    SELECT * FROM {{ ref('stg_musicbrainz__l_area_url') }}
),
links AS (
    SELECT * FROM {{ ref('stg_musicbrainz__links')}}
),
link_types AS (
    SELECT * FROM {{ ref('stg_musicbrainz__link_types')}}
),
urls AS (
    SELECT * FROM {{ ref('stg_musicbrainz__urls') }}
)
SELECT *
FROM areas a
JOIN l_area_url lau USING (area_id)
JOIN links l USING (link_id)
JOIN link_types lt USING (link_type_id)
JOIN urls u USING (url_id)
