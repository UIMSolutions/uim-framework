/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.odata.types.entitytype;

import uim.odata.types.property;

@safe:

/// Represents a navigation property (relationship between entity types).
struct EdmNavigationProperty {
    string name;
    string targetEntityType;
    bool isCollection;
    string partner;
}

/// Represents an OData entity type definition in the EDM.
struct EdmEntityType {
    string name;
    string namespace;
    string[] keyProperties;
    EdmProperty[] properties;
    EdmNavigationProperty[] navigationProperties;

    /// Returns the fully qualified type name (e.g. "Namespace.EntityType").
    string fullName() const pure nothrow {
        if (namespace.length == 0)
            return name;
        return namespace ~ "." ~ name;
    }

    /// Finds a property by name.  Returns EdmProperty.init when not found.
    EdmProperty findProperty(string propName) const pure nothrow {
        foreach (ref p; properties) {
            if (p.name == propName)
                return p;
        }
        return EdmProperty.init;
    }
}

/// Represents an OData entity set (a collection endpoint backed by an entity type).
struct EdmEntitySet {
    string name;
    string entityTypeName;
}
