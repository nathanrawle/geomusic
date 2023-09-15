SELECT * FROM {{ source( 'geonames', 'alt_names' ) }}
