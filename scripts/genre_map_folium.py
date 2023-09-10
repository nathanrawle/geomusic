"""Take a table of genre map data and return genre map html"""

import locale

import folium

from folium.plugins import marker_cluster
from pandas import read_csv

locale.setlocale(locale.LC_ALL, "")


def main(fp="./data/curated/genre_map.csv"):
    # Read data into pandas
    data = read_csv(fp)

    # Isolate array of (lat, lon) tuples
    locations = data[["lat", "lon"]].values

    # Isolate array of popup data tuples
    popup_data = data[
        [
            "loc",
            "locator_country",
            "genre",
            "artists",
            "pct_of_genre",
            "one_in_x_loc",
            "people_per_artist",
            "genre_artists_count",
            "loc_artists_count",
        ]
    ].values

    # Generate popups
    popups = [
        folium.Popup(
            f"<p style='white-space:nowrap'>{loc} ({ctr}) is the modern home of: <strong>{ge}</strong><br/>\
            1 in {int(round(oixl,0))} artists from {loc} is a {ge} artist (one for every ~{ppa:n} people)<br/><br/>\
            <em>In this dataset, there are…\
            <ul><li>{ats} {ge} artists from {loc} ({round(pct * 100, 2):.1f}% of all {ge} artists)\
            <li>{lac} artists from {loc} in total\
            <li>{gac} {ge} artists in total</em><ul></p>"
        )
        for loc, ctr, ge, ats, pct, oixl, ppa, gac, lac in popup_data
    ]

    # Gather popups into folium cluster
    cluster = marker_cluster.MarkerCluster(locations, popups)

    # Generate Map object
    m = folium.Map(
        location=[6.5, 3.4],
        zoom_start=2,
        min_zoom=2,
        max_bounds=True,
    )

    # Add cluster to map object
    m.add_child(cluster)

    # return map _html_repr
    return m.get_root().render()


if __name__ == "__main__":
    print(main())
