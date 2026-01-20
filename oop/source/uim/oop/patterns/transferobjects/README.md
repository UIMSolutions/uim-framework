# Transfer Object Pattern

## Overview

The Transfer Object Pattern (also known as Data Transfer Object or DTO) is a design pattern used to transfer data between software application subsystems. Transfer Objects are simple objects that should not contain any business logic, only storage, accessors, and serialization/deserialization methods.

## Purpose

The Transfer Object pattern:
- Reduces the number of remote calls by aggregating data
- Encapsulates serialization mechanisms for transferring data
- Provides a simple data structure optimized for network transfer
- Decouples presentation layer from business logic
- Simplifies data exchange between layers or services
- Improves performance by reducing network overhead

## Structure

```
┌─────────────────────────────────────────────────────────────────┐
│                    Transfer Object Pattern                      │
│                                                                 │
│  ┌──────────┐         ┌──────────────┐         ┌──────────┐   │
│  │  Client  │────────>│ Transfer     │<────────│ Business │   │
│  │  Layer   │         │ Object (DTO) │         │  Object  │   │
│  └──────────┘         └──────────────┘         └──────────┘   │
│                              △                        △         │
│                              │                        │         │
│                       ┌──────┴──────┐         ┌──────┴──────┐ │
│                       │ Assembler   │────────>│  Domain     │ │
│                       │             │         │  Model      │ │
│                       └─────────────┘         └─────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

## Components

### Interfaces

#### `ITransferObject`
Base interface for all transfer objects.
- `validate()` - Validate the data
- `toMap()` - Convert to associative array
- `fromMap(data)` - Populate from associative array

#### `ISerializableTransferObject`
Extension for JSON serialization support.
- `toJson()` - Serialize to JSON string
- `fromJson(json)` - Deserialize from JSON string

#### `ITransferObjectAssembler`
Converts between domain and transfer objects.
- `toTransferObject(domain)` - Convert domain to TO
- `toDomainObject(transfer)` - Convert TO to domain
- `toTransferObjects(domains[])` - Batch conversion
- `toDomainObjects(transfers[])` - Batch conversion

#### `ICompositeTransferObject`
For nested transfer objects.
- `getChildren()` - Get nested TOs
- `addChild(child)` - Add nested TO

### Implementations

#### `TransferObject`
Abstract base class for transfer objects.
- Provides common functionality
- Requires implementation of toMap/fromMap

#### `SerializableTransferObject`
Transfer object with JSON support.
- Automatic JSON serialization
- Handles JSON parsing

#### `TransferObjectAssembler`
Base assembler for conversions.
- Template-based type safety
- Batch conversion support

#### `CompositeTransferObject`
For hierarchical data structures.
- Manages child transfer objects
- Validates entire tree

#### `ImmutableTransferObject`
For read-only data transfer.
- One-time initialization
- Thread-safe by design

## Usage Examples

### Basic Transfer Object

```d
class UserTO : TransferObject {
    string username;
    string email;
    int age;

    override string[string] toMap() {
        import std.conv : to;
        string[string] map;
        map["username"] = username;
        map["email"] = email;
        map["age"] = age.to!string;
        return map;
    }

    override void fromMap(string[string] data) {
        import std.conv : to;
        username = data.get("username", "");
        email = data.get("email", "");
        age = data.get("age", "0").to!int;
    }

    override bool validate() {
        return username.length > 0 && email.length > 0 && age >= 0;
    }
}

// Usage
auto user = new UserTO();
user.username = "john_doe";
user.email = "john@example.com";
user.age = 30;

if (user.validate()) {
    auto map = user.toMap();
    // Transfer map over network or between layers
}
```

### Serializable Transfer Object

```d
class ProductTO : SerializableTransferObject {
    string name;
    string price;

    override string[string] toMap() {
        string[string] map;
        map["name"] = name;
        map["price"] = price;
        return map;
    }

    override void fromMap(string[string] data) {
        name = data.get("name", "");
        price = data.get("price", "0");
    }
}

// Serialize to JSON
auto product = new ProductTO();
product.name = "Laptop";
product.price = "999.99";

string json = product.toJson();
// Send JSON to API

// Deserialize from JSON
auto receivedProduct = new ProductTO();
receivedProduct.fromJson(json);
```

### Composite Transfer Object

```d
class OrderItemTO : TransferObject {
    string productName;
    int quantity;
    // ... implementation
}

class OrderTO : CompositeTransferObject {
    string orderId;
    string customerName;
    
    // ... implementation
}

// Build composite structure
auto order = new OrderTO();
order.orderId = "ORD-123";
order.customerName = "John Doe";

auto item1 = new OrderItemTO();
item1.productName = "Laptop";
item1.quantity = 1;

auto item2 = new OrderItemTO();
item2.productName = "Mouse";
item2.quantity = 2;

order.addChild(item1);
order.addChild(item2);

// Validate entire structure
if (order.validate()) {
    // Transfer complete order
}
```

### Transfer Object Assembler

```d
// Domain object
class User {
    int id;
    string name;
    string email;
}

// Transfer object
class UserTO : TransferObject {
    string name;
    string email;
    // ... implementation
}

// Assembler
class UserAssembler : TransferObjectAssembler!(User, UserTO) {
    override UserTO toTransferObject(User domain) {
        auto to = new UserTO();
        to.name = domain.name;
        to.email = domain.email;
        return to;
    }

    override User toDomainObject(UserTO transfer) {
        auto user = new User();
        user.name = transfer.name;
        user.email = transfer.email;
        return user;
    }
}

// Usage
auto assembler = new UserAssembler();
User domainUser = getUserFromDatabase();
UserTO transferUser = assembler.toTransferObject(domainUser);

// Send to client...

// Receive from client
UserTO receivedTO = receiveFromClient();
User domainUser = assembler.toDomainObject(receivedTO);
saveUserToDatabase(domainUser);
```

### Batch Conversion

```d
auto assembler = new UserAssembler();

// Convert multiple domain objects
User[] users = getAllUsersFromDatabase();
UserTO[] userTOs = assembler.toTransferObjects(users);

// Send array to client as JSON

// Receive array from client
UserTO[] receivedTOs = receiveFromClient();
User[] users = assembler.toDomainObjects(receivedTOs);
saveUsersToDatabase(users);
```

### Immutable Transfer Object

```d
class ConfigTO : ImmutableTransferObject {
    string apiKey;
    string endpoint;

    override string[string] toMap() {
        string[string] map;
        map["apiKey"] = apiKey;
        map["endpoint"] = endpoint;
        return map;
    }

    protected override void fromMapImpl(string[string] data) {
        apiKey = data.get("apiKey", "");
        endpoint = data.get("endpoint", "");
    }
}

// Initialize once
auto config = new ConfigTO();
config.fromMap(configData);

// Cannot be modified afterward
config.fromMap(newData); // Ignored - already initialized
```

## Benefits

### 1. **Reduced Network Calls**
Aggregates multiple data values into a single object, reducing the number of remote calls.

### 2. **Serialization**
Provides a clean way to serialize/deserialize data for network transfer or storage.

### 3. **Decoupling**
Separates internal domain model from external representation.

### 4. **Versioning**
Allows different TO versions for backward compatibility.

### 5. **Security**
Controls what data is exposed to external clients.

### 6. **Performance**
Optimized data structure for transfer, reducing bandwidth usage.

## Use Cases

### 1. **REST APIs**
```d
// API endpoint returns UserTO, not internal User model
UserTO getUserById(int id) {
    auto user = database.findUser(id);
    return assembler.toTransferObject(user);
}
```

### 2. **Microservices Communication**
```d
// Service A sends OrderTO to Service B
auto orderTO = new OrderTO();
orderTO.orderId = order.id;
orderTO.totalAmount = order.calculateTotal().to!string;

serviceBClient.processOrder(orderTO.toJson());
```

### 3. **Layer Separation**
```d
// Presentation Layer
class UserController {
    UserTO getUserProfile(int id) {
        // Get from business layer
        auto user = userService.getUser(id);
        
        // Convert to TO for presentation
        return userAssembler.toTransferObject(user);
    }
}
```

### 4. **Data Import/Export**
```d
// Export data
ProductTO[] products = assembler.toTransferObjects(getAllProducts());
string json = serializeArray(products);
writeToFile("export.json", json);

// Import data
string json = readFromFile("import.json");
ProductTO[] importedTOs = deserializeArray(json);
Product[] products = assembler.toDomainObjects(importedTOs);
saveProducts(products);
```

### 5. **Testing**
```d
// Create test data easily
auto testUser = new UserTO();
testUser.username = "testuser";
testUser.email = "test@example.com";

// Use in tests without database
assert(testUser.validate());
```

## Best Practices

### 1. **Keep TOs Simple**
Transfer objects should only contain data, no business logic:
```d
// Good
class UserTO : TransferObject {
    string name;
    string email;
}

// Bad - contains business logic
class UserTO : TransferObject {
    string name;
    string email;
    
    void sendWelcomeEmail() { } // Don't do this!
}
```

### 2. **Use Validation**
Always implement validation:
```d
override bool validate() {
    return name.length > 0 && 
           email.canFind("@") && 
           age >= 0 && age <= 150;
}
```

### 3. **Use Assemblers**
Don't mix conversion logic with TOs or domain objects:
```d
// Good - separate assembler
class UserAssembler : TransferObjectAssembler!(User, UserTO) { }

// Bad - conversion in domain object
class User {
    UserTO toTransferObject() { } // Don't do this!
}
```

### 4. **Immutability When Appropriate**
Use immutable TOs for configuration or read-only data:
```d
class ConstantConfigTO : ImmutableTransferObject {
    // Can only be set once
}
```

### 5. **Version Your TOs**
For APIs, consider versioning:
```d
class UserTOV1 : TransferObject { }
class UserTOV2 : TransferObject { } // Extended version
```

## Performance Considerations

### Memory Usage
- **TransferObject**: O(n) for n fields
- **CompositeTransferObject**: O(n + m) where m is children count
- **Assembler conversion**: O(n) for n objects

### Serialization Performance
- JSON serialization: O(n) for n fields
- Map conversion: O(n) for n fields
- Batch conversion: O(n*m) for n objects with m fields

### Optimization Tips
1. Use lazy initialization for expensive conversions
2. Cache frequently used TOs
3. Use batch conversion for multiple objects
4. Consider binary serialization for large data sets
5. Minimize nested structure depth

## Thread Safety

- **TransferObject**: Not thread-safe by default
- **ImmutableTransferObject**: Thread-safe after initialization
- For multi-threaded use: Create new instances or add synchronization

## Testing

Run the comprehensive test suite:
```bash
cd oop
dub test
```

Tests include:
- Basic TO creation and validation
- Serialization/deserialization
- Map conversion
- Composite structures
- Assembler conversions
- Batch operations
- Real-world scenarios

## Common Patterns

### 1. **Partial Updates**
```d
class UserUpdateTO : TransferObject {
    string email;  // Only fields that can be updated
    string phone;
}
```

### 2. **Aggregated Data**
```d
class DashboardTO : CompositeTransferObject {
    string summary;
    // Contains multiple nested TOs for dashboard widgets
}
```

### 3. **Search Results**
```d
class SearchResultTO : TransferObject {
    int totalCount;
    int pageSize;
    int currentPage;
    // + array of result items
}
```

## Related Patterns

- **DAO Pattern**: TOs often used with DAOs for data access
- **Repository Pattern**: Repositories return TOs instead of entities
- **Facade Pattern**: Facades can use TOs for simplified interfaces
- **Builder Pattern**: Can be used to construct complex TOs
- **Factory Pattern**: Create appropriate TO types

## Comparison with Domain Objects

| Aspect | Transfer Object | Domain Object |
|--------|----------------|---------------|
| Purpose | Data transfer | Business logic |
| Complexity | Simple | Complex |
| Dependencies | Minimal | Many |
| Serialization | Optimized | Not always needed |
| Mutability | Often immutable | Usually mutable |
| Validation | Format only | Business rules |

## Conclusion

The Transfer Object Pattern provides an efficient way to transfer data between layers and across network boundaries. It decouples the internal domain model from external representations, improves performance, and simplifies serialization. The implementation includes multiple variants (basic, serializable, composite, immutable) with comprehensive assembler support for seamless conversions.

The pattern is fully implemented and tested in the UIM OOP library, ready for production use in multi-tier applications, microservices, and REST APIs.
