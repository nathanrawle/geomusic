# geomusic
Musical SatNav

## branch: experiment/custom-matching-by-name
This branch contains an earlier attempt at reconciling musicbrainz artist locations with geonames, before I realised that the musicbrainz database includes a geonames url for every `area`. The script `scripts/resolve_coordinates.py` attempts to match artist area names to geonames or geoname altnames, in order to attach a gps coordinate.
