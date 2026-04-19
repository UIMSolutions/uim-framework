/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.odata.types.request;

import vibe.data.json : Json;

import uim.odata.types.queryoptions;

@safe:

/// The kind of OData request being made.
enum RequestType {
    serviceDocument,
    metadata,
    entitySet,
    entity,
    entityCount,
    property,
}

/// Parsed OData request — the primary inbound-port data type (hexagonal boundary).
/// The HTTP adapter converts raw HTTP into this domain-neutral representation.
struct ODataRequest {
    RequestType type;
    string entitySetName;
    string entityKey;
    string propertyPath;
    QueryOptions queryOptions;
    Json body_;
    string method; // HTTP verb as string
}

/// OData response — the primary outbound-port data type.
/// The HTTP adapter converts this back into an HTTP response.
struct ODataResponse {
    int statusCode = 200;
    Json body_;
    string[string] headers;

    static ODataResponse ok(Json payload) @trusted {
        ODataResponse r;
        r.statusCode = 200;
        r.body_ = payload;
        return r;
    }

    static ODataResponse created(Json payload) @trusted {
        ODataResponse r;
        r.statusCode = 201;
        r.body_ = payload;
        return r;
    }

    static ODataResponse noContent() {
        ODataResponse r;
        r.statusCode = 204;
        return r;
    }

    static ODataResponse notFound(string message = "Resource not found") @trusted {
        ODataResponse r;
        r.statusCode = 404;
        auto error = Json.emptyObject;
        error["code"] = Json("404");
        error["message"] = Json(message);
        auto envelope = Json.emptyObject;
        envelope["error"] = error;
        r.body_ = envelope;
        return r;
    }

    static ODataResponse badRequest(string message = "Bad request") @trusted {
        ODataResponse r;
        r.statusCode = 400;
        auto error = Json.emptyObject;
        error["code"] = Json("400");
        error["message"] = Json(message);
        auto envelope = Json.emptyObject;
        envelope["error"] = error;
        r.body_ = envelope;
        return r;
    }

    static ODataResponse methodNotAllowed() @trusted {
        ODataResponse r;
        r.statusCode = 405;
        auto error = Json.emptyObject;
        error["code"] = Json("405");
        error["message"] = Json("Method not allowed");
        auto envelope = Json.emptyObject;
        envelope["error"] = error;
        r.body_ = envelope;
        return r;
    }
}
