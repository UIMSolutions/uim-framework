/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module geojson.examples.example;

import uim.geojson;
import vibe.data.json;
import std.stdio;

void main() {
    writeln("=== UIM GeoJson Library Example ===\n");

    // Example 1: Creating a Point
    writeln("1. Point geometry:");
    auto sanFrancisco = new DGeoJsonPoint(-122.4194, 37.7749);
    writeln("  San Francisco coordinates: ", sanFrancisco.toJson().toPrettyString());
    writeln();

    // Example 2: Creating a Point with altitude
    writeln("2. Point with altitude:");
    auto mountEverest = new DGeoJsonPoint(86.9250, 27.9881, 8848.86);
    writeln("  Mount Everest: ", mountEverest.toJson().toPrettyString());
    writeln();

    // Example 3: Creating a LineString
    writeln("3. LineString geometry (route):");
    auto route = new DGeoJsonLineString([
        [-122.4194, 37.7749], // San Francisco
        [-118.2437, 34.0522], // Los Angeles
        [-112.0740, 33.4484]  // Phoenix
    ]);
    writeln("  West Coast route: ", route.toJson().toPrettyString());
    writeln();

    // Example 4: Creating a Polygon
    writeln("4. Polygon geometry (area):");
    auto park = new DGeoJsonPolygon([
        [
            [-122.4, 37.8],
            [-122.3, 37.8],
            [-122.3, 37.7],
            [-122.4, 37.7],
            [-122.4, 37.8]  // Close the ring
        ]
    ]);
    writeln("  Park boundary: ", park.toJson().toPrettyString());
    writeln();

    // Example 5: Creating a Feature with properties
    writeln("5. Feature with properties:");
    auto cityPoint = new DGeoJsonPoint(-122.4194, 37.7749);
    auto cityFeature = new DGeoJsonFeature(cityPoint);
    cityFeature.setProperty("name", Json("San Francisco"));
    cityFeature.setProperty("population", Json(883305));
    cityFeature.setProperty("state", Json("California"));
    cityFeature.setProperty("founded", Json(1776));
    cityFeature.id = Json("SF-001");
    writeln("  City feature: ", cityFeature.toJson().toPrettyString());
    writeln();

    // Example 6: Creating a FeatureCollection
    writeln("6. FeatureCollection with multiple cities:");
    auto cities = new DGeoJsonFeatureCollection();
    
    // Add San Francisco
    cities.addFeature(cityFeature);
    
    // Add Los Angeles
    auto laPoint = new DGeoJsonPoint(-118.2437, 34.0522);
    auto laFeature = new DGeoJsonFeature(laPoint);
    laFeature.setProperty("name", Json("Los Angeles"));
    laFeature.setProperty("population", Json(3971883));
    laFeature.setProperty("state", Json("California"));
    laFeature.id = Json("LA-001");
    cities.addFeature(laFeature);
    
    // Add New York
    auto nyPoint = new DGeoJsonPoint(-74.0060, 40.7128);
    auto nyFeature = new DGeoJsonFeature(nyPoint);
    nyFeature.setProperty("name", Json("New York"));
    nyFeature.setProperty("population", Json(8336817));
    nyFeature.setProperty("state", Json("New York"));
    nyFeature.id = Json("NY-001");
    cities.addFeature(nyFeature);
    
    writeln("  Cities collection (", cities.length, " cities):");
    writeln(cities.toJson().toPrettyString());
    writeln();

    // Example 7: MultiPoint geometry
    writeln("7. MultiPoint geometry (multiple locations):");
    auto landmarks = new DGeoJsonMultiPoint([
        [-122.4194, 37.7749], // Golden Gate Bridge
        [-122.4194, 37.8199], // Alcatraz Island
        [-122.4783, 37.8199]  // Sausalito
    ]);
    writeln("  Bay Area landmarks: ", landmarks.toJson().toPrettyString());
    writeln();

    // Example 8: Parsing GeoJson string
    writeln("8. Parsing GeoJson from string:");
    string geojsonString = `{
        "type": "Feature",
        "geometry": {
            "type": "Point",
            "coordinates": [-0.1278, 51.5074]
        },
        "properties": {
            "name": "London",
            "country": "United Kingdom",
            "population": 9002488
        },
        "id": "LON-001"
    }`;
    
    auto london = parseFeature(geojsonString);
    writeln("  Parsed city: ", london.getProperty("name").get!string);
    writeln("  Population: ", london.getProperty("population").get!long);
    writeln("  Full feature: ", london.toJson().toPrettyString());
    writeln();

    // Example 9: Filtering features by property
    writeln("9. Filtering features by state:");
    auto californianCities = cities.filterByProperty("state", Json("California"));
    writeln("  Found ", californianCities.length, " cities in California:");
    foreach (city; californianCities) {
        writeln("    - ", city.getProperty("name").get!string);
    }
    writeln();

    // Example 10: MultiPolygon (archipelago)
    writeln("10. MultiPolygon geometry (islands):");
    auto islands = new DGeoJsonMultiPolygon([
        [ // First island
            [
                [-122.5, 37.8],
                [-122.4, 37.8],
                [-122.4, 37.7],
                [-122.5, 37.7],
                [-122.5, 37.8]
            ]
        ],
        [ // Second island
            [
                [-122.3, 37.9],
                [-122.2, 37.9],
                [-122.2, 37.8],
                [-122.3, 37.8],
                [-122.3, 37.9]
            ]
        ]
    ]);
    writeln("  Island group: ", islands.toJson().toPrettyString());
    writeln();

    // Example 11: GeometryCollection
    writeln("11. GeometryCollection (mixed geometries):");
    auto point1 = new DGeoJsonPoint(-122.4, 37.8);
    auto line1 = new DGeoJsonLineString([[-122.5, 37.8], [-122.4, 37.7]]);
    auto poly1 = new DGeoJsonPolygon([[
        [-122.3, 37.9],
        [-122.2, 37.9],
        [-122.2, 37.8],
        [-122.3, 37.8],
        [-122.3, 37.9]
    ]]);
    
    auto collection = new DGeoJsonGeometryCollection([point1, line1, poly1]);
    writeln("  Mixed geometries: ", collection.toJson().toPrettyString());
    writeln();

    // Example 12: Complete workflow - Building a map
    writeln("12. Complete workflow - Building a restaurant map:");
    auto restaurants = new DGeoJsonFeatureCollection();
    
    struct Restaurant {
        string name;
        double lon, lat;
        string cuisine;
        int rating;
    }
    
    Restaurant[] restaurantData = [
        Restaurant("Golden Dragon", -122.4083, 37.7955, "Chinese", 4),
        Restaurant("Bella Italia", -122.4194, 37.7749, "Italian", 5),
        Restaurant("Sushi Paradise", -122.4089, 37.7858, "Japanese", 4),
        Restaurant("Taco Fiesta", -122.4094, 37.7899, "Mexican", 3)
    ];
    
    foreach (i, restaurant; restaurantData) {
        auto point = new DGeoJsonPoint(restaurant.lon, restaurant.lat);
        auto feature = new DGeoJsonFeature(point);
        feature.setProperty("name", Json(restaurant.name));
        feature.setProperty("cuisine", Json(restaurant.cuisine));
        feature.setProperty("rating", Json(restaurant.rating));
        feature.id = Json("REST-" ~ (i + 1).to!string);
        restaurants.addFeature(feature);
    }
    
    writeln("  Restaurant map with ", restaurants.length, " locations:");
    writeln(restaurants.toJson().toPrettyString());
    writeln();

    writeln("=== Example Complete ===");
}
