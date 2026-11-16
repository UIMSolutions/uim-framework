# Data Access Object (DAO) Pattern

## Overview

The **Data Access Object (DAO) pattern** is a structural design pattern that provides an abstract interface to a database or any other persistence mechanism. It separates the business logic from the data access logic, making the code more maintainable, testable, and flexible.

## Purpose

- **Abstraction**: Provides an abstract interface to access data from different sources
- **Separation of Concerns**: Decouples business logic from data persistence logic
- **Flexibility**: Makes it easy to change the underlying data source without affecting business logic
- **Testability**: Enables easy mocking and testing of data access operations
- **Reusability**: Common data access patterns can be reused across different entities

## Structure

```
┌─────────────────┐
│   IDAOInterface │
└────────┬────────┘
         │ implements
         │
┌────────▼────────┐
│    BaseDAO      │  (Abstract base class)
└────────┬────────┘
         │ extends
         │
    ┌────┴────┬─────────────┬──────────────┐
    │         │             │              │
┌───▼──┐  ┌──▼──────┐  ┌───▼────────┐  ┌─▼──────────┐
│Memory│  │Cacheable│  │Transactional│  │  Custom   │
│ DAO  │  │   DAO   │  │    DAO      │  │   DAO     │
└──────┘  └─────────┘  └─────────────┘  └───────────┘
```

## Components

### 1. Interfaces

#### `IDAO<T, ID>`
The base DAO interface defining CRUD operations:
- `findById(ID)` - Find entity by identifier
- `findAll()` - Retrieve all entities
- `save(T)` - Create new entity
- `update(T)` - Update existing entity
- `deleteById(ID)` - Delete by identifier
- `remove(T)` - Delete entity
- `exists(ID)` - Check if entity exists
- `count()` - Count total entities

#### `IQueryableDAO<T, ID>`
Extended interface with query capabilities:
- `findWhere(predicate)` - Find entities matching predicate
- `findFirst(predicate)` - Find first matching entity
- `countWhere(predicate)` - Count matching entities

#### `ITransactionalDAO<T, ID>`
Interface for transaction support:
- `beginTransaction()` - Start transaction
- `commit()` - Commit changes
- `rollback()` - Revert changes
- `isTransactionActive()` - Check transaction state

#### `ICacheableDAO<T, ID>`
Interface for caching support:
- `enableCache()` - Enable caching
- `disableCache()` - Disable caching
- `clearCache()` - Clear cache
- `isCacheEnabled()` - Check cache state

#### `IBatchDAO<T, ID>`
Interface for batch operations:
- `saveAll(T[])` - Save multiple entities
- `updateAll(T[])` - Update multiple entities
- `deleteAllById(ID[])` - Delete by multiple IDs
- `deleteWhere(predicate)` - Delete matching entities

### 2. Base Classes

#### `BaseDAO<T, ID>`
Abstract base class providing common functionality for all DAOs. Implements `IQueryableDAO` with default implementations for query operations.

#### `MemoryDAO<T, ID>`
In-memory implementation suitable for:
- Testing and prototyping
- Small datasets
- Caching scenarios
- Development environments

Features:
- Fast in-memory storage
- Auto-incrementing IDs
- Full CRUD support
- Batch operations
- Query operations

#### `CacheableDAO<T, ID>`
Decorator that adds caching to any DAO implementation:
- Transparent caching layer
- Configurable cache enable/disable
- Cache invalidation on updates/deletes
- Wraps any IDAO implementation

#### `TransactionalDAO<T, ID>`
Decorator that adds transaction support:
- Begin/Commit/Rollback operations
- Pending changes buffer
- Atomic operations
- Wraps any IDAO implementation

## Usage Examples

### Basic CRUD Operations

```d
import uim.oop.patterns.daos;

// Define entity
class User {
  int id;
  string name;
  string email;
  int age;

  this(string name, string email, int age) {
    this.name = name;
    this.email = email;
    this.age = age;
  }
}

// Create DAO
auto userDAO = new MemoryDAO!(User, int)();

// Create
auto user = new User("Alice", "alice@example.com", 25);
user = userDAO.save(user);
// user.id is now auto-generated (e.g., 1)

// Read
auto found = userDAO.findById(user.id);
auto allUsers = userDAO.findAll();

// Update
user.age = 26;
userDAO.update(user);

// Delete
userDAO.deleteById(user.id);
```

### Query Operations

```d
auto dao = new MemoryDAO!(User, int)();

dao.save(new User("Alice", "alice@example.com", 25));
dao.save(new User("Bob", "bob@example.com", 30));
dao.save(new User("Charlie", "charlie@example.com", 25));

// Find all users aged 25
auto age25 = dao.findWhere((User u) => u.age == 25);
// Returns [Alice, Charlie]

// Find first user named Bob
auto bob = dao.findFirst((User u) => u.name == "Bob");

// Count users over 25
auto count = dao.countWhere((User u) => u.age > 25);
// Returns 1
```

### Batch Operations

```d
auto dao = new MemoryDAO!(User, int)();

// Save multiple users at once
User[] users = [
  new User("User1", "user1@example.com", 20),
  new User("User2", "user2@example.com", 21),
  new User("User3", "user3@example.com", 22)
];
auto saved = dao.saveAll(users);

// Update all
foreach (user; saved) {
  user.age += 1;
}
dao.updateAll(saved);

// Delete matching criteria
auto deleted = dao.deleteWhere((User u) => u.age > 21);
```

### Caching

```d
// Wrap any DAO with caching
auto innerDAO = new MemoryDAO!(User, int)();
auto cachedDAO = new CacheableDAO!(User, int)(innerDAO);

auto user = cachedDAO.save(new User("Alice", "alice@example.com", 25));

// First call - fetches from storage
auto found1 = cachedDAO.findById(user.id);

// Second call - returns from cache (faster)
auto found2 = cachedDAO.findById(user.id);

// Control caching
cachedDAO.clearCache();      // Clear all cached data
cachedDAO.disableCache();    // Disable caching temporarily
cachedDAO.enableCache();     // Re-enable caching
```

### Transactions

```d
auto innerDAO = new MemoryDAO!(User, int)();
auto txDAO = new TransactionalDAO!(User, int)(innerDAO);

auto user = txDAO.save(new User("Alice", "alice@example.com", 25));

// Begin transaction
txDAO.beginTransaction();

// Make changes
user.age = 30;
txDAO.update(user);

// Rollback - changes are not saved
txDAO.rollback();

// Commit - changes are saved
txDAO.beginTransaction();
user.age = 35;
txDAO.update(user);
txDAO.commit();
```

### Custom DAO Implementation

```d
// Implement a custom file-based DAO
class FileDAO(T, ID) : BaseDAO!(T, ID) {
  private string _filePath;

  this(string filePath) {
    _filePath = filePath;
  }

  override T findById(ID id) {
    // Read from file and find entity
    // Implementation details...
  }

  override T[] findAll() {
    // Read all entities from file
    // Implementation details...
  }

  override T save(T entity) {
    // Write entity to file
    // Implementation details...
  }

  override T update(T entity) {
    // Update entity in file
    // Implementation details...
  }

  override bool deleteById(ID id) {
    // Remove entity from file
    // Implementation details...
  }
}
```

## Benefits

### 1. **Loose Coupling**
Business logic doesn't depend on specific data access implementation.

### 2. **Easy Testing**
Use `MemoryDAO` for unit tests without database setup.

```d
unittest {
  // Fast in-memory testing
  auto dao = new MemoryDAO!(User, int)();
  auto user = dao.save(new User("Test", "test@example.com", 20));
  assert(user.id > 0);
}
```

### 3. **Flexibility**
Switch between different storage mechanisms easily:

```d
// Development: in-memory
IDAO!(User, int) dao = new MemoryDAO!(User, int)();

// Production: database
// dao = new DatabaseDAO!(User, int)(connectionString);

// Testing: mock
// dao = new MockDAO!(User, int)();
```

### 4. **Composability**
Combine decorators for enhanced functionality:

```d
// Cached + Transactional DAO
auto baseDAO = new MemoryDAO!(User, int)();
auto cachedDAO = new CacheableDAO!(User, int)(baseDAO);
auto txDAO = new TransactionalDAO!(User, int)(cachedDAO);
```

## Best Practices

### 1. **Use Interfaces**
Always program against `IDAO` interface, not concrete implementations:

```d
// Good
IDAO!(User, int) dao = new MemoryDAO!(User, int)();

// Avoid
MemoryDAO!(User, int) dao = new MemoryDAO!(User, int)();
```

### 2. **Entity Requirements**
Entities should have an `id` field for proper DAO functionality:

```d
class Entity {
  int id;  // Required for auto-increment and operations
  // other fields...
}
```

### 3. **Transaction Scope**
Keep transactions short and focused:

```d
dao.beginTransaction();
try {
  // Perform operations
  dao.update(entity);
  dao.commit();
} catch (Exception e) {
  dao.rollback();
  throw e;
}
```

### 4. **Cache Management**
Clear cache when data is modified externally:

```d
// After bulk import or external changes
cachedDAO.clearCache();
```

## Real-World Use Cases

### 1. **User Management System**
```d
class UserService {
  private IDAO!(User, int) _userDAO;

  this(IDAO!(User, int) dao) {
    _userDAO = dao;
  }

  User registerUser(string name, string email) {
    auto user = new User(name, email, 0);
    return _userDAO.save(user);
  }

  User[] searchUsers(string keyword) {
    return _userDAO.findWhere((User u) =>
      u.name.indexOf(keyword) >= 0 ||
      u.email.indexOf(keyword) >= 0
    );
  }
}
```

### 2. **Product Catalog**
```d
class ProductRepository {
  private IBatchDAO!(Product, int) _productDAO;

  this() {
    _productDAO = new MemoryDAO!(Product, int)();
  }

  Product[] getLowStockProducts() {
    return _productDAO.findWhere((Product p) => p.stock < 10);
  }

  void bulkUpdatePrices(Product[] products) {
    _productDAO.updateAll(products);
  }
}
```

### 3. **Cached Customer Data**
```d
class CustomerService {
  private ICacheableDAO!(Customer, long) _customerDAO;

  this() {
    auto baseDAO = new MemoryDAO!(Customer, long)();
    _customerDAO = new CacheableDAO!(Customer, long)(baseDAO);
  }

  Customer getCustomer(long id) {
    // Benefits from caching on repeated calls
    return _customerDAO.findById(id);
  }

  void refreshCache() {
    _customerDAO.clearCache();
  }
}
```

## Performance Considerations

### Time Complexity
- **findById**: O(1) for MemoryDAO (associative array lookup)
- **findAll**: O(n) where n is number of entities
- **save/update/delete**: O(1) for MemoryDAO
- **findWhere**: O(n) - must scan all entities
- **Cached operations**: O(1) on cache hit

### Space Complexity
- **MemoryDAO**: O(n) for n entities
- **CacheableDAO**: O(n + m) where m is cached entities
- **TransactionalDAO**: O(p) where p is pending changes

### Optimization Tips
1. Use caching for frequently accessed data
2. Implement batch operations for multiple entities
3. Use predicates efficiently in queries
4. Consider lazy loading for large datasets
5. Clear caches periodically to avoid memory issues

## Related Patterns

- **Repository Pattern**: Higher-level abstraction over DAOs
- **Active Record**: Alternative where entities contain persistence logic
- **Data Mapper**: Maps between objects and database
- **Unit of Work**: Tracks changes and coordinates persistence
- **Decorator Pattern**: Used for CacheableDAO and TransactionalDAO

## Thread Safety

The current implementation is **not thread-safe**. For multi-threaded environments:
- Add synchronization (mutex/locks)
- Use thread-local storage
- Implement immutable entities
- Consider concurrent collections

## Testing

All implementations include comprehensive unit tests:

```bash
# Run tests
dub test

# Run specific pattern tests
cd oop
dub test
```

## Conclusion

The DAO pattern is essential for:
- Clean architecture
- Testable code
- Flexible data access
- Maintainable applications

Use `MemoryDAO` for testing, prototyping, and simple applications. Extend `BaseDAO` or implement `IDAO` for custom storage mechanisms. Combine with decorators (CacheableDAO, TransactionalDAO) for enhanced functionality.

---

**Implementation Status**: ✅ Complete  
**Test Coverage**: ✅ Comprehensive  
**Documentation**: ✅ Full

**Author**: Ozan Nurettin Süel (UIManufaktur)  
**License**: Apache 2.0  
**Version**: 1.0.0
