SELECT * FROM {{ source( 'musicbrainz', 'l_artist_genre' ) }}
