SELECT * FROM {{ source( 'geonames', 'country_info' ) }}
