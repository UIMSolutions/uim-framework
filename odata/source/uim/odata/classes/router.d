/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.odata.classes.router;

import std.conv : to;

import vibe.d;

import uim.odata.interfaces.processor;
import uim.odata.parsing.uri;
import uim.odata.types.request;

@safe:

/// Primary (driving) adapter — maps vibe.d HTTP requests to the OData
/// processor port and translates responses back to HTTP.
///
/// Usage:
/// ---
///   auto router   = new URLRouter;
///   auto odataRtr = new ODataRouter(processor, "/odata");
///   odataRtr.register(router);
///   listenHTTP(settings, router);
/// ---
class ODataRouter {
    private IODataProcessor _processor;
    private string _basePath;

    this(IODataProcessor processor, string basePath = "/odata") {
        _processor = processor;
        _basePath = basePath;
    }

    /// Registers OData routes on the given vibe.d URLRouter.
    void register(URLRouter router) @trusted {
        auto proc = _processor;
        auto bp = _basePath;

        auto wildcard = bp ~ "/*";

        // GET — queries, single-entity reads, $metadata, service document
        router.get(wildcard, (scope HTTPServerRequest req, scope HTTPServerResponse res) @trusted {
            handleRequest(proc, bp, "GET", req, res);
        });
        router.get(bp, (scope HTTPServerRequest req, scope HTTPServerResponse res) @trusted {
            handleRequest(proc, bp, "GET", req, res);
        });

        // POST — entity creation
        router.post(wildcard, (scope HTTPServerRequest req, scope HTTPServerResponse res) @trusted {
            handleRequest(proc, bp, "POST", req, res);
        });

        // PUT — full entity update
        router.put(wildcard, (scope HTTPServerRequest req, scope HTTPServerResponse res) @trusted {
            handleRequest(proc, bp, "PUT", req, res);
        });

        // PATCH — partial entity update
        router.patch(wildcard, (scope HTTPServerRequest req, scope HTTPServerResponse res) @trusted {
            handleRequest(proc, bp, "PATCH", req, res);
        });

        // DELETE — entity deletion
        router.match(HTTPMethod.DELETE, wildcard,
            (scope HTTPServerRequest req, scope HTTPServerResponse res) @trusted {
                handleRequest(proc, bp, "DELETE", req, res);
            }
        );
    }
}

// ---------------------------------------------------------------------------
// Module-level helpers (kept out of the class for @trusted simplicity)
// ---------------------------------------------------------------------------

private void handleRequest(
    IODataProcessor proc,
    string basePath,
    string method,
    scope HTTPServerRequest req,
    scope HTTPServerResponse res,
) @trusted {
    auto uri = req.requestURI;
    auto parsed = parseODataUri(uri, basePath);

    Json requestBody = Json.init;
    try {
        if (method == "POST" || method == "PUT" || method == "PATCH")
            requestBody = req.json;
    } catch (Exception) {
        // body might be missing or malformed — processor will validate
    }

    auto odataReq = ODataRequest(
        parsed.type,
        parsed.entitySetName,
        parsed.entityKey,
        parsed.propertyPath,
        parsed.queryOptions,
        requestBody,
        method,
    );

    auto odataRes = proc.process(odataReq);
    sendODataResponse(res, odataRes);
}

private void sendODataResponse(
    scope HTTPServerResponse res,
    ODataResponse odataRes,
) @trusted {
    res.statusCode = odataRes.statusCode;
    res.headers["Content-Type"] = "application/json;odata.metadata=minimal";
    res.headers["OData-Version"] = "4.0";

    foreach (key, value; odataRes.headers)
        res.headers[key] = value;

    if (odataRes.body_.type != Json.Type.undefined && odataRes.body_.type != Json.Type.null_)
        res.writeBody(odataRes.body_.toString());
}
