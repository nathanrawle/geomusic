SELECT * FROM {{ source( 'geonames', 'timezones' ) }}
