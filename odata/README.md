# uim-odata

OData v4 protocol library for the UIM framework, built on vibe.d using
**clean architecture** and **hexagonal architecture** principles.

## Architecture

The library is organised into concentric layers with dependencies pointing
inward.  External systems (HTTP, databases) are reached through port
interfaces so the core business logic never depends on infrastructure.

```
┌──────────────────────────────────────────────────────────┐
│  Adapters (classes/)                                     │
│  ┌────────────────────────────────────────────────────┐  │
│  │  Application  (usecases/)                          │  │
│  │  ┌──────────────────────────────────────────────┐  │  │
│  │  │  Ports (interfaces/)                         │  │  │
│  │  │  ┌────────────────────────────────────────┐  │  │  │
│  │  │  │  Domain (types/ + enumerations/)       │  │  │  │
│  │  │  └────────────────────────────────────────┘  │  │  │
│  │  └──────────────────────────────────────────────┘  │  │
│  └────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────┘
```

### Layer overview

| Layer | Package | Responsibility |
|-------|---------|---------------|
| **Domain** | `enumerations/`, `types/` | EDM primitive types, entity type definitions, value objects (`QueryOptions`, `ODataRequest`, `ODataResponse`) — no framework dependencies |
| **Ports** | `interfaces/` | `IEntityRepository`, `IEdmModelProvider`, `IODataProcessor` — abstract boundaries that adapters implement |
| **Application** | `usecases/` | One class per OData operation (`QueryEntitiesUseCase`, `GetEntityUseCase`, `CreateEntityUseCase`, …) — orchestrates domain through ports |
| **Adapters** | `classes/` | `ODataRouter` (vibe.d driving adapter), `ODataProcessor` (wires use cases), `InMemoryEntityRepository` (driven adapter), `ODataJsonSerializer` |
| **Infrastructure** | `parsing/` | OData URI parser, query-option parser (`$filter`, `$select`, `$orderby`, `$top`, `$skip`, `$count`) |

### Hexagonal ports

```
 HTTP (vibe.d)                            Storage
      │                                      ▲
      ▼                                      │
 ┌──────────┐    ┌────────────┐    ┌─────────────────┐
 │ODataRouter│───▶│ODataProcessor│───▶│IEntityRepository│
 │ (driving) │    │ (app core) │    │   (driven port) │
 └──────────┘    └────────────┘    └─────────────────┘
```

## Quick start

```d
import uim.odata;
import vibe.d;

void main() {
    // 1. Define your EDM model
    auto model = new EdmModel([EdmSchema(
        "MyApp",
        [EdmEntityType(
            "Product", "MyApp",
            ["Id"],
            [
                EdmProperty("Id",    EdmPrimitiveType.int32,   false),
                EdmProperty("Name",  EdmPrimitiveType.string_, true),
                EdmProperty("Price", EdmPrimitiveType.decimal, true),
            ],
        )],
        [EdmEntitySet("Products", "MyApp.Product")],
    )]);

    // 2. Create repository (swap for DB adapter in production)
    auto repo = new InMemoryEntityRepository;
    repo.registerEntitySet("Products", "Id");

    // 3. Wire up processor and router
    auto processor = new ODataProcessor(repo, model);
    auto router    = new URLRouter;
    new ODataRouter(processor, "/odata").register(router);

    // 4. Start serving
    auto settings = new HTTPServerSettings;
    settings.port = 8080;
    listenHTTP(settings, router);
    runApplication();
}
```

Endpoints:

| Verb | URL | Description |
|------|-----|-------------|
| `GET` | `/odata/` | Service document |
| `GET` | `/odata/$metadata` | EDM metadata (CSDL JSON) |
| `GET` | `/odata/Products` | List products |
| `GET` | `/odata/Products(42)` | Get product by key |
| `GET` | `/odata/Products?$top=5&$orderby=Name` | Query with options |
| `GET` | `/odata/Products/$count` | Entity count |
| `POST` | `/odata/Products` | Create product |
| `PUT` | `/odata/Products(42)` | Full update |
| `PATCH` | `/odata/Products(42)` | Partial update |
| `DELETE` | `/odata/Products(42)` | Delete product |

## Extending

Implement `IEntityRepository` to connect to your storage back-end (SQL,
document DB, remote API, …).  The in-memory implementation in
`classes/repository.d` serves as a reference.

## Dependencies

- `uim-framework:errors` (transitively provides core, oop, jsons)
- `vibe-d ~>0.10.3`
