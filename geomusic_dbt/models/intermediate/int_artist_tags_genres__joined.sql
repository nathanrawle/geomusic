WITH artist_tags AS (
    SELECT * FROM {{ ref('stg_musicbrainz__artist_tags') }}
),
genres AS (
    SELECT * FROM {{ ref('stg_musicbrainz__genres') }}
)
SELECT
    *,
    RANK() OVER (
        PARTITION BY at_.artist_id
        ORDER BY at_.artist_tag_count DESC
    ) AS artist_genre_tag_rank
FROM artist_tags at_
JOIN genres g ON at_.tag_id = g.genre_tag_id
