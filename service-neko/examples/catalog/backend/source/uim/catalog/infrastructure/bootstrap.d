/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
/// Composition root shared by the server, the CLI and the GUI: configuration,
/// storage selection and engine wiring.
module uim.catalog.infrastructure.bootstrap;

import uim.service;
import uim.service.presentation.odata;
import uim.catalog.application.catalog;
import uim.catalog.presentation.odata;

@safe:

struct CatalogRuntime {
  Json config;
  CatalogApplication app;
  ODataEngine engine;
}

/// Load configuration (config/default.json → CATALOG_* env → CF) with optional overrides.
Json catalogConfig(string[string] overrides = null) @trusted {
  auto defaults = parseJsonString(`{"serviceName":"uim-catalog","port":8080,"host":"0.0.0.0",
    "odataPath":"/odata/v4/catalog","defaultTenant":"default","storage":"memory","dataFile":"data/catalog.json",
    "maxPageSize":200,"requireAuthentication":false,"jwtSecret":"","frontendDir":""}`);
  auto config = loadServiceConfiguration("CATALOG", defaults, "config");
  foreach (k, v; overrides)
    config[k] = v;
  return config;
}

CatalogRuntime bootstrapCatalog(Json config) {
  IDocumentStore store = config["storage"].get!string == "file"
    ? new FileDocumentStore(config["dataFile"].get!string) : new MemoryDocumentStore;
  auto app = new CatalogApplication(store);
  auto engine = catalogEngine(app, cast(size_t) config["maxPageSize"].get!long);
  return CatalogRuntime(config, app, engine);
}
