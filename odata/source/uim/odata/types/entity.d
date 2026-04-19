/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.odata.types.entity;

import vibe.data.json : Json;

@safe:

/// Runtime representation of an OData entity instance.
/// The `data` field holds all property values as a vibe.d Json object.
struct ODataEntity {
    string entitySetName;
    Json data;

    /// Returns a property value by name.
    Json opIndex(string propertyName) const @trusted {
        return data[propertyName];
    }

    /// Checks whether the entity holds valid data.
    bool isValid() const @trusted {
        return data.type != Json.Type.undefined && data.type != Json.Type.null_;
    }
}
