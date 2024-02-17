SELECT * FROM {{ source( 'geonames', 'feature_codes' ) }}
