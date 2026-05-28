# uim-framework/scim — SCIM 2.0 Library

## Overview

`uim-scim` is a D / vibe.d library that implements **SCIM 2.0** (System for Cross-domain Identity Management), defined by RFC 7643 (schemas) and RFC 7644 (protocol).

It provides:
- Full SCIM User and Group resource models with all standard attributes
- Enterprise User schema extension (RFC 7643 §4.3)
- Attribute metadata types (`ScimAttributeDef`, mutability, returned, uniqueness)
- Filter expression model (`ScimFilter`) with parse support (RFC 7644 §3.4.2.2)
- PATCH operation model (`ScimPatchRequest`, RFC 7644 §3.5.2)
- List / search request and response types (`ScimListRequest`, `ScimListResponse!T`)
- In-memory store (`UIMScimMemoryStore`) implementing `IScimUserStore` and `IScimGroupStore`

## Quick Start

```d
import uim.scim;

auto store = new UIMScimMemoryStore();

// Create a user
auto u = new ScimUser();
u.userName    = "alice";
u.displayName = "Alice Smith";
u.active      = true;
u.emails      = [ScimMultiValue("alice@example.com", "work", true, "Work", "")];
auto created = store.createUser(u);

// Fetch by name
auto found = store.getUserByName("alice");
assert(found.primaryEmail == "alice@example.com");

// List with filter
auto req = scimListFiltered(ScimFilter.eq("userName", "alice"));
auto res = store.listUsers(req);
assert(res.totalResults == 1);

// PATCH
auto patch = ScimPatchRequest();
patch.operations ~= scimReplace("displayName", "Alice Jones");
store.patchUser(created.id, patch);

// Delete
store.deleteUser(created.id);
```

## Package Structure

```
scim/
  source/uim/scim/
    types/
      attribute.d      # ScimAttributeDef, mutability/returned/uniqueness enums
      filter.d         # ScimFilter struct, ScimFilterOp enum
    schemas/
      resource.d       # ScimResource base class, ScimMeta, ScimError, URN constants
      enterprise.d     # ScimEnterpriseUser, ScimManagerRef
      user.d           # ScimUser, ScimName, ScimMultiValue, ScimAddress, ScimGroupRef
      group.d          # ScimGroup, ScimGroupMember
    operations/
      patch.d          # ScimPatchRequest, ScimPatchOperation, ScimPatchOpType
      list.d           # ScimListRequest, ScimListResponse!T, factory functions
    store/
      istore.d         # IScimUserStore, IScimGroupStore interfaces
      memory.d         # UIMScimMemoryStore (in-memory implementation)
```

## Standards

| RFC   | Title                                                              |
|-------|--------------------------------------------------------------------|
| 7643  | System for Cross-domain Identity Management: Core Schema           |
| 7644  | System for Cross-domain Identity Management: Protocol              |
| 7642  | System for Cross-domain Identity Management: Definitions, Overview |

## License

Apache 2.0 — see root `LICENSE` file.
