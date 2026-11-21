/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
/// HTTP server: OData v4 for SAP Fiori + health endpoint (+ static Fiori app for local development).
///
///   dub run                     → http://localhost:8080/odata/v4/catalog/$metadata
module app;

import vibe.core.core : runApplication;
import vibe.http.fileserver : serveStaticFiles, HTTPFileServerSettings;
import vibe.http.router : URLRouter;
import vibe.http.server : HTTPServerSettings, listenHTTP, HTTPServerRequest, HTTPServerResponse;
import uim.service;
import uim.service.presentation.odata;
import uim.catalog.infrastructure.bootstrap;

version (unittest) {
} else {
  int main() {
    auto config = catalogConfig();
    auto runtime = bootstrapCatalog(config);

    auto odata = new ODataController(runtime.engine, config["odataPath"].get!string, config["defaultTenant"].get!string);
    // Security: XSUAA binding (RS256, SAP BTP) > shared secret (HS256) > open (local development)
    auto uaa = serviceCredentials(config, "xsuaa");
    if (uaa.isObject && "verificationkey" in uaa) {
      odata.verifier = new Rs256TokenVerifier(uaa["verificationkey"].get!string);
      odata.requireAuthentication = true;
    } else if (config["requireAuthentication"].get!bool) {
      auto secret = config["jwtSecret"].get!string;
      if (secret.length == 0) {
        logError("requireAuthentication needs an XSUAA binding or jwtSecret (HS256)");
        return 1;
      }
      odata.verifier = new Hs256TokenVerifier(secret);
      odata.requireAuthentication = true;
    }
    runtime.engine.enforceScopes = odata.requireAuthentication;

    auto router = new URLRouter;
    router.get("/health", (HTTPServerRequest req, HTTPServerResponse res) {
      auto j = Json.emptyObject;
      j["status"] = "UP";
      j["service"] = config["serviceName"];
      res.writeJsonBody(j);
    });
    odata.registerRoutes(router);

    auto frontend = config["frontendDir"].get!string;
    if (frontend.length > 0) { // local development without approuter
      auto fs = new HTTPFileServerSettings;
      fs.serverPathPrefix = "/app";
      router.get("/app/*", serveStaticFiles(frontend ~ "/", fs));
      router.get("/", (HTTPServerRequest req, HTTPServerResponse res) { res.redirect("/app/index.html"); });
    }

    auto settings = new HTTPServerSettings;
    settings.port = cast(ushort) config["port"].get!long;
    settings.bindAddresses = [config["host"].get!string];
    settings.maxRequestSize = 16 * 1024 * 1024;
    listenHTTP(settings, withRequestLogging(&router.handleRequest, config["serviceName"].get!string));
    logStructured("info", "uim-catalog", "listening", Json(["port": Json(settings.port),
        "odata": config["odataPath"], "storage": config["storage"]]));
    return runApplication();
  }
}
