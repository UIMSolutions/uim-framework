module uim.services.domain.mixins.id;

import uim.services;

mixin(ShowModule!());

@safe:

mixin template IdTemplate(TId) {
    string value;

    this(string value) {
        this.value = value;
    }

    void opAssign(UUID newValue) {
        this.value = newValue.toString();
    }

    void opAssign(string newValue) {
        this.value = newValue;
    }

    bool isNull() const {
        return this.value.length == 0;
    }

    bool isEmpty() const {
        return this.value.length == 0;
    }

    string toString() const {
        return this.value;
    }

    Json toJson() const {
        return Json(this.value);
    }

    static TId fromJson(Json json) {
        return TId(json.get!string);
    }
}

///
unittest {
    // mixin(ShowTest!"Testing IdDefinition mixin...");
    // // writeln("IdDefinition for 'Test':");
    // struct TestId {
    //     mixin IdTemplate!TestId;
    // }

    // auto id = TestId("test-id");
    // assert(id.toString() == "test-id");
    // assert(!id.isNull());
    // assert(!id.isEmpty());
    // assert(id.toJson().getString() == "test-id");

    // TestId id2 = "test-id";
    // assert(id2.toString() == "test-id");
    // assert(!id2.isNull());
    // assert(!id2.isEmpty());
    // // assert(id2 == "test-id");
    // assert(id2.toJson().getString() == "test-id");

    // id = UUID("12345678-1234-5678-1234-567812345678");
    // assert(id.toString() == "12345678-1234-5678-1234-567812345678");
    // // assert(id == UUID("12345678-1234-5678-1234-567812345678"));

    // id = "";
    // assert(id.isNull());
    // assert(id.isEmpty());
}
