/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module entities.examples.example_uda;

import uim.entities;
import std.stdio;
import std.algorithm : canFind;

/**
 * Example User entity using UDAs for validation and mapping
 */
@UseEntity("users")
class User : DAnnotateUIMEntity {
    @EntityAttribute("username")
    @Required
    @MaxLength(50)
    @MinLength(3)
    string username;
    
    @EntityAttribute("email")
    @Required
    @Pattern(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
    string email;
    
    @EntityAttribute("password")
    @Required
    @MinLength(8)
    string password;
    
    @EntityAttribute("age")
    @Range(13, 120)
    int age;
    
    @EntityAttribute("user_id")
    @ReadOnly
    string userId;
    
    this() {
        super();
        userId = this.id().toString();
    }
}

/**
 * Example Product entity
 */
@UseEntity("products")
class Product : DAnnotateUIMEntity {
    @EntityAttribute("name")
    @Required
    @MaxLength(200)
    string name;
    
    @EntityAttribute("description")
    @MaxLength(1000)
    string description;
    
    @EntityAttribute("price")
    @Range(0, 1_000_000)
    double price;
    
    @EntityAttribute("sku")
    @Required
    @UniqueField
    @ReadOnly
    string sku;
    
    @EntityAttribute("in_stock")
    int stockCount;
    
    this() {
        super();
    }
    
    this(string productName, string productSku) {
        this();
        this.name = productName;
        this.sku = productSku;
    }
}

/**
 * Example Order entity with nested validation
 */
@UseEntity("orders")
class Order : DAnnotateUIMEntity {
    @EntityAttribute("order_number")
    @Required
    @Pattern(r"^ORD-\d{6}$")
    string orderNumber;
    
    @EntityAttribute("customer_name")
    @Required
    @MaxLength(100)
    string customerName;
    
    @EntityAttribute("total_amount")
    @Range(0, 100_000)
    double totalAmount;
    
    @EntityAttribute("status")
    @Required
    string status;
    
    this() {
        super();
        status = "pending";
    }
}

void main() {
    mixin(ShowTest!"=== UIM Entities Library - UDA Example ===\n");
    
    writeln("1. Creating User entity with UDA validation:");
    auto user = new User();
    
    // Test validation - should fail
    writeln("   Testing empty user (should fail):");
    auto errors = user.validate();
    writeln("   Validation errors: ", errors.length);
    foreach (error; errors) {
        writeln("     ❌ ", error);
    }
    assert(!user.isValid());
    writeln();
    
    // Set valid data
    writeln("   Setting valid user data:");
    user.username = "john_doe";
    user.email = "john@example.com";
    user.password = "SecurePass123";
    user.age = 25;
    
    errors = user.validate();
    writeln("   Validation errors: ", errors.length);
    assert(user.isValid());
    writeln("   ✓ User is valid!");
    writeln();
    
    // Test invalid email
    writeln("2. Testing invalid email pattern:");
    user.email = "not-an-email";
    errors = user.validate();
    writeln("   Validation errors: ", errors.length);
    foreach (error; errors) {
        writeln("     ❌ ", error);
    }
    assert(!user.isValid());
    user.email = "john@example.com"; // Reset
    writeln();
    
    // Test max length validation
    writeln("3. Testing MaxLength validation:");
    import std.array : replicate;
    user.username = "a".replicate(51);
    errors = user.validate();
    writeln("   Username length: ", user.username.length);
    writeln("   Validation errors: ", errors.length);
    assert(!user.isValid());
    assert(errors.canFind!(e => e.canFind("maximum length")));
    writeln("   ✓ MaxLength validation works!");
    user.username = "john_doe"; // Reset
    writeln();
    
    // Test range validation
    writeln("4. Testing Range validation:");
    user.age = 150;
    errors = user.validate();
    writeln("   Age: ", user.age);
    writeln("   Validation errors: ", errors.length);
    assert(!user.isValid());
    assert(errors.canFind!(e => e.canFind("between")));
    writeln("   ✓ Range validation works!");
    user.age = 25; // Reset
    writeln();
    
    // Test entity to AA mapping
    writeln("5. Testing entity to associative array mapping:");
    auto userMap = user.toAA();
    writeln("   Mapped fields:");
    foreach (key, value; userMap) {
        writeln("     ", key, " => ", value);
    }
    assert("username" in userMap);
    assert(userMap["username"] == "john_doe");
    assert(userMap["email"] == "john@example.com");
    writeln("   ✓ Mapping to AA works!");
    writeln();
    
    // Test entity from AA
    writeln("6. Testing entity from associative array:");
    auto newUser = new User();
    newUser.fromAA([
        "username": "jane_smith",
        "email": "jane@example.com",
        "password": "AnotherPass456",
        "age": "30",
        "user_id": "THIS-SHOULD-NOT-BE-SET" // ReadOnly
    ]);
    writeln("   New user username: ", newUser.username);
    writeln("   New user email: ", newUser.email);
    writeln("   New user age: ", newUser.age);
    writeln("   User ID (ReadOnly): ", newUser.userId);
    assert(newUser.username == "jane_smith");
    assert(newUser.age == 30);
    assert(newUser.userId != "THIS-SHOULD-NOT-BE-SET");
    writeln("   ✓ Mapping from AA works (ReadOnly fields protected)!");
    writeln();
    
    // Test Product entity
    writeln("7. Testing Product entity:");
    auto product = new Product("Laptop", "LAP-001");
    product.description = "High-performance laptop";
    product.price = 1299.99;
    product.stockCount = 50;
    
    errors = product.validate();
    writeln("   Product validation errors: ", errors.length);
    assert(product.isValid());
    writeln("   ✓ Product is valid!");
    
    auto productMap = product.toAA();
    writeln("   Product fields:");
    foreach (key, value; productMap) {
        writeln("     ", key, " => ", value);
    }
    writeln();
    
    // Test Order entity with pattern
    writeln("8. Testing Order entity with pattern validation:");
    auto order = new Order();
    order.orderNumber = "ORD-123456";
    order.customerName = "John Doe";
    order.totalAmount = 1500.00;
    
    errors = order.validate();
    writeln("   Order validation errors: ", errors.length);
    assert(order.isValid());
    writeln("   ✓ Order with valid pattern is valid!");
    
    // Test invalid pattern
    order.orderNumber = "INVALID-123";
    errors = order.validate();
    writeln("   Invalid order number: ", order.orderNumber);
    writeln("   Validation errors: ", errors.length);
    assert(!order.isValid());
    writeln("   ✓ Pattern validation works!");
    writeln();
    
    // Test entity table name from UDA
    writeln("9. Testing @UseEntity table name:");
    writeln("   User table: ", getEntityTableName!User);
    writeln("   Product table: ", getEntityTableName!Product);
    writeln("   Order table: ", getEntityTableName!Order);
    assert(getEntityTableName!User == "users");
    assert(getEntityTableName!Product == "products");
    assert(getEntityTableName!Order == "orders");
    writeln("   ✓ Table names from UDA work!");
    writeln();
    
    // Test entity state management
    writeln("10. Testing entity state management:");
    auto testUser = new User();
    testUser.username = "test_user";
    testUser.email = "test@example.com";
    testUser.password = "TestPass123";
    
    writeln("   Initial state: ", testUser.state());
    assert(testUser.isNew());
    
    testUser.markClean();
    writeln("   After markClean: ", testUser.state());
    assert(testUser.isClean());
    
    testUser.username = "updated_user";
    testUser.markDirty();
    writeln("   After modification: ", testUser.state());
    assert(testUser.isDirty());
    
    testUser.markDeleted();
    writeln("   After markDeleted: ", testUser.state());
    assert(testUser.isDeleted());
    writeln("   ✓ State management works!");
    writeln();
    
    writeln("=== UDA Example completed successfully! ===");
}
