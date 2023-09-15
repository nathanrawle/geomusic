SELECT * FROM {{ source( 'geonames', 'hierarchy' ) }}
