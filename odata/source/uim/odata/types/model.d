/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.odata.types.model;

import uim.odata.types.entitytype;

@safe:

/// Represents an OData schema containing type definitions and entity sets.
struct EdmSchema {
    string namespace;
    EdmEntityType[] entityTypes;
    EdmEntitySet[] entitySets;
}

/// Represents a complete OData Entity Data Model (the root metadata object).
class EdmModel {
    private EdmSchema[] _schemas;

    this() {
    }

    this(EdmSchema[] schemas) {
        _schemas = schemas;
    }

    /// Adds a schema to the model.
    void addSchema(EdmSchema schema) {
        _schemas ~= schema;
    }

    /// Returns all schemas in the model.
    const(EdmSchema)[] schemas() const nothrow {
        return _schemas;
    }

    /// Finds an entity type by simple or fully-qualified name.
    EdmEntityType findEntityType(string name) const nothrow {
        foreach (ref schema; _schemas) {
            foreach (ref et; schema.entityTypes) {
                if (et.name == name || et.fullName == name)
                    return et;
            }
        }
        return EdmEntityType.init;
    }

    /// Finds an entity set by name.
    EdmEntitySet findEntitySet(string name) const nothrow {
        foreach (ref schema; _schemas) {
            foreach (ref es; schema.entitySets) {
                if (es.name == name)
                    return es;
            }
        }
        return EdmEntitySet.init;
    }

    /// Returns all entity sets across all schemas.
    EdmEntitySet[] allEntitySets() const {
        EdmEntitySet[] result;
        foreach (ref schema; _schemas) {
            result ~= schema.entitySets;
        }
        return result;
    }
}
