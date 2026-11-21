# UML — Service Library (neko-platform-service)


## Documentation update

This document is maintained alongside the implementation, deployment manifests, and tests for the same package so the service documentation stays aligned with the codebase.

> The `service` package is a **shared D library** — not an HTTP service.
> It provides the hexagonal-architecture scaffolding mixins, interfaces,
> base entities, and use-case helpers that every UIM Platform service depends on.

## Module Structure

```mermaid
classDiagram
    class IEntity {
        <<interface>>
        +Id id
        +Json toJson()
    }
    class IRepository~T~ {
        <<interface>>
        +T findById(Id)
        +T[] findAll()
        +void save(T)
        +void remove(Id)
    }
    class IService {
        <<interface>>
        +void start()
        +void stop()
    }
    class IConfig {
        <<interface>>
        +string host
        +ushort port
    }
    class ITenantEntity {
        <<interface>>
        +TenantId tenantId
    }
    class UsecaseResult {
        +bool success
        +string id
        +string errorMessage
    }

    IEntity <|-- ITenantEntity
    IRepository~T~ ..> IEntity : T
    IService --> IConfig : uses
```

---

## Mixin / Template Hierarchy

```mermaid
flowchart TB
    subgraph Mixins["Mixins (source/uim/platform/service/mixins/)"]
        M1[ObjMixin — id + toJson scaffolding]
        M2[DomainMixin — entity + repository]
        M3[RepositoryMixin — in-memory CRUD]
        M4[StoreMixin — store interface impl]
        M5[ServiceMixin — vibe.d server bootstrap]
        M6[ConfigMixin — env-based SrvConfig]
    end
    subgraph Entities["Base Entities (mixins/entities/)"]
        E1[GlobalEntity — tenantId + id]
        E2[IdEntity — strong-typed Id wrapper]
        E3[ResourceEntity — ResourceId + name]
    end
    subgraph Application["Application Helpers (application/)"]
        A1[dto.d — UsecaseResult + QueryResult]
        A2[usecases/id.d — IdUseCase base]
        A3[usecases/tenant.d — TenantUseCase base]
    end
    subgraph Interfaces["Interfaces (interfaces/)"]
        I1[IEntity, ITenantEntity]
        I2[IRepository~T~]
        I3[IService, IConfig, IStore]
    end

    M2 --> I1
    M3 --> I2
    M5 --> I3
    A2 --> A1
```

---

## Usage Pattern — Service Bootstrap

```mermaid
sequenceDiagram
    participant main as app main()
    participant CFG as SrvConfig (ConfigMixin)
    participant CTR as Container (buildContainer)
    participant SVC as HTTPService (ServiceMixin)

    main->>CFG: load from env (HOST/PORT)
    main->>CTR: buildContainer(cfg)
    CTR-->>main: DI container with repos + use cases
    main->>SVC: new HTTPService(container)
    SVC->>SVC: URLRouter + Controllers
    SVC-->>main: listenHTTP(cfg.host, cfg.port)
```

---

## Clean Architecture Layers (2026-11 redesign)

```mermaid
flowchart LR
    subgraph presentation["presentation (opt-in adapters)"]
        ODC[odata.ODataController<br/>HTTP, $batch, $metadata]
        CLI[cli.CliApplication<br/>registerEntityCommands]
        GUI[gui.EntityBrowserWindow<br/>GtkD 3]
        ENG[odata.ODataEngine<br/>model + validation + scopes]
    end
    subgraph ports
        ESP[[services.IEntitySetProvider]]
        ACT[[services.IActionHandler]]
        CTX[services.RequestContext]
        DOC[[storages.IDocumentStore]]
        REPO[[repositories.*]]
    end
    subgraph application
        DESP[services.DocumentEntitySetProvider]
    end
    subgraph persistence
        MEM[storages.documents.MemoryDocumentStore]
        FILE[storages.documents.FileDocumentStore]
        REPOS[repositories.*]
    end
    subgraph infrastructure
        SEC[security: resolveRequestContext<br/>Hs256/Rs256TokenVerifier]
        CFG[configuration: loadServiceConfiguration]
        LOG[logging: logStructured]
    end
    ODC --> ENG
    CLI --> ENG
    GUI --> ENG
    ODC --> SEC
    ENG --> ESP
    ENG --> ACT
    DESP -. implements .-> ESP
    DESP --> DOC
    MEM -. implements .-> DOC
    FILE --> MEM
    REPOS -. implements .-> REPO
```

## OData Engine

```mermaid
classDiagram
    class ODataServiceModel {
        +string namespace_
        +string containerName
        +ODataEntitySetDef entitySet(name, type)
        +ODataEntitySetDef singletonSet(name, type)
        +ODataComplexTypeDef complexType(name)
        +ODataActionDef action(name, returnType)
        +validate()
    }
    class ODataEntitySetDef {
        +string key
        +ODataPropertyDef[] properties
        +bool insertable/updatable/deletable
        +string[] lineItem, selectionFields
        +string readScope, writeScope
        +tenantAware() writable() titled() columns() filters() scopes()
    }
    class ODataEngine {
        +bool enforceScopes
        +size_t maxPageSize
        +provide(set, IEntitySetProvider)
        +handle(action, IActionHandler)
        +verify()
        +ODataPage query(ctx, set, options)
        +Json read/create/update(ctx, ...)
        +remove(ctx, set, key)
        +Json invoke(ctx, action, params)
    }
    class ODataController {
        +ITokenVerifier verifier
        +bool requireAuthentication
        +registerRoutes(URLRouter)
        +ODataHttpResponse dispatch(ctx, ODataHttpRequest)
    }
    class IEntitySetProvider {
        <<interface>>
        +Json[] list(ctx)
        +Json get(ctx, key)
        +Json create(ctx, payload)
        +Json update(ctx, key, payload)
        +remove(ctx, key)
    }
    ODataServiceModel "1" o-- "*" ODataEntitySetDef
    ODataEngine --> ODataServiceModel
    ODataEngine --> IEntitySetProvider
    ODataController --> ODataEngine
    CliApplication ..> ODataEngine : registerEntityCommands
    EntityBrowserWindow --> ODataEngine
```

## Request Sequence (Fiori → OData)

```mermaid
sequenceDiagram
    participant UI5 as Fiori (UI5 v4 model)
    participant AR as approuter (XSUAA)
    participant C as ODataController
    participant S as security
    participant E as ODataEngine
    participant P as IEntitySetProvider
    UI5->>AR: POST /odata/v4/x/$batch
    AR->>C: + Authorization: Bearer JWT
    C->>S: resolveRequestContext(token, verifier)
    S-->>C: RequestContext(tenant, user, scopes)
    loop each batch operation / change set
        C->>E: query / create / update / remove / invoke
        E->>E: validate payload vs. EDM, check scope
        E->>P: list/get/create/update/remove
        P-->>E: JSON rows
    end
    C-->>UI5: multipart/mixed batch response
```
