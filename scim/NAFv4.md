# NAFv4 Architecture Description — uim-scim (SCIM 2.0)

## 1. Architectural Context (NAFv4 NACV — Concepts View)

`uim-scim` is a sub-library of the **UIM Framework** monorepo. It implements the **SCIM 2.0** identity management protocol (RFC 7643 / RFC 7644) as a reusable D language library. It sits in the **Identity & Access Management** capability of the enterprise services layer.

```
┌─────────────────────────────────────────────────────────────┐
│                  UIM Framework Monorepo                      │
│  ┌─────────┐  ┌────────────┐  ┌─────────┐  ┌───────────┐  │
│  │ uim-core│  │ uim-oop    │  │ uim-opc │  │ uim-scim  │  │
│  └─────────┘  └────────────┘  └─────────┘  └───────────┘  │
└─────────────────────────────────────────────────────────────┘
```

## 2. Operational Node View (NAFv4 NOV-1)

```
Consumer Node                   SCIM Library Node
──────────────                  ─────────────────────────────
vibe.d HTTP handler  ──────►    IScimUserStore
                                IScimGroupStore
                                    │
                                    ▼
                                UIMScimMemoryStore
                                (or future DB-backed store)
```

## 3. System View (NAFv4 NSV-1) — Component Breakdown

| Component              | Layer       | Responsibility                                         |
|------------------------|-------------|--------------------------------------------------------|
| `types/attribute`      | Domain      | Attribute metadata types and enums (RFC 7643 §7)       |
| `types/filter`         | Domain      | Filter expression AST (RFC 7644 §3.4.2.2)              |
| `schemas/resource`     | Domain      | Base resource class, metadata, error, URN constants    |
| `schemas/enterprise`   | Domain      | Enterprise User extension (RFC 7643 §4.3)              |
| `schemas/user`         | Domain      | SCIM User resource with all standard attributes         |
| `schemas/group`        | Domain      | SCIM Group resource and member references               |
| `operations/patch`     | Application | PATCH request model (RFC 7644 §3.5.2)                 |
| `operations/list`      | Application | List/search request and response (RFC 7644 §3.4.2)    |
| `store/istore`         | Application | Interfaces: `IScimUserStore`, `IScimGroupStore`        |
| `store/memory`         | Infrastructure | In-memory concrete store; filter evaluation logic   |

## 4. Standards & Protocol Compliance (NAFv4 NTV — Technical View)

| Standard | Version | Usage in uim-scim                                    |
|----------|---------|------------------------------------------------------|
| RFC 7643 | 2015    | Resource schemas — User, Group, EnterpriseUser       |
| RFC 7644 | 2015    | Protocol — CRUD, PATCH, filter, list/pagination      |
| RFC 7642 | 2015    | Definitions, overview, concepts                      |
| ISO 8601 | —       | DateTime format for `meta.created` / `lastModified`  |
| RFC 5646 | —       | Language/locale tags in `preferredLanguage`, `locale`|
| RFC 3986 | —       | URI format for `meta.location`, `$ref` attributes    |

## 5. Information View (NAFv4 NIV) — Key Data Entities

```
ScimResource (base)
  ├── ScimUser          — RFC 7643 §4.1 — identity + contact attributes
  └── ScimGroup         — RFC 7643 §4.2 — named collection of members

ScimMeta              — common resource metadata (timestamps, ETag, location)
ScimEnterpriseUser    — RFC 7643 §4.3 — enterprise extension attributes
ScimError             — RFC 7644 §3.12 — error response body
ScimFilter            — RFC 7644 §3.4.2.2 — filter expression tree
ScimPatchRequest      — RFC 7644 §3.5.2 — partial update request
ScimListResponse!T    — RFC 7644 §3.4.2 — paginated list response
```

## 6. Service View (NAFv4 NSV-7) — Provided Services

| Service                     | Interface Method            | Contract                                    |
|-----------------------------|-----------------------------|---------------------------------------------|
| Create User                 | `IScimUserStore.createUser` | Assigns id, sets meta, enforces unique name |
| Read User (by id)           | `IScimUserStore.getUser`    | Returns null if not found                   |
| Read User (by userName)     | `IScimUserStore.getUserByName` | Case-insensitive match                   |
| Replace User (PUT)          | `IScimUserStore.replaceUser`| Preserves `meta.created`                   |
| Partial Update (PATCH)      | `IScimUserStore.patchUser`  | Applies attribute-level operations           |
| Delete User                 | `IScimUserStore.deleteUser` | Returns false if not found                  |
| List / Filter Users         | `IScimUserStore.listUsers`  | Filter, sort, paginate                      |
| Create / Read / … Group     | `IScimGroupStore.*`         | Mirror of user operations                  |

## 7. Security Considerations

- **Authentication**: Not included in this library. Consumers must authenticate requests (e.g., Bearer token via vibe.d middleware) before calling store methods.
- **Authorization**: Access control (e.g., read-only vs. write) must be enforced by the caller.
- **Password handling**: `ScimUser.password` is write-only and should be hashed before storage. The memory store stores the raw value — **not for production use**.
- **Input validation**: `createUser` enforces non-null, non-empty `userName` and rejects duplicates. Callers should validate full RFC 7643 constraints for production stores.
- **TLS**: Out of scope; handled by vibe.d HTTP server configuration.

## 8. Deployment View (NAFv4 NLV)

```
┌───────────────────────────────────────────┐
│           Application Process              │
│                                           │
│  vibe.d HTTP server                       │
│       │                                   │
│       ▼                                   │
│  SCIM HTTP handler (user-provided)        │
│       │  uses                             │
│       ▼                                   │
│  UIMScimMemoryStore  ◄── swap for         │
│  (or DB-backed impl)    SQL/LDAP store    │
└───────────────────────────────────────────┘
```

## 9. Evolution / Roadmap

| Planned Capability        | Notes                                                 |
|---------------------------|-------------------------------------------------------|
| HTTP endpoint handlers    | vibe.d `URLRouter` handlers for `/Users`, `/Groups`   |
| Bulk operations           | RFC 7644 §3.7 — batch create/update/delete            |
| Database-backed store     | `UIMScimSqlStore` using uim-framework `:sql`          |
| Schema discovery endpoint | `/Schemas`, `/ResourceTypes`, `/ServiceProviderConfig`|
| Full filter parser        | Recursive descent for complex compound filters        |
| ETag / conditional updates| RFC 7232 `If-Match` / `If-None-Match` support         |
