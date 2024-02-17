SELECT * FROM {{ source( 'geonames', 'user_tags' ) }}
