# neko-platform-service

Shared library for all UIM platform services: hexagonal scaffolding (entities,
repositories, use cases) plus **opt-in adapters that give a service an OData v4
endpoint for SAP Fiori, a command line interface and a GtkD desktop GUI from one
EDM model**.

See also [UML.md](UML.md) and [nafv4-architecture.md](nafv4-architecture.md).
A complete reference app (backend, Fiori frontend, approuter, `mta.yaml`) lives
in [examples/catalog](examples/catalog/README.md).

## Layout

```
source/uim/platform/service/
├── domain/           entities, types, enumerations, services
├── application/      dto, usecases (Id/Tenant), services (DocumentEntitySetProvider)
├── ports/            repositories, storages (IDocumentStore), services (IEntitySetProvider,
│                     IActionHandler, RequestContext)
├── persistence/      repositories (Base/Id/Tenant), storages (id, tenant, documents: memory/file)
├── infrastructure/   configuration (layered), security (JWT), logging (structured), tests
├── presentation/
│   ├── http/         health controller
│   ├── odata/        OData v4: model, metadata, query, resource, batch, engine, controller, values  (opt-in)
│   ├── cli/          args, table, app, entities                                             (opt-in)
│   └── gui/          GtkD entity browser                                                    (opt-in)
└── classes/, interfaces/, mixins/, helpers/, exceptions/   (unchanged scaffolding)
```

`domain/ports/*`, `infrastructure/repositories|stores/*` and `interfaces/stores/*`
are **deprecated forwarding modules** to `ports/` and `persistence/` — existing
imports keep compiling.

`import uim.service;` exports everything except the protocol adapters.
Import those explicitly, so their names cannot clash with service-specific code:

```d
import uim.service.presentation.odata;
import uim.service.presentation.cli;
import uim.service.presentation.gui;   // compiled only with gtk-d (version Have_gtk_d)
```

## One model, three front ends

```d
// 1. describe the service (drives $metadata, validation, CLI and GUI)
auto model = new ODataServiceModel("uim.demo", "DemoService", "Demo");
model.entitySet("Products", "Product")
  .tenantAware()                                   // id, tenantId, createdAt/By, updatedAt/By (computed)
  .property("name", Edm.string_, "Name", false)    // mandatory
  .property("price", Edm.decimal, "Price")
  .writable()
  .titled("Product", "Products", "name")           // UI.HeaderInfo
  .columns("name", "price")                        // UI.LineItem
  .filters("name")                                 // UI.SelectionFields
  .scopes("Read", "Write");
model.action("Recalculate", Edm.int32).parameter("dryRun", Edm.boolean);

// 2. bind providers (wrap your use cases, or use the document store for zero-code sets)
auto engine = new ODataEngine(model)
  .provide("Products", new DocumentEntitySetProvider(new FileDocumentStore("data/demo.json"), "Products"))
  .handle("Recalculate", (const RequestContext ctx, Json p) @safe => Json(0));
engine.verify();

// 3a. HTTP / Fiori
new ODataController(engine, "/odata/v4/demo").registerRoutes(router);
// 3b. CLI:  list/count/get/create/update/delete/invoke/sets/metadata
auto cli = new CliApplication("demo-cli", "Demo administration");
registerEntityCommands(cli, engine);
return cli.run(args[1 .. $]);
// 3c. GUI
return runEntityBrowser(engine, "default", "admin", args[0 .. 1]);
```

Custom providers implement `IEntitySetProvider` (or use `DelegateEntitySetProvider`
/ `ReadOnlyEntitySetProvider`) and throw `EntitySetException(status, code, msg)`
for business errors; each adapter maps it (HTTP status, CLI exit code 1, GUI dialog).

### OData v4 features

- service document, `$metadata` (CSDL 4.0) with `Common.Label`, `Core.Computed/Immutable`,
  `Capabilities.*`, `UI.HeaderInfo/LineItem/SelectionFields`
- `$filter` (eq ne gt ge lt le, in, and or not, contains startswith endswith tolower toupper trim
  concat substring length indexof year month day hour minute second), `$orderby`, `$select`,
  `$top`, `$skip`, `$count`, `$search`, server-driven paging (`maxPageSize` → `@odata.nextLink`)
- CRUD per capability, singletons, unbound actions, `Prefer: return=minimal`, `IEEE754Compatible`
- `$batch`: multipart/mixed incl. change sets and `$<Content-ID>` references, and JSON batch
- payload validation against the EDM types; numeric strings are stored as numbers
- not supported: navigation properties / `$expand`, `$apply`, ETags, atomic change sets

### Security

`resolveRequestContext` takes tenant (`zid`) and user from the bearer token. Scopes are
only trusted when an `ITokenVerifier` verified the token:

- `Rs256TokenVerifier(xsuaa.verificationkey)` — SAP XSUAA tokens (OpenSSL)
- `Hs256TokenVerifier(secret)` — shared secret, service-to-service, tests

Set `controller.requireAuthentication = true` and `engine.enforceScopes = true` in
production. Without a verifier the `X-Tenant-Id` header is honoured — local use only.

### Configuration

`loadServiceConfiguration(prefix, defaults, "config")` merges, lowest to highest:
defaults → `config/default.json` → `config/<UIM_PROFILE>.json` → `<PREFIX>_<KEY>`
env vars (`basePath` ↔ `BASE_PATH`) → Cloud Foundry `PORT`, `VCAP_APPLICATION`,
`VCAP_SERVICES` (`serviceCredentials(config, "xsuaa")`).

## Build & test

```bash
dub build            # library
dub test             # 40 modules
cd examples/catalog/backend && dub test --config=unittest
```

Note: dmd 2.112 crashes (ICE) on `aa[key][field] = value` with a `Json[string]` AA
when compiling with `-g -unittest`; assign through a local copy instead.
