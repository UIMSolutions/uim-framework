/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.geojson.featurecollection;

import uim.geojson;
import vibe.data.json;

@safe:

/**
 * GeoJSON FeatureCollection
 * A collection of feature objects
 */
class DGeoJsonFeatureCollection : DUIMObject {
    mixin(OProperty!("DGeoJsonFeature[]", "features"));
    
    this() {
        super();
        features = [];
    }
    
    this(DGeoJsonFeature[] feats) {
        this();
        this.features = feats;
    }
    
    /**
     * Add a feature to the collection
     */
    void addFeature(DGeoJsonFeature feature) {
        features ~= feature;
    }
    
    /**
     * Convert to JSON
     */
    Json toJson() @trusted {
        auto result = Json.emptyObject;
        result["type"] = GeoJsonType.FeatureCollection.to!string;
        
        auto featArray = Json.emptyArray;
        foreach (feature; features) {
            featArray ~= feature.toJson();
        }
        result["features"] = featArray;
        
        return result;
    }
    
    /**
     * Parse from JSON
     */
    void fromJson(Json json) @trusted {
        if ("features" in json) {
            features = [];
            foreach (featJson; json["features"]) {
                auto feature = new DGeoJsonFeature();
                feature.fromJson(featJson);
                features ~= feature;
            }
        }
    }
    
    /**
     * Get number of features
     */
    size_t length() const {
        return features.length;
    }
    
    /**
     * Filter features by property
     */
    DGeoJsonFeature[] filterByProperty(string propName, Json value) @trusted {
        DGeoJsonFeature[] result;
        foreach (feature; features) {
            if (feature.hasProperty(propName)) {
                auto propValue = feature.getProperty(propName);
                if (propValue == value) {
                    result ~= feature;
                }
            }
        }
        return result;
    }
}

/**
 * Parse a feature collection from JSON string
 */
DGeoJsonFeatureCollection parseFeatureCollection(string jsonString) @trusted {
    auto json = parseJsonString(jsonString);
    return parseFeatureCollection(json);
}

/**
 * Parse a feature collection from JSON object
 */
DGeoJsonFeatureCollection parseFeatureCollection(Json json) @trusted {
    auto collection = new DGeoJsonFeatureCollection();
    collection.fromJson(json);
    return collection;
}
