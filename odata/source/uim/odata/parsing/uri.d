/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.odata.parsing.uri;

import std.algorithm.searching : endsWith;
import std.string : indexOf;

import uim.odata.types.queryoptions;
import uim.odata.types.request : RequestType;
import uim.odata.parsing.queryoptions;

@safe:

/// Result of parsing an OData URI.
struct ParsedUri {
    RequestType type;
    string entitySetName;
    string entityKey;
    string propertyPath;
    QueryOptions queryOptions;
}

/// Parses a raw request URI (path + query string) into OData components.
///
/// Examples:
///   /odata/$metadata              -> metadata
///   /odata/Products               -> entitySet "Products"
///   /odata/Products(42)           -> entity "Products" key "42"
///   /odata/Products('abc')        -> entity "Products" key "abc"
///   /odata/Products/$count        -> entityCount "Products"
///   /odata/Products?$top=10       -> entitySet with query options
ParsedUri parseODataUri(string requestUri, string basePath = "/odata") {
    ParsedUri result;

    // ---- split path and query string --------------------------------
    string path;
    string queryString;
    auto qPos = indexOf(requestUri, '?');
    if (qPos >= 0) {
        path = requestUri[0 .. qPos];
        queryString = requestUri[qPos + 1 .. $];
    } else {
        path = requestUri;
    }

    // ---- strip base path --------------------------------------------
    if (path.length >= basePath.length && path[0 .. basePath.length] == basePath)
        path = path[basePath.length .. $];

    // strip leading slash
    if (path.length > 0 && path[0] == '/')
        path = path[1 .. $];

    // ---- special paths ----------------------------------------------
    if (path == "$metadata") {
        result.type = RequestType.metadata;
        return result;
    }
    if (path.length == 0) {
        result.type = RequestType.serviceDocument;
        return result;
    }

    // ---- $count suffix ----------------------------------------------
    if (path.endsWith("/$count")) {
        result.type = RequestType.entityCount;
        path = path[0 .. $ - 7];
    }

    // ---- entity set name + optional key -----------------------------
    auto parenPos = indexOf(path, '(');
    if (parenPos >= 0) {
        result.entitySetName = path[0 .. parenPos];
        auto rest = path[parenPos + 1 .. $];
        auto closePos = indexOf(rest, ')');
        if (closePos >= 0) {
            auto keyStr = rest[0 .. closePos];
            // strip surrounding single-quotes for string keys
            if (keyStr.length >= 2 && keyStr[0] == '\'' && keyStr[$ - 1] == '\'')
                keyStr = keyStr[1 .. $ - 1];
            result.entityKey = keyStr;
            if (result.type != RequestType.entityCount)
                result.type = RequestType.entity;
        }
    } else {
        result.entitySetName = path;
        if (result.type != RequestType.entityCount)
            result.type = RequestType.entitySet;
    }

    // ---- query options ----------------------------------------------
    if (queryString.length > 0)
        result.queryOptions = parseQueryString(queryString);

    return result;
}
