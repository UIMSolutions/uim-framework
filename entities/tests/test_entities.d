/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module entities.tests.test_entities;

import uim.entities;
import uim.events;
import std.stdio;
import std.uuid;

void testEntityCreation() {
    writeln("Testing entity creation...");
    
    auto entity = Entity("Test");
    assert(entity.name() == "Test");
    assert(entity.isNew());
    assert(!entity.isDirty());
    
    writeln("✓ Entity creation test passed");
}

void testEntityAttributes() {
    writeln("Testing entity attributes...");
    
    auto entity = Entity("Test");
    entity.setAttribute("key1", "value1");
    entity.setAttribute("key2", "value2");
    
    assert(entity.hasAttribute("key1"));
    assert(entity.getAttribute("key1") == "value1");
    assert(entity.getAttribute("key2") == "value2");
    assert(entity.getAttribute("nonexistent", "default") == "default");
    
    entity.removeAttribute("key1");
    assert(!entity.hasAttribute("key1"));
    
    writeln("✓ Entity attributes test passed");
}

void testEntityState() {
    writeln("Testing entity state...");
    
    auto entity = Entity("Test");
    assert(entity.isNew());
    
    entity.markClean();
    assert(entity.isClean());
    
    entity.setAttribute("changed", "yes");
    assert(entity.isDirty());
    
    entity.markDeleted();
    assert(entity.isDeleted());
    
    writeln("✓ Entity state test passed");
}

void testEntityValidation() {
    writeln("Testing entity validation...");
    
    auto entity = Entity("Test");
    assert(entity.isValid());
    
    entity.addError("Test error");
    assert(!entity.isValid());
    assert(entity.errors().length == 1);
    
    entity.clearErrors();
    assert(entity.isValid());
    assert(entity.errors().length == 0);
    
    writeln("✓ Entity validation test passed");
}

void testEntityCollection() {
    writeln("Testing entity collection...");
    
    auto collection = EntityCollection();
    assert(collection.isEmpty());
    
    auto entity1 = Entity("Entity1");
    auto entity2 = Entity("Entity2");
    
    collection.add(entity1);
    collection.add(entity2);
    
    assert(collection.count() == 2);
    assert(!collection.isEmpty());
    assert(collection.contains(entity1));
    
    auto retrieved = collection.get(entity1.id());
    assert(retrieved !is null);
    assert(retrieved.name() == "Entity1");
    
    collection.remove(entity1);
    assert(collection.count() == 1);
    
    writeln("✓ Entity collection test passed");
}

void testEntityCollectionQuery() {
    writeln("Testing entity collection queries...");
    
    auto collection = EntityCollection();
    
    auto entity1 = Entity("User1");
    entity1.setAttribute("role", "admin");
    entity1.markClean();
    
    auto entity2 = Entity("User2");
    entity2.setAttribute("role", "user");
    entity2.markClean();
    
    auto entity3 = Entity("User3");
    entity3.setAttribute("role", "admin");
    entity3.setAttribute("changed", "yes");
    
    collection.add(entity1);
    collection.add(entity2);
    collection.add(entity3);
    
    auto admins = collection.findByAttribute("role", "admin");
    assert(admins.length == 2);
    
    auto cleanEntities = collection.getClean();
    assert(cleanEntities.length == 2);
    
    auto dirtyEntities = collection.getDirty();
    assert(dirtyEntities.length == 1);
    
    writeln("✓ Entity collection query test passed");
}

void testEntityRepository() {
    writeln("Testing entity repository...");
    
    auto repository = EntityRepository();
    
    auto entity = Entity("TestEntity");
    entity.setAttribute("data", "test");
    
    repository.save(entity);
    assert(entity.isClean());
    assert(repository.count() == 1);
    
    auto found = repository.find(entity.id());
    assert(found !is null);
    assert(found.name() == "TestEntity");
    
    found.setAttribute("updated", "yes");
    repository.save(found);
    assert(found.isClean());
    
    repository.remove(found);
    assert(repository.count() == 0);
    
    writeln("✓ Entity repository test passed");
}

void testEntityValidator() {
    writeln("Testing entity validator...");
    
    auto validator = EntityValidator();
    validator.addRule("username", new RequiredRule());
    validator.addRule("username", new MinLengthRule(3));
    
    // Valid entity
    auto validEntity = Entity("Valid");
    validEntity.setAttribute("username", "john_doe");
    
    assert(validator.validate(validEntity));
    assert(validEntity.isValid());
    
    // Invalid entity (empty)
    auto invalidEntity1 = Entity("Invalid1");
    invalidEntity1.setAttribute("username", "");
    
    assert(!validator.validate(invalidEntity1));
    assert(!invalidEntity1.isValid());
    
    // Invalid entity (too short)
    auto invalidEntity2 = Entity("Invalid2");
    invalidEntity2.setAttribute("username", "ab");
    
    assert(!validator.validate(invalidEntity2));
    assert(!invalidEntity2.isValid());
    
    writeln("✓ Entity validator test passed");
}

void testEntityManager() {
    writeln("Testing entity manager...");
    
    auto manager = EntityManager();
    
    bool beforeCreateCalled = false;
    bool afterCreateCalled = false;
    
    manager.eventDispatcher().on("entity.beforeCreate", (IEvent event) @trusted {
        beforeCreateCalled = true;
    });
    
    manager.eventDispatcher().on("entity.afterCreate", (IEvent event) @trusted {
        afterCreateCalled = true;
    });
    
    auto entity = Entity("ManagedEntity");
    manager.create(entity);
    
    assert(beforeCreateCalled);
    assert(afterCreateCalled);
    assert(entity.isClean());
    
    writeln("✓ Entity manager test passed");
}

void testEntityManagerWithValidation() {
    writeln("Testing entity manager with validation...");
    
    auto manager = EntityManager();
    
    auto validator = EntityValidator();
    validator.addRule("username", new RequiredRule());
    manager.validator(validator);
    
    bool validatedCalled = false;
    manager.eventDispatcher().on("entity.validated", (IEvent event) @trusted {
        validatedCalled = true;
    });
    
    // Valid entity
    auto validEntity = Entity("Valid");
    validEntity.setAttribute("username", "john");
    manager.create(validEntity);
    
    assert(validatedCalled);
    assert(validEntity.isClean());
    
    // Invalid entity
    auto invalidEntity = Entity("Invalid");
    invalidEntity.setAttribute("username", "");
    manager.create(invalidEntity);
    
    assert(invalidEntity.isNew()); // Should not be saved
    assert(!invalidEntity.isValid());
    
    writeln("✓ Entity manager with validation test passed");
}

void testEntitySerialization() {
    writeln("Testing entity serialization...");
    
    auto entity = Entity("Serializable");
    entity.setAttribute("field1", "value1");
    entity.setAttribute("field2", "value2");
    
    auto json = entity.toJson();
    assert(json.length > 0);
    
    auto aa = entity.toAA();
    assert(aa["name"] == "Serializable");
    assert("field1" in aa);
    
    writeln("✓ Entity serialization test passed");
}

void main() {
    writeln("=== Running UIM Entities Tests ===\n");
    
    testEntityCreation();
    testEntityAttributes();
    testEntityState();
    testEntityValidation();
    testEntityCollection();
    testEntityCollectionQuery();
    testEntityRepository();
    testEntityValidator();
    testEntityManager();
    testEntityManagerWithValidation();
    testEntitySerialization();
    
    writeln("\n=== All tests passed! ===");
}
