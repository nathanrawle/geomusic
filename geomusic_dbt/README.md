# geomusic_dbt
The dbt transformation workflow for geomusic

## sources
geomusic uses the following source systems
### postgres:
#### MusicBrainz
Mirror created locally using [acoustid/mbslave][mbslave]

#### Geonames
Mirror created locally using [nathanrawle/geonames-postgres][geonames-postgres]

#### geomusic
Warehouse created using foreign data wrapper posgres_fdw to include MusicBrainz and Geonames as foreign schema.

[mbslave]: https://github.com/acoustid/mbslave
[geonames-postgres]: https://github.com/nathanrawle/geonames-postgres

## models
### staging
For now, most staging models are a SELECT * from one of the underlying source tables. The exceptions are `stg_musicbrainz__areas.sql`, `stg_musicbrainz__l_area_url.sql`, and `stg_musicbrainz__urls.sql`, which have some columns renamed for convenience.
