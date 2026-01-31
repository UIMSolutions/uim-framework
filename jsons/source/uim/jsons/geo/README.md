# UIM GeoJson Module

A D language library for working with GeoJson data format. This module provides full support for the [GeoJson specification (RFC 7946)](https://tools.ietf.org/html/rfc7946).

## Features

- **Complete GeoJson Support**: All geometry types (Point, LineString, Polygon, MultiPoint, MultiLineString, MultiPolygon, GeometryCollection)
- **Feature & FeatureCollection**: Full support for GeoJson features with properties
- **Type-Safe**: Strongly typed geometry classes with compile-time safety
- **Json Serialization**: Built-in Json serialization/deserialization using vibe.d
- **Object-Oriented**: Clean class hierarchy based on UIM framework

## Geometry Types

### Point
Represents a single position (longitude, latitude, optional altitude):
```d
auto point = new GeoJsonPoint(-122.4194, 37.7749); // San Francisco
```

### LineString
Represents a series of connected positions:
```d
auto line = new GeoJsonLineString([
    [-122.4194, 37.7749],
    [-122.4084, 37.7849]
]);
```

### Polygon
Represents an area with optional holes:
```d
auto polygon = new GeoJsonPolygon([
    [ // Outer ring
        [-122.5, 37.8],
        [-122.4, 37.8],
        [-122.4, 37.7],
        [-122.5, 37.7],
        [-122.5, 37.8]
    ]
]);
```

### Multi-Geometries
- **MultiPoint**: Multiple points
- **MultiLineString**: Multiple line strings
- **MultiPolygon**: Multiple polygons

### GeometryCollection
A collection of heterogeneous geometries.

## Features

A GeoJson Feature represents a spatially bounded entity:
```d
auto point = new GeoJsonPoint(-122.4194, 37.7749);
auto feature = new GeoJsonFeature(point);

// Add properties
feature.setProperty("name", Json("Golden Gate Bridge"));
feature.setProperty("year", Json(1937));
```

## FeatureCollection

A collection of features:
```d
auto collection = new GeoJsonFeatureCollection();
collection.addFeature(feature1);
collection.addFeature(feature2);

// Convert to Json
auto json = collection.toJson();
```

## Usage

### Creating and Serializing

```d
import uim.jsons.geo;

// Create a point
auto point = new GeoJsonPoint(-122.4194, 37.7749);

// Create a feature with properties
auto feature = new GeoJsonFeature(point);
feature.setProperty("name", Json("San Francisco"));
feature.setProperty("population", Json(883305));

// Serialize to Json
auto json = feature.toJson();
writeln(json.toPrettyString());
```

### Parsing GeoJson

```d
import uim.jsons.geo;

string geojsonString = `{
    "type": "Feature",
    "geometry": {
        "type": "Point",
        "coordinates": [-122.4194, 37.7749]
    },
    "properties": {
        "name": "San Francisco"
    }
}`;

auto feature = parseFeature(geojsonString);
auto name = feature.getProperty("name").get!string;
```

### Working with Collections

```d
import uim.jsons.geo;

auto collection = new GeoJsonFeatureCollection();

// Add multiple features
foreach (i; 0..10) {
    auto point = new GeoJsonPoint(i * 1.0, i * 2.0);
    auto feature = new GeoJsonFeature(point);
    feature.setProperty("id", Json(i));
    collection.addFeature(feature);
}

// Filter by property
auto filtered = collection.filterByProperty("id", Json(5));

// Serialize entire collection
auto json = collection.toJson();
```

## Building

```bash
cd geojson
dub build
```

## Testing

```bash
dub test
```

## Dependencies

- **uim-framework:oop** - Base OOP functionality
- **vibe-d** - Json serialization

## Standards Compliance

This library implements the [GeoJson Format (RFC 7946)](https://tools.ietf.org/html/rfc7946) specification:
- Right-hand rule for polygon orientation
- Longitude/latitude coordinate order (WGS84)
- Optional altitude support
- Feature properties

## License

Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.

## Author

Ozan Nurettin Süel (aka UIManufaktur)
