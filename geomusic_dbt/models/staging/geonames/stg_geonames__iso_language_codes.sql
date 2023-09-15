SELECT * FROM {{ source( 'geonames', 'iso_language_codes' ) }}
