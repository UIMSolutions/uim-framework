/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.jsons.geo.helpers.featurecollection;

import uim.jsons.geo;

mixin(ShowModule!());

@safe:

/**
 * GeoJson FeatureCollection
 * A collection of feature objects
 */
class GeoJsonFeatureCollection : UIMObject {
    protected DGeoJsonFeature[] _features;
    
    alias toJson = UIMObject.toJson;
    
    @property DGeoJsonFeature[] features() { return _features; }
    @property void features(DGeoJsonFeature[] value) { _features = value; }
    
    this() {
        super();
        _features = [];
    }
    
    this(DGeoJsonFeature[] feats) {
        this();
        this._features = feats;
    }
    
    /**
     * Add a feature to the collection
     */
    void addFeature(DGeoJsonFeature feature) {
        _features ~= feature;
    }
    
    /**
     * Convert to Json
     */
    Json toJson() @trusted {
        auto result = Json.emptyObject;
        result["type"] = GeoJsonType.FeatureCollection.to!string;
        
        auto featArray = Json.emptyArray;
        foreach (feature; _features) {
            featArray ~= feature.toJson();
        }
        result["features"] = featArray;
        
        return result;
    }
    
    /**
     * Parse from Json
     */
    void fromJson(Json json) @trusted {
        if ("features" in json) {
            _features = [];
            foreach (featJson; json["features"]) {
                auto feature = new DGeoJsonFeature();
                feature.fromJson(featJson);
                _features ~= feature;
            }
        }
    }
    
    /**
     * Get number of features
     */
    size_t length() const {
        return _features.length;
    }
    
    /**
     * Filter features by property
     */
    DGeoJsonFeature[] filterByProperty(string propName, Json value) @trusted {
        DGeoJsonFeature[] result;
        foreach (feature; _features) {
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
 * Parse a feature collection from Json string
 */
DGeoJsonFeatureCollection parseFeatureCollection(string jsonString) @trusted {
    auto json = parseJsonString(jsonString);
    return parseFeatureCollection(json);
}

/**
 * Parse a feature collection from Json object
 */
DGeoJsonFeatureCollection parseFeatureCollection(Json json) @trusted {
    auto collection = new DGeoJsonFeatureCollection();
    collection.fromJson(json);
    return collection;
}
