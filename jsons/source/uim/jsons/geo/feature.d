/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.jsons.geo.feature;

import uim.jsons.geo;

mixin(ShowModule!());

@safe:

/**
 * GeoJSON Feature
 * A feature object represents a spatially bounded thing
 */
class GeoJsonFeature : UIMObject {
    protected DGeoJsonGeometry _geometry;
    protected Json _properties;
    protected Json _id;
    
    alias toJson = UIMObject.toJson;
    
    @property DGeoJsonGeometry geometry() { return _geometry; }
    @property void geometry(DGeoJsonGeometry value) { _geometry = value; }
    
    @property Json properties() { return _properties; }
    @property void properties(Json value) { _properties = value; }
    
    @property Json id() { return _id; }
    @property void id(Json value) { _id = value; }
    
    this() {
        super();
        _properties = Json.emptyObject;
        _id = Json.undefined;
    }
    
    this(DGeoJsonGeometry geom) {
        this();
        this._geometry = geom;
    }
    
    this(DGeoJsonGeometry geom, Json props) {
        this(geom);
        this._properties = props;
    }
    
    /**
     * Convert feature to JSON
     */
    Json toJson() @trusted {
        auto result = Json.emptyObject;
        result["type"] = GeoJsonType.Feature.to!string;
        
        if (_geometry !is null) {
            result["geometry"] = _geometry.toJson();
        } else {
            result["geometry"] = Json(null);
        }
        
        result["properties"] = _properties;
        
        if (_id != Json.undefined) {
            result["id"] = _id;
        }
        
        return result;
    }
    
    /**
     * Parse feature from JSON
     */
    void fromJson(Json json) @trusted {
        if ("geometry" in json && json["geometry"].type != Json.Type.null_) {
            _geometry = parseGeometry(json["geometry"]);
        }
        
        if ("properties" in json) {
            _properties = json["properties"];
        } else {
            _properties = Json.emptyObject;
        }
        
        if ("id" in json) {
            _id = json["id"];
        }
    }
    
    /**
     * Get a property value
     */
    Json getProperty(string name) @trusted {
        if (_properties.type == Json.Type.object && name in _properties) {
            return _properties[name];
        }
        return Json.undefined;
    }
    
    /**
     * Set a property value
     */
    void setProperty(string name, Json value) @trusted {
        if (_properties.type != Json.Type.object) {
            _properties = Json.emptyObject;
        }
        _properties[name] = value;
    }
    
    /**
     * Check if property exists
     */
    bool hasProperty(string name) @trusted {
        return _properties.type == Json.Type.object && name in _properties;
    }
}

/**
 * Parse a feature from JSON string
 */
DGeoJsonFeature parseFeature(string jsonString) @trusted {
    auto json = parseJsonString(jsonString);
    return parseFeature(json);
}

/**
 * Parse a feature from JSON object
 */
DGeoJsonFeature parseFeature(Json json) @trusted {
    auto feature = new DGeoJsonFeature();
    feature.fromJson(json);
    return feature;
}
