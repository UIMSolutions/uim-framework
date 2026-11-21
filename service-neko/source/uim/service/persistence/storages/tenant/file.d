module uim.service.persistence.storages.tenant.file;
import std.file;
import std.path;
import uim.service;

mixin(ShowModule!());

@safe:

class FileTenantStore(TEntity, TId) : ITenantStore!(TEntity, TId) {
    protected string rootPath = "./data/";

    this() {
        // Ensure root path exists
        if (!buildPath(rootPath).exists) {
            mkdirRecurse(rootPath);
        }
    }

    this(string path) {
        rootPath = path;
        // Ensure root path exists
        if (!buildPath(rootPath).exists) {
            mkdirRecurse(rootPath);
        }
    }

    // #region exists
    override bool exists(TenantId tenantId) {
        return buildPath(rootPath, tenantId.value).exists;
    }

    bool exists(TenantId tenantId, TId id) {
        return buildPath(rootPath, tenantId.value, id.value).exists;
    }

    bool exists(TEntity entity) {
        return exists(entity.tenantid, entity.id);
    }
    // #endregion exists

    // #region count
    size_t count(TenantId tenantId) {
        return dirEntries(buildPath(rootPath, tenantId.value), SpanMode.shallow).filter!(f => f.isFile).array.length;
    }
    size_t count(TenantId tenantId, bool delegate(TEntity) @safe predicate) {
        return getEntities(tenantId).filter!(TEntity => predicate(TEntity));
    }
    // #endregion count

    void createTenant(TenantId tenantId) {
         if (!existsTenant(tenantId)) {
             mkdirRecurse(buildPath(rootPath, tenantId.value));
         }
     }

    TEntity[TId] getEntities(TenantId tenantId) {
        TEntity[TId] results;
        // Implementation would typically iterate files in directory
        return results;
    }

//     override void removeTenant(TenantId tenantId) {
//         if (existsTenant(tenantId)) {
//             rmdirRecurse(buildPath(rootPath, tenantId.value));
//         }
//     }

//     override bool exists(TenantId tenantId, TId id) {
//         if (existsTenant(tenantId)) {
//             return buildPath(rootPath, tenantId.value, id.value ~ ".json").exists;
//         }
//         return false;
//     }

//     override TEntity find(TenantId tenantId, TId id) {
//         if (existsTenant(tenantId)) {
//             string filePath = buildPath(rootPath, tenantId.value, id.value ~ ".json");
//             if (filePath.exists) {
//                 auto content = parseJsonString(readText(filePath));
//                 TEntity entity = createEntity(tenantId);
//                 entity.fromJson(content);
//                 return entity;
//             }
//         }
//         return TEntity.init;
//     }

//     override void save(TEntity entity) {
//         auto tId = entity.tenantId;
//         if (!existsTenant(tId))
//             createTenant(tId);

//         string filePath = buildPath(rootPath, tId.value, entity.id.value ~ ".json");
//         std.file.write(filePath, entity.toJson().toString);
//     }

//     override void remove(TEntity entity) {
//         string filePath = buildPath(rootPath, entity.tenantId.value, entity.id.value ~ ".json");
//         if (filePath.exists) {
//             filePath.remove;
//         }
//     }
}

// unittest {
//     // Setup mock types for testing
//     struct MockId {
//           mixin(IdTemplate);

//     }

//     struct MockEntity {
//         mixin TenantEntity!MockId;
//         string name;

//         Json toJson() const {
//             return entityToJson()
//                 .set("name", name);
//         }

//         void fromJson(Json src) {
//             entityFromJson(src);
//             name = src.getString("name");
//         }
//     }

//     // auto testPath = buildPath(tempDir(), "uim_test_store");
//     auto store = new FileTenantStore!(MockEntity, MockId)();
//     // store.rootPath = testPath;

//     // Ensure clean state
//     // if (testPath.exists)
//     //     rmdirRecurse(testPath);
//     // scope (exit)
//     //     if (testPath.exists)
//     //         rmdirRecurse(testPath);

//     auto tId = TenantId("test-tenant");
//     auto entity = MockEntity(tId);
//     entity.name = "Test Entity";

//     // 1. Test Tenant Operations
//     assert(!store.existsTenant(tId));
//     store.createTenant(tId);
//     assert(store.existsTenant(tId));

//     // 2. Test Entity Persistence
//     assert(!store.existsEntity(tId, entity.id));
//     store.saveEntity(entity);
//     assert(store.existsEntity(tId, entity.id));

//     writeln("Entity JSON: ", store.readEntity(tId, entity.id).toJson());
//     auto readEntity = store.readEntity(tId, entity.id);
//     writeln("ReadEntity JSON: ", readEntity.toJson());

//     // 3. Test Entity Deletion
//     store.remove(entity);
//     assert(!store.existsEntity(tId, entity.id));

//     // 4. Test Tenant Removal
//     store.remove(tId);
//     assert(!store.existsTenant(tId));
// }
