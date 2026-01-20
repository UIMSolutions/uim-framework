/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.geojson.feature;

import uim.geojson;
import vibe.data.json;

@safe:

/**
 * GeoJSON Feature
 * A feature object represents a spatially bounded thing
 */
class DGeoJsonFeature : DUIMObject {
    mixin(OProperty!("DGeoJsonGeometry", "geometry"));
    mixin(OProperty!("Json", "properties"));
    mixin(OProperty!("Json", "id"));
    
    this() {
        super();
        properties = Json.emptyObject;
    }
    
    this(DGeoJsonGeometry geom) {
        this();
        this.geometry = geom;
    }
    
    this(DGeoJsonGeometry geom, Json props) {
        this(geom);
        this.properties = props;
    }
    
    /**
     * Convert feature to JSON
     */
    Json toJson() @trusted {
        auto result = Json.emptyObject;
        result["type"] = GeoJsonType.Feature.to!string;
        
        if (geometry !is null) {
            result["geometry"] = geometry.toJson();
        } else {
            result["geometry"] = Json(null);
        }
        
        result["properties"] = properties;
        
        if (id != Json.undefined) {
            result["id"] = id;
        }
        
        return result;
    }
    
    /**
     * Parse feature from JSON
     */
    void fromJson(Json json) @trusted {
        if ("geometry" in json && json["geometry"].type != Json.Type.null_) {
            geometry = parseGeometry(json["geometry"]);
        }
        
        if ("properties" in json) {
            properties = json["properties"];
        } else {
            properties = Json.emptyObject;
        }
        
        if ("id" in json) {
            id = json["id"];
        }
    }
    
    /**
     * Get a property value
     */
    Json getProperty(string name) @trusted {
        if (properties.type == Json.Type.object && name in properties) {
            return properties[name];
        }
        return Json.undefined;
    }
    
    /**
     * Set a property value
     */
    void setProperty(string name, Json value) @trusted {
        if (properties.type != Json.Type.object) {
            properties = Json.emptyObject;
        }
        properties[name] = value;
    }
    
    /**
     * Check if property exists
     */
    bool hasProperty(string name) @trusted {
        return properties.type == Json.Type.object && name in properties;
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
