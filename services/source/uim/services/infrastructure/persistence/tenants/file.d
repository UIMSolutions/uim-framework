module uim.services.infrastructure.persistence.tenants.file;

import uim.services;

mixin(ShowModule!());

@safe:

// import std.stdio;

// // 1. Gemeinsames Interface für alle Stores
// interface IStore {
//     // Hier kannst du typ-unabhängige Methoden definieren, falls nötig
//     // z. B. void clear(); oder string getName();
// }

// // 2. Deine generische Store-Klasse implementiert IStore
// class Store(A, B) : IStore {
//     void printInfo() {
//         writeln("Store für Typen: ", A.stringof, " und ", B.stringof);
//     }
// }

// // 3. Der Tenant, der beliebige Stores verwaltet
// class Tenant {
//     private IStore[string] _stores;

//     // Store unter einem Namen registrieren
//     void registerStore(string name, IStore store) {
//         _stores[name] = store;
//     }

//     // Generischer Zugriff: Wandelt den IStore in den konkreten Store!(A, B) um
//     Store!(A, B) getStore(A, B)(string name) {
//         if (auto ptr = name in _stores) {
//             // Downcast zum konkreten Typ
//             auto typedStore = cast(Store!(A, B)) *ptr;
//             if (typedStore !is null) {
//                 return typedStore;
//             }
//             throw new Exception("Store '" ~ name ~ "' hat nicht die erwarteten Typen!");
//         }
//         return null;
//     }
// }

// class FileTenant(TEntity, TId) : IStore!(TEntity, TId) {
//     protected string _path;
//     protected IStore[TenantId] _stores;

//     this() {
//         this.initialize();
//     }

//     this(Json initData) {
//         this.initialize(initData);
//     }

//     bool initialize(Json initData = Json(null)) {
//         if (initData.isNull)
//             return false;

//         _path = initData.getString("path");
//         _path.mkdirRecurse;

//         initData.getArray("stores").map!getString
//             .each!(name => buildPath(path, name).mkdirRecurse)
//             .each!(name => addStore(name));

//         return true;
//     }


//     // #region exists
//     bool exists(TEntity entity) {
//         return exists(entity.tenentId);
//     }

//     bool exists(TenantId id) {
//         return (id in _stores) ? true : false;
//     }

//     bool exists(TenantId tenantId, TId id) {
//         return exists(tenantId) ? store(tenantId).exists(id) : false;
//     }
//     // #endregion exists

//     // #region count
//     size_t count(string id) {
//         return exists(id) ? store(id).count() : 0;
//     }

//     size_t count(TenantId id) {
//         return exists(id) ? store(id).count() : 0;
//     }
//     // #endregion count

//     // #region store
//     auto store(string id) {
//         return exists(id) ? store(TenantId(id)) : null;
//     }

//     auto store(TenantId id) {
//         return exists(id) ? store(id) : null;
//     }

//     void store(string id, IStore store) {
//         store(TenantId(id), store);
//     }

//     void store(TenantId id, IStore store) {
//         _stores[id] = store;
//     }
//     // #endregion store

//     TEntity entity(string tenantId, string id) {
//         if (!exists(tenantId)) return TEntity.init;
//         return store(tenantId).entity(id);
//     }

//     TEntity entity(TenantId tenantId, string id) {
//         if (!exists(tenantId)) return TEntity.init;
//         return store(tenantId).entity(id);
//     }

//     TEntity entity(string tenantId, TId id) {
//         if (!exists(tenantId)) return TEntity.init;
//         return store(tenantId).entity(id);
//     }

//     TEntity entity(TenantId tenantId, TId id) {
//         if (!exists(tenantId)) return TEntity.init;
//         return store(tenantId).entity(id);
//     }

//     TEntity[] entities() {
//         return _stores.byValue.map!(s => s.entities).chain.array;
//     }

    //             TEntity[] entities(bool delegate(TEntity)@safe predicate) {
    //                 return this.entities().filter!((TEntity e) => predicate(e)).array;
    //             }

    //             StoreResult update(TEntity entity) {
    //                 if (!this.exists(entity))
    //                     return StoreResult(false, "Entity does not exist.");

    //                         Json jsonObject = serializeToJson(entity);
    //                         string fileName = buildPath(this.path, entity.id.value);

    //                         // std.file.write speichert den String direkt in die Datei
    //                         std.file.write(fileName, jsonObject.toPrettyString());
    //                         return StoreResult(true, "Entity updated successfully.");
    //             }

    //             StoreResult save(TEntity entity) {
    //                 if (this.exists(entity))
    //                     return StoreResult(false, "Entity already exists.");

    //                         Json jsonObject = serializeToJson(entity);
    //                         string fileName = buildPath(this.path, entity.id.value);

    //                         // std.file.write speichert den String direkt in die Datei
    //                         std.file.write(fileName, jsonObject.toPrettyString());
    //                         return StoreResult(true, "Entity saved successfully.");
    //             }

    //             StoreResult remove(TEntity entity) {
    //                 if (!this.exists(entity))
    //                     return StoreResult(false, "Entity does not exist.");

    //                         string fileName = buildPath(this.path, entity.id.value);
    //                         if (std.file.exists(fileName)) std.file.remove(fileName);
    //                         return StoreResult(true, "Entity removed successfully.");
    //             }

    //             StoreResult removeById(TId id) {
    //                 if (!this.exists(id))
    //                     return StoreResult(false, "Entity does not exist.");

    //                         string fileName = buildPath(this.path, id.value);
    //                         if (std.file.exists(fileName)) std.file.remove(fileName);
    //                         return StoreResult(true, "Entity removed successfully.");
    //             }
    //         }

    //         struct TestId {
    //             string value; Json toJson()const {
    //                 return Json(value); }

    //                 static TestId fromJson(Json json) {
    //                     return TestId(json.get!string); }
    //                 }

    //                 struct TestEntity {
    //                     TestId id; string name; }

    //                     unittest {

    //                         auto store = new FileStore!(TestEntity, TestId)();
    //                             assert(store.initialize(Json.emptyObject
    //                                 .set("path", "./data/test_store")));

    //                             auto entity1 = TestEntity(TestId("1"), "Entity 1");
    //                             auto entity2 = TestEntity(TestId("2"), "Entity 2");

    //                             testStore(store, [entity1, entity2]);
    //                             assert(store.count == 0); store.save(entity1);
    //                             assert(entity1.id.value == store.entity(entity1.id)
    //                                 .id.value); 
// }
// ///
// unittest {

// }