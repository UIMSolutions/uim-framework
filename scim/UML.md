# UML — uim-scim (SCIM 2.0)

## Class Hierarchy

```
ScimResource (class)
  ├── ScimUser (class)
  └── ScimGroup (class)

UIMObject (class, from uim-oop)
  └── UIMScimMemoryStore (class)
        implements IScimUserStore
        implements IScimGroupStore
```

## Class Diagrams

### ScimResource (base)

```
┌─────────────────────────┐
│        ScimResource      │
├─────────────────────────┤
│ + id          : string   │
│ + externalId  : string   │
│ + schemas     : string[] │
│ + meta        : ScimMeta │
└─────────────────────────┘
```

### ScimMeta (struct)

```
┌───────────────────────────┐
│         ScimMeta           │
├───────────────────────────┤
│ + resourceType  : string   │
│ + created       : string   │
│ + lastModified  : string   │
│ + location      : string   │
│ + version_      : string   │
└───────────────────────────┘
```

### ScimUser

```
┌──────────────────────────────────────────────────┐
│                    ScimUser                       │
│                 (: ScimResource)                  │
├──────────────────────────────────────────────────┤
│ + userName          : string                      │
│ + name              : ScimName                    │
│ + displayName       : string                      │
│ + nickName          : string                      │
│ + profileUrl        : string                      │
│ + title             : string                      │
│ + userType          : string                      │
│ + preferredLanguage : string                      │
│ + locale            : string                      │
│ + timezone          : string                      │
│ + active            : bool                        │
│ + password          : string  (write-only)        │
│ + emails            : ScimMultiValue[]            │
│ + phoneNumbers      : ScimMultiValue[]            │
│ + ims               : ScimMultiValue[]            │
│ + photos            : ScimMultiValue[]            │
│ + addresses         : ScimAddress[]               │
│ + groups            : ScimGroupRef[] (read-only)  │
│ + entitlements      : ScimMultiValue[]            │
│ + roles             : ScimMultiValue[]            │
│ + x509Certificates  : ScimMultiValue[]            │
│ + enterpriseUser    : ScimEnterpriseUser          │
├──────────────────────────────────────────────────┤
│ + primaryEmail() : string                         │
└──────────────────────────────────────────────────┘
```

### ScimGroup

```
┌───────────────────────────────────┐
│          ScimGroup                │
│       (: ScimResource)            │
├───────────────────────────────────┤
│ + displayName : string            │
│ + members     : ScimGroupMember[] │
├───────────────────────────────────┤
│ + hasMember(userId) : bool        │
│ + addMember(m)      : bool        │
│ + removeMember(uid) : bool        │
└───────────────────────────────────┘
```

### Store Interfaces

```
«interface»                         «interface»
IScimUserStore                      IScimGroupStore
──────────────────────              ───────────────────────────
createUser(u)   : ScimUser          createGroup(g)   : ScimGroup
getUser(id)     : ScimUser          getGroup(id)     : ScimGroup
getUserByName(n): ScimUser          replaceGroup(id,g): ScimGroup
replaceUser(id,u): ScimUser         patchGroup(id,r) : bool
patchUser(id,r) : bool              deleteGroup(id)  : bool
deleteUser(id)  : bool              listGroups(req)  : ScimListResponse!ScimGroup
listUsers(req)  : ScimListResponse!ScimUser
```

### UIMScimMemoryStore

```
┌────────────────────────────────────────┐
│          UIMScimMemoryStore             │
│    (: UIMObject, IScimUserStore,        │
│       IScimGroupStore)                  │
├────────────────────────────────────────┤
│ - _users   : ScimUser[string]           │
│ - _groups  : ScimGroup[string]          │
│ - _nextId  : uint                       │
├────────────────────────────────────────┤
│ + createUser / getUser / ...            │
│ + createGroup / getGroup / ...          │
│ - filterMatchesUser(u, f) : bool        │
│ - filterMatchesGroup(g, f): bool        │
│ - paginate!T(items,si,cnt): T[]         │
│ - applyUserPatch(u, req)                │
│ - applyGroupPatch(g, req)               │
└────────────────────────────────────────┘
```

## Filter Expression Model

```
ScimFilter (struct)
  + op        : ScimFilterOp
  + attribute : string        (leaf filters)
  + value     : string        (leaf filters)
  + children  : ScimFilter[]  (and_, or_, not_)

ScimFilterOp (enum)
  eq  ne  co  sw  ew  pr
  gt  lt  ge  le
  not_  and_  or_
```

## PATCH Request Model

```
ScimPatchRequest
  + schemas    : string[]
  + operations : ScimPatchOperation[]

ScimPatchOperation
  + op     : ScimPatchOpType  (add | remove | replace)
  + path   : string
  + values : string[]
```

## List Request / Response

```
ScimListRequest
  + hasFilter  : bool
  + filter     : ScimFilter
  + sortBy     : string
  + sortOrder  : string  ("ascending" | "descending")
  + startIndex : int     (1-based)
  + count      : int

ScimListResponse!T
  + schemas      : string[]
  + totalResults : int
  + startIndex   : int
  + itemsPerPage : int
  + resources    : T[]
```
