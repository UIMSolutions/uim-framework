module uim.services.infrastructure.persistence.stores.file;

import uim.services;

mixin(ShowModule!());

@safe:

class FileStore(TEntity, TId) : IStore {
    protected string path;

    this() {
        this.initialize();
    }

    this(string path) {
        this.initialize(Json.emptyObject
            .set("path", "./data/test_store"));
    }

    this(Json initData) {
        this.initialize(initData);
    }

    bool initialize(Json initData = Json(null)) {
        if (initData.isNull)
            return false;

        this.path = initData.getString("path");
        path.mkdirRecurse;
        return true;
    }

    bool exists(TEntity entity) {
        return std.file.exists(buildPath(this.path, entity.id.value));
    }

    bool exists(TId id) {
        return std.file.exists(buildPath(this.path, id.value));
    }

    size_t count() {
        size_t findings;
        (() @trusted {
            findings = dirEntries(this.path, SpanMode.shallow).filter!(f => f.isFile)
                .array.length;
        })();

        return findings;
    }

    size_t count(bool delegate(TEntity) @safe predicate) {
        return this.entities().filter!((TEntity e) => predicate(e)).array.length;
    }

    TEntity entity(string data) {
        writeln("text -> ", data);
        Json jsonObject = parseJsonString(data);
        writeln("json -> ", jsonObject.toString);
        return deserializeJson!(TEntity)(jsonObject);
    }

    TEntity entity(TId id) {
        string fileName = buildPath(this.path, id.value);
        if (!std.file.exists(fileName))
            return TEntity.init;

        writeln("text -> ", readText(fileName));
        Json jsonObject = parseJsonString(readText(fileName));
        writeln("json -> ", jsonObject.toString);
        return deserializeJson!TEntity(jsonObject);
    }

    TEntity[] entities() {
        TEntity[] findings;
        (() @trusted {
            findings = dirEntries(this.path, SpanMode.shallow).filter!(f => f.isFile)
                .map!(f => entity(readText(f.name)))
                .array;
        })();

        return findings;
    }

    TEntity[] entities(bool delegate(TEntity) @safe predicate) {
        return this.entities().filter!((TEntity e) => predicate(e)).array;
    }

    StoreResult update(TEntity entity) {
        if (!this.exists(entity))
            return StoreResult(false, "Entity does not exist.");

        Json jsonObject = serializeToJson(entity);
        string fileName = buildPath(this.path, entity.id.value);

        // std.file.write speichert den String direkt in die Datei
        std.file.write(fileName, jsonObject.toPrettyString());
        return StoreResult(true, "Entity updated successfully.");
    }

    StoreResult save(TEntity entity) {
        if (this.exists(entity))
            return StoreResult(false, "Entity already exists.");

        Json jsonObject = serializeToJson(entity);
        string fileName = buildPath(this.path, entity.id.value);

        // std.file.write speichert den String direkt in die Datei
        std.file.write(fileName, jsonObject.toPrettyString());
        return StoreResult(true, "Entity saved successfully.");
    }

    StoreResult remove(TEntity entity) {
        if (!this.exists(entity))
            return StoreResult(false, "Entity does not exist.");

        string fileName = buildPath(this.path, entity.id.value);
        if (std.file.exists(fileName))
            std.file.remove(fileName);
        return StoreResult(true, "Entity removed successfully.");
    }

    StoreResult removeById(TId id) {
        if (!this.exists(id))
            return StoreResult(false, "Entity does not exist.");

        string fileName = buildPath(this.path, id.value);
        if (std.file.exists(fileName))
            std.file.remove(fileName);
        return StoreResult(true, "Entity removed successfully.");
    }
}

struct TestId {
    string value;
    
    Json toJson() const {
        return Json(value);
    }

    static TestId fromJson(Json json) {
        return TestId(json.get!string);
    }
}

struct TestEntity {
    TestId id;
    string name;
}

unittest {

    auto store = new FileStore!(TestEntity, TestId)();
    assert(store.initialize(Json.emptyObject
            .set("path", "./data/test_store")));

    auto entity1 = TestEntity(TestId("1"), "Entity 1");
    auto entity2 = TestEntity(TestId("2"), "Entity 2");

    // testStore(store, [entity1, entity2]);
    assert(store.count == 0);
}
