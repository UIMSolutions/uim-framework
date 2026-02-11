/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
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
    protected GeoJsonFeature[] _features;
    
    alias toJson = UIMObject.toJson;
    
    @property GeoJsonFeature[] features() { return _features; }
    @property void features(GeoJsonFeature[] value) { _features = value; }
    
    this() {
        super();
        _features = [];
    }
    
    this(GeoJsonFeature[] feats) {
        this();
        this._features = feats;
    }
    
    /**
     * Add a feature to the collection
     */
    void addFeature(GeoJsonFeature feature) {
        _features ~= feature;
    }
    
    /**
     * Convert to Json
     */
    override Json toJson() @trusted {
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
                auto feature = new GeoJsonFeature();
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
    GeoJsonFeature[] filterByProperty(string propName, Json value) @trusted {
        GeoJsonFeature[] result;
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
GeoJsonFeatureCollection parseFeatureCollection(string jsonString) @trusted {
    auto json = parseJsonString(jsonString);
    return parseFeatureCollection(json);
}

/**
 * Parse a feature collection from Json object
 */
GeoJsonFeatureCollection parseFeatureCollection(Json json) @trusted {
    auto collection = new GeoJsonFeatureCollection();
    collection.fromJson(json);
    return collection;
}
