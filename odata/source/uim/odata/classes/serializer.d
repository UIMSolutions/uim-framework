/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.odata.classes.serializer;

import vibe.data.json : Json;

import uim.odata.types.entitytype;
import uim.odata.types.model;
import uim.odata.types.queryoptions;

@safe:

/// OData JSON serialization helpers.
/// These produce the standard OData v4 JSON wire format (minimal metadata).

/// Wraps an array of Json entities in the OData collection envelope.
Json serializeEntitySet(
    string entitySetName,
    Json[] entities,
    bool includeCount = false,
    ulong totalCount = 0,
) @trusted {
    auto result = Json.emptyObject;
    result["@odata.context"] = Json("$metadata#" ~ entitySetName);

    if (includeCount)
        result["@odata.count"] = Json(cast(long) totalCount);

    auto arr = Json.emptyArray;
    foreach (e; entities)
        arr ~= e;
    result["value"] = arr;

    return result;
}

/// Wraps a single entity in the OData entity envelope.
Json serializeEntity(string entitySetName, Json entity) @trusted {
    auto result = Json.emptyObject;
    result["@odata.context"] = Json("$metadata#" ~ entitySetName ~ "/$entity");

    if (entity.type == Json.Type.object) {
        foreach (string k, v; entity.byKeyValue)
            result[k] = v;
    }

    return result;
}

/// Serializes an OData error in the standard format.
Json serializeError(string code, string message) @trusted {
    auto error = Json.emptyObject;
    error["code"] = Json(code);
    error["message"] = Json(message);

    auto envelope = Json.emptyObject;
    envelope["error"] = error;
    return envelope;
}

/// Serializes an EdmEntityType to its JSON metadata representation.
Json serializeEntityType(EdmEntityType et) @trusted {
    auto t = Json.emptyObject;

    auto keyArr = Json.emptyArray;
    foreach (k; et.keyProperties)
        keyArr ~= Json(k);
    t["$Key"] = keyArr;

    foreach (prop; et.properties) {
        auto p = Json.emptyObject;
        p["$Type"] = Json(prop.typeName);
        p["$Nullable"] = Json(prop.nullable);
        if (prop.maxLength >= 0)
            p["$MaxLength"] = Json(prop.maxLength);
        t[prop.name] = p;
    }

    foreach (nav; et.navigationProperties) {
        auto n = Json.emptyObject;
        n["$Type"] = Json(nav.targetEntityType);
        n["$Collection"] = Json(nav.isCollection);
        if (nav.partner.length > 0)
            n["$Partner"] = Json(nav.partner);
        t[nav.name] = n;
    }

    return t;
}

/// Serializes the full EDM model to OData $metadata JSON (CSDL JSON).
Json serializeModel(EdmModel model) @trusted {
    auto result = Json.emptyObject;
    result["$Version"] = Json("4.0");

    auto schemasArr = Json.emptyArray;
    foreach (schema; model.schemas) {
        auto s = Json.emptyObject;
        s["$Namespace"] = Json(schema.namespace);

        auto typesObj = Json.emptyObject;
        foreach (et; schema.entityTypes)
            typesObj[et.name] = serializeEntityType(et);
        s["$EntityType"] = typesObj;

        auto container = Json.emptyObject;
        foreach (es; schema.entitySets) {
            auto setObj = Json.emptyObject;
            setObj["$Collection"] = Json(true);
            setObj["$Type"] = Json(es.entityTypeName);
            container[es.name] = setObj;
        }
        s["$EntityContainer"] = container;

        schemasArr ~= s;
    }

    result["$Schema"] = schemasArr;
    return result;
}
