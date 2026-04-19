/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.odata.usecases.metadata;

import vibe.data.json : Json;

import uim.odata.types.model;
import uim.odata.types.request;

@safe:

/// Use case: serve the OData service document and $metadata.
class MetadataUseCase {
    private EdmModel _model;

    this(EdmModel model) {
        _model = model;
    }

    /// GET /$metadata — returns the Entity Data Model as JSON.
    ODataResponse execute() @trusted {
        auto result = Json.emptyObject;
        result["$Version"] = Json("4.0");

        auto schemasArr = Json.emptyArray;

        foreach (schema; _model.schemas) {
            auto s = Json.emptyObject;
            s["$Namespace"] = Json(schema.namespace);

            // Entity types
            auto typesObj = Json.emptyObject;
            foreach (et; schema.entityTypes) {
                auto t = Json.emptyObject;

                // Key
                auto keyArr = Json.emptyArray;
                foreach (k; et.keyProperties)
                    keyArr ~= Json(k);
                t["$Key"] = keyArr;

                // Properties
                foreach (prop; et.properties) {
                    auto p = Json.emptyObject;
                    p["$Type"] = Json(prop.typeName);
                    p["$Nullable"] = Json(prop.nullable);
                    if (prop.maxLength >= 0)
                        p["$MaxLength"] = Json(prop.maxLength);
                    t[prop.name] = p;
                }

                // Navigation properties
                foreach (nav; et.navigationProperties) {
                    auto n = Json.emptyObject;
                    n["$Type"] = Json(nav.targetEntityType);
                    n["$Collection"] = Json(nav.isCollection);
                    if (nav.partner.length > 0)
                        n["$Partner"] = Json(nav.partner);
                    t[nav.name] = n;
                }

                typesObj[et.name] = t;
            }
            s["$EntityType"] = typesObj;

            // Entity container / sets
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
        return ODataResponse.ok(result);
    }

    /// GET / — returns the OData service document listing all entity sets.
    ODataResponse executeServiceDocument() @trusted {
        auto result = Json.emptyObject;
        result["@odata.context"] = Json("$metadata");

        auto valueArr = Json.emptyArray;
        foreach (es; _model.allEntitySets) {
            auto entry = Json.emptyObject;
            entry["name"] = Json(es.name);
            entry["kind"] = Json("EntitySet");
            entry["url"]  = Json(es.name);
            valueArr ~= entry;
        }
        result["value"] = valueArr;

        return ODataResponse.ok(result);
    }
}
