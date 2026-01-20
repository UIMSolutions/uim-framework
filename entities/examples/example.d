/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module entities.examples.example;

import uim.entities;
import uim.events;
import std.stdio;
import std.uuid;

void main() {
    writeln("=== UIM Entities Library Example ===\n");
    
    // 1. Basic Entity Usage
    writeln("1. Creating and managing entities:");
    auto user = Entity("John Doe");
    user.setAttribute("email", "john@example.com");
    user.setAttribute("role", "admin");
    
    writeln("   Entity ID: ", user.id());
    writeln("   Entity Name: ", user.name());
    writeln("   Email: ", user.getAttribute("email"));
    writeln("   Is New: ", user.isNew());
    writeln();
    
    // 2. Entity Collection
    writeln("2. Working with entity collections:");
    auto collection = EntityCollection();
    
    auto user1 = Entity("Alice");
    user1.setAttribute("department", "Engineering");
    
    auto user2 = Entity("Bob");
    user2.setAttribute("department", "Marketing");
    
    auto user3 = Entity("Charlie");
    user3.setAttribute("department", "Engineering");
    
    collection.add(user1);
    collection.add(user2);
    collection.add(user3);
    
    writeln("   Collection count: ", collection.count());
    
    auto engineeringUsers = collection.findByAttribute("department", "Engineering");
    writeln("   Engineering users: ", engineeringUsers.length);
    foreach (u; engineeringUsers) {
        writeln("      - ", u.name());
    }
    writeln();
    
    // 3. Repository Pattern
    writeln("3. Using repository for CRUD operations:");
    auto repository = EntityRepository();
    
    auto product = Entity("Laptop");
    product.setAttribute("price", "999");
    product.setAttribute("category", "Electronics");
    
    repository.save(product);
    writeln("   Saved product: ", product.name());
    writeln("   Product state: ", product.state());
    
    // Find and update
    auto found = repository.find(product.id());
    found.setAttribute("price", "899");
    repository.save(found);
    writeln("   Updated price to: ", found.getAttribute("price"));
    writeln();
    
    // 4. Validation
    writeln("4. Entity validation:");
    auto validator = EntityValidator();
    validator.addRule("username", new RequiredRule());
    validator.addRule("username", new MinLengthRule(3));
    validator.addRule("username", new MaxLengthRule(20));
    validator.addRule("email", new RequiredRule());
    validator.addRule("email", new PatternRule(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"));
    
    // Valid entity
    auto validUser = Entity("ValidUser");
    validUser.setAttribute("username", "john_doe");
    validUser.setAttribute("email", "john@example.com");
    
    if (validator.validate(validUser)) {
        writeln("   ✓ Valid user passed validation");
    }
    
    // Invalid entity
    auto invalidUser = Entity("InvalidUser");
    invalidUser.setAttribute("username", "ab"); // Too short
    invalidUser.setAttribute("email", "invalid-email");
    
    if (!validator.validate(invalidUser)) {
        writeln("   ✗ Invalid user failed validation:");
        foreach (error; invalidUser.errors()) {
            writeln("      - ", error);
        }
    }
    writeln();
    
    // 5. Entity Manager with Events
    writeln("5. Entity manager with lifecycle events:");
    auto manager = EntityManager();
    manager.validator(validator);
    
    // Subscribe to events
    manager.eventDispatcher().on("entity.beforeCreate", (IEvent event) @trusted {
        writeln("   🔔 Event: Before creating entity");
    });
    
    manager.eventDispatcher().on("entity.afterCreate", (IEvent event) @trusted {
        auto createEvent = cast(EntityAfterCreateEvent)event;
        writeln("   🔔 Event: After creating entity '", createEvent.entity.name(), "'");
    });
    
    manager.eventDispatcher().on("entity.beforeUpdate", (IEvent event) @trusted {
        writeln("   🔔 Event: Before updating entity");
    });
    
    manager.eventDispatcher().on("entity.afterUpdate", (IEvent event) @trusted {
        writeln("   🔔 Event: After updating entity");
    });
    
    manager.eventDispatcher().on("entity.validated", (IEvent event) @trusted {
        auto validEvent = cast(EntityValidatedEvent)event;
        writeln("   🔔 Event: Entity validated - Valid: ", validEvent.isValid);
    });
    
    // Create entity with events
    auto managedUser = Entity("ManagedUser");
    managedUser.setAttribute("username", "alice");
    managedUser.setAttribute("email", "alice@example.com");
    manager.create(managedUser);
    writeln();
    
    // Update entity with events
    managedUser.setAttribute("email", "alice.updated@example.com");
    manager.update(managedUser);
    writeln();
    
    // 6. Entity State Management
    writeln("6. Entity state management:");
    auto stateEntity = Entity("StateDemo");
    writeln("   Initial state: ", stateEntity.state());
    
    stateEntity.markClean();
    writeln("   After markClean: ", stateEntity.state());
    
    stateEntity.setAttribute("changed", "yes");
    writeln("   After modification: ", stateEntity.state());
    
    stateEntity.markDeleted();
    writeln("   After markDeleted: ", stateEntity.state());
    writeln();
    
    // 7. Custom Entity with UDAs
    writeln("7. Custom entity with validation UDAs:");
    
    @Entity("users")
    class User : DEntity {
        @Required
        @MaxLength(50)
        string username;
        
        @Required
        @Pattern(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
        string email;
        
        this(string name) {
            super();
            this.name(name);
        }
    }
    
    writeln("   Created custom User entity class with UDA validation");
    writeln();
    
    // 8. JSON Serialization
    writeln("8. Entity serialization:");
    auto serializableEntity = Entity("SerializableEntity");
    serializableEntity.setAttribute("field1", "value1");
    serializableEntity.setAttribute("field2", "value2");
    
    writeln("   JSON representation:");
    writeln("   ", serializableEntity.toJson());
    writeln();
    
    writeln("=== Example completed successfully! ===");
}
