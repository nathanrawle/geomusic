SELECT * FROM {{ source( 'geonames', 'admin2_codes' ) }}
