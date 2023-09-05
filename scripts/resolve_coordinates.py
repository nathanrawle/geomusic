"""Match up Geonames ids with musicbrainz area ids"""

import numpy as np
import pandas as pd
import psycopg2  # noqa
import sqlalchemy


def resolve_hierarchy(list2d: pd.DataFrame, filter=None, suffix=0):
    """Take a two-dimensional list of parent-child relationships and expand it out into the full hierarchy"""

    parent, child = list2d.columns.values
    df = list2d.loc[list2d[parent].eq(filter)] if filter else list2d
    while df.iloc[:, -1].notna().any():
        on = child + str(suffix - 1) if suffix else child
        df = df.join(list2d.set_index(parent), on=on, rsuffix=str(suffix))
        suffix += 1
    return df.drop(df.columns[-1], axis=1)


def build_relator(
    df: pd.DataFrame, selector: list | pd.Series, key_col, keep_duplicates=False
) -> pd.Series:
    return (
        df.loc[selector, key_col]
        .str.strip()
        .str.lower()
        .reset_index()
        .drop_duplicates(keep=keep_duplicates)
        .set_index(key_col)
    )


def build_junction(
    df: pd.DataFrame,
    na_col: str,
    on_col: str,
    rel: pd.Series,
    selector: list | pd.Series | None = None,
):
    return (
        df.join(rel, on=on_col, how="inner", lsuffix="_")[na_col]
        if selector is None
        else df.loc[selector].join(rel, on=on_col, how="inner", lsuffix="_")[na_col]
    )


def fill_na_from_junction(junc: pd.Series, na_col: pd.Series):
    return na_col.fillna(junc)


def get_feature_code_mask(
    mb_parent_type: int, mb_child_type: int, gn_scope: pd.DataFrame
) -> pd.Series | None:
    """Return appropriate geonames.feature_code filter for given musicbrainz area types"""

    match mb_parent_type, mb_child_type:
        case 1, 1:
            return [gn_scope.feature_code.str.fullmatch(r"PCL[^I]?|PCLIX")]
        case _, 1:
            return [gn_scope.feature_code.str.fullmatch(r"PCL.*")]
        case _, 2:
            return [gn_scope.feature_code.str.fullmatch(r"ADM[12]H?")]
        case 1, 3:
            return [
                gn_scope.feature_code.str.fullmatch(r"PPL[ACG]H?"),
                gn_scope.feature_code.str.fullmatch(r"PPL"),
            ]
        case 2, 3:
            return [gn_scope.feature_code.str.fullmatch(r"PPLA2|PPL")]
        case 7, 3:
            return [gn_scope.feature_code.str.fullmatch(r"PPLA[23]|PPL")]
        case 4, 3:
            return [gn_scope.feature_code.str.fullmatch(r"PPLA[2345]|PPL")]
        case _, 3:
            return [gn_scope.feature_code.str.fullmatch(r"PPL.*")]
        case pt, 4 if pt in [2, 3]:
            return [gn_scope.feature_code.str.fullmatch(r"ADM[2345]H?")]
        case _, 4:
            return [gn_scope.feature_code.str.fullmatch(r"ADM[2345D]H?")]
        case pt, ct if (pt == 5 and ct != 6) or ct == 5 or (
            pt == 3 and ct in [2, 3, 4]
        ):
            return [gn_scope.feature_code.str.fullmatch(r"PPLX")]
        case _, 6:
            return [gn_scope.feature_code.str.fullmatch(r"ISL\w?")]
        case 2, 7:
            return [gn_scope.feature_code.str.fullmatch(r"ADM2H?")]
        case _, 7:
            return [gn_scope.feature_code.str.fullmatch(r"ADM[23D]")]
        case _, 8:
            return [gn_scope.feature_code.str.fullmatch(r"MILB|NVB|AIRB")]
        case _:
            return None


# retrieve musicbrainz areas and area hierarchical relationships
mb_engine = sqlalchemy.create_engine(
    "postgresql+psycopg2://musicbrainz@localhost:5432/musicbrainz"
)
with mb_engine.connect() as con:
    mb_areas = pd.read_sql("area", con, "id")
    l_area_area = pd.read_sql("l_area_area", con, "id")

# retrieve geonames table and geonames hierarchical relationships
gn_engine = sqlalchemy.create_engine(
    "postgresql+psycopg2://readonly@localhost:5432/geonames"
)
gn_pcls_query = sqlalchemy.text(
    r"select geoname_id, geoname, country_code from geonames where feature_code like 'PCL%'"
)
gn_h_query = sqlalchemy.text(
    r"with populated_places as (select geoname_id from geonames where feature_code like "
    r"'PCL%' or feature_code like 'PPL%') select parent_gnid, child_gnid from hierarchy h "
    r"join populated_places pp on h.parent_gnid = pp.geoname_id join populated_places pp2 "
    r"on h.child_gnid = pp2.geoname_id"
)
gn_altname_query = sqlalchemy.text(
    "select alt_name, geoname_id, iso_language from alt_names where geoname_id in (select geoname_id from geonames where feature_code like 'PCL%')"
)
with gn_engine.connect() as con:
    gn_pcls = pd.read_sql(
        gn_pcls_query, con, "geoname_id"
    )  # "political entities", i.e. countries, former countries, dependents, etc.
    gn_pcl_altnames = pd.read_sql(
        gn_altname_query, con, "geoname_id"
    )  # alternate names of political entities
    gn_hierarchy = pd.read_sql(
        gn_h_query, con
    )  # parent:child relationships between geoname_ids

# prepare musicbrainz areas dataframe for processing
mb_areas["name_lower"] = (
    mb_areas["name"].str.lower().str.strip()
)  # create lower-cased column to use as a join key later
mb_areas["geoname_id"] = pd.NA  # initialise a column to store matched geoname_ids
mba_is_country = mb_areas.type.eq(
    1
)  # create a mask to select countries from musicbrainz.areas
country_mbids = mb_areas[mba_is_country].index
mbh_is_country = l_area_area[l_area_area.entity0.isin(country_mbids)]

# mapping between lower-case geoname and geoname_id of countries (political entities)
gn_pcls_rel = (
    gn_pcls["geoname"].str.strip().str.lower().reset_index().set_index("geoname")
)

# resolve the geoname_id for the musicbrainz area country name
mb_areas = fill_na_from_junction(
    mb_areas, "geoname_id", "name_lower", gn_pcls_rel, mba_is_country
)

# store index-values of geonames countries that were not sucessfully matched
gn_unmatched_indices = gn_pcls.index.difference(mb_areas["geoname_id"])
unmatched_index = gn_pcl_altnames.index.isin(gn_unmatched_indices)

# mapping between lower-case alternative names (english) and geoname_id of countries
en_altnames = gn_pcl_altnames.iso_language.eq("en")
gn_altnames_rel = (
    gn_pcl_altnames.loc[unmatched_index & en_altnames, "alt_name"]
    .str.lower()
    .reset_index()
    .set_index("alt_name")
)
# drop duplicated keys from the index (keeping first occurrence)
gn_altnames_rel = gn_altnames_rel[~gn_altnames_rel.index.duplicated()]

# resolve geoname_id for musicbrainz area country names matching geonames alternate names
mb_areas = fill_na_from_junction(
    mb_areas, "geoname_id", "name_lower", gn_altnames_rel, mba_is_country
)

con = mb_engine.connect()
country_mb_to_gn = mb_areas.loc[
    mb_areas.geoname_id.notna() & mba_is_country, "geoname_id"
]
for country_mbid, country_gnid in country_mb_to_gn.items():
    # find all mb_area descendants of the country mbid

    mb_h = resolve_hierarchy(l_area_area[["entity0", "entity1"]], country_mbid)
    gn_h = resolve_hierarchy(gn_hierarchy, country_gnid)
    if not (mb_h.shape[0] and gn_h.shape[0]):
        continue

    q = (
        "SELECT geoname_id, geoname, feature_code FROM geonames WHERE country_code = "
        "%(country_code)s AND (feature_code LIKE 'PPL%%' OR feature_code LIKE 'PCL%%')"
    )
    country_code = gn_pcls.at[country_gnid, "country_code"]

    with gn_engine.connect() as gn_con:
        gn_country_settlements = pd.read_sql(
            q, gn_con, "geoname_id", params={"country_code": country_code}
        )

    for i in range(mb_h.shape[1] - 1):
        parent_col, child_col = mb_h.columns[i : i + 2]
        if mb_h[parent_col].isna().all() or mb_h[child_col].isna().all():
            continue
        for parent_mbid in mb_h[parent_col].dropna().unique():
            parent_gnid = mb_areas.at[parent_mbid, "geoname_id"]
            if pd.isna(parent_gnid):
                continue

            if parent_mbid == country_mbid:
                mb_scope = mb_h
            else:
                mb_scope = resolve_hierarchy(
                    l_area_area[["entity0", "entity1"]], parent_mbid
                )
            mb_scope = mb_scope.iloc[:, 1:].to_numpy().flatten()
            mb_scope = pd.Index(np.unique(mb_scope)).dropna()

            if parent_gnid == country_gnid:
                gn_scope = gn_h
            else:
                gn_scope = resolve_hierarchy(gn_hierarchy, parent_gnid)
            gn_scope = gn_scope.iloc[:, 1:].to_numpy().flatten()
            gn_scope = pd.Index(np.unique(gn_scope)).dropna()
            try:
                gn_scope = gn_country_settlements.loc[gn_scope]
            except KeyError as e:
                print(e)
                continue

            mba_in_scope = mb_areas.index.isin(mb_scope)
            mba_types_in_scope = mb_areas.loc[mba_in_scope, "type"].drop_duplicates()
            mb_pt = mb_areas.loc[parent_mbid, "type"]
            for mba_type in mba_types_in_scope:
                mb_subs = mba_in_scope & mb_areas.type.eq(mba_type)
                if mb_subs.any():
                    for mask in get_feature_code_mask(mb_pt, mba_type, gn_scope):
                        if mask is None:
                            continue
                        rel = build_relator(
                            scope=gn_scope, mask=mask, key_col="geoname"
                        )

                        mb_areas = fill_na_from_junction(
                            mb_areas, "geoname_id", "name_lower", rel, mb_subs
                        )

con.close()
