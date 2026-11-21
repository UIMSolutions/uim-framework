# Catalog — reference service for neko-platform-service

A small product catalog that shows the target architecture end to end:
a D/vibe.d backend in Clean Architecture, one EDM model exposed as **OData v4**
(SAP Fiori 3 frontend), **CLI** and **GtkD GUI**, deployed with an **approuter**
and XSUAA via `mta.yaml`.

```
catalog/
├── mta.yaml
├── backend/                       dub package (configs: server, cli, gui, unittest)
│   ├── config/default.json
│   └── source/
│       ├── app.d  cli.d  gui.d    entry points
│       └── uim/catalog/
│           ├── domain/products.d              SKU / price / status rules (pure)
│           ├── application/catalog.d          providers + rules + Reprice action
│           ├── presentation/odata.d           EDM model, engine wiring
│           └── infrastructure/bootstrap.d     config + storage selection
├── frontend/                      UI5 app (manifest, Component, view, controller, model, i18n, localService, test)
└── approuter/                     xs-app.json, xs-security.json, default-env.json (local only, git-ignored)
```

Model: `Products` (CRUD, SKU immutable), `Categories` (CRUD, delete blocked while
used), `Statistics` (singleton), action `Reprice(percent, categoryId)`.

## Run locally

```bash
cd backend
dub build && dub build --config=cli && dub build --config=gui

# server: OData + Fiori app (http://localhost:8080/app/index.html)
CATALOG_STORAGE=file ./build/uim-catalog-server

# CLI (same data file as the server)
./build/uim-catalog-cli create Categories --name=Fasteners
./build/uim-catalog-cli create Products --sku=BOLT-M8 --name="Bolt M8" --price=2.5 --stock=100 --status=active
./build/uim-catalog-cli list Products --filter="price lt 5" --orderby="name" --count
./build/uim-catalog-cli invoke Reprice --percent=10
./build/uim-catalog-cli get Statistics --json

# desktop GUI (auto refresh every 10 s with file storage)
./build/uim-catalog-gui --tenant=default
```

`--data-file=<path>` / `--storage=memory` override the storage for CLI and GUI.
Every config key can be set as `CATALOG_<KEY>` (e.g. `CATALOG_PORT=9000`).

## Security

| Setup | Behaviour |
|---|---|
| no XSUAA binding, `requireAuthentication=false` | open, tenant from `X-Tenant-Id` (development) |
| `requireAuthentication=true` + `jwtSecret` | HS256 tokens required, scopes enforced |
| XSUAA bound (Cloud Foundry) | RS256 via `verificationkey`, scopes `Read`/`Write` enforced |

## Deploy

```bash
mbt build && cf deploy mta_archives/uim-catalog_1.0.0.mtar
```

The file store sits on the container's ephemeral disk; implement `IDocumentStore`
over a database before storing real data.
