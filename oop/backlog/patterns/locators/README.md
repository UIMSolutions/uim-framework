# Service Locator Pattern

## Overview

The Service Locator pattern is a design pattern used to encapsulate the processes involved in obtaining a service with a strong abstraction layer. This pattern uses a central registry known as the "service locator", which on request returns the information necessary to perform a certain task.

## Purpose

The Service Locator pattern:
- Provides a centralized registry for obtaining services
- Decouples service consumers from concrete service implementations
- Enables lazy instantiation of services
- Facilitates service discovery and dependency resolution
- Simplifies service management in large applications

## Structure

```
┌─────────────────────────────────────────────────────────────────┐
│                        Service Locator                          │
│                                                                 │
│  ┌─────────────┐          ┌────────────────┐                  │
│  │   Client    │─────────>│ IServiceLocator│                  │
│  └─────────────┘          └────────────────┘                  │
│                                   △                             │
│                                   │                             │
│           ┌───────────────────────┼───────────────────────┐    │
│           │                       │                       │    │
│  ┌────────────────┐  ┌─────────────────────┐  ┌─────────────┐│
│  │ServiceLocator  │  │LazyServiceLocator   │  │CachedService││
│  │                │  │                     │  │Locator      ││
│  └────────────────┘  └─────────────────────┘  └─────────────┘│
│           │                       │                       │    │
│           └───────────────────────┼───────────────────────┘    │
│                                   ▼                             │
│                          ┌─────────────┐                       │
│                          │  IService   │                       │
│                          └─────────────┘                       │
└─────────────────────────────────────────────────────────────────┘
```

## Components

### Interfaces

#### `IService`

Base interface for all services that can be registered with a Service Locator.

- `serviceName()` - Get the name of the service
- `execute()` - Execute the service's main operation

#### `IServiceLocator`

Core Service Locator interface.

- `registerService(name, service)` - Register a service
- `getService(name)` - Retrieve a service by name
- `hasService(name)` - Check if a service exists
- `unregisterService(name)` - Remove a service
- `getServiceNames()` - Get all registered service names
- `clear()` - Remove all services

#### `ILazyServiceLocator`

Extension for lazy-loading services.

- `registerFactory(name, factory)` - Register a factory function for lazy instantiation

#### `ICachedServiceLocator`

Extension for cached service lookups.

- `setCacheEnabled(enabled)` - Enable/disable caching
- `isCacheEnabled()` - Check cache status
- `clearCache()` - Clear the cache

### Implementations

#### `Service`

Abstract base class for services.

- Provides common service functionality
- Stores service name
- Requires `execute()` implementation

#### `ServiceLocator`

Basic service locator implementation.

- Immediate service registration
- Direct service lookup
- Simple service management

#### `LazyServiceLocator`

Lazy-loading service locator.

- Factory-based service registration
- On-demand service instantiation
- Singleton service instances after first creation

#### `CachedServiceLocator`

Cached service locator for performance optimization.

- Caches service lookups
- Configurable caching behavior
- Improved lookup performance

#### `HierarchicalServiceLocator`

Hierarchical service locator with parent-child relationships.

- Multi-level service resolution
- Service inheritance from parents
- Local service shadowing

## Usage Examples

### Basic Service Locator

```d
// Define a service
class EmailService : Service {
    this() {
        super("EmailService");
    }

    override string execute() {
        return "Email sent";
    }
}

// Create and use locator
auto locator = new ServiceLocator();
locator.registerService("email", new EmailService());

auto service = locator.getService("email");
string result = service.execute();
```

### Lazy Service Locator

```d
auto locator = new LazyServiceLocator();

// Register factory - service not created yet
locator.registerFactory("email", () {
    auto svc = new EmailService();
    svc.configure();
    return cast(IService) svc;
});

// Service created on first access
auto service = locator.getService("email");

// Subsequent calls return same instance
auto same = locator.getService("email");
assert(service is same);
```

### Cached Service Locator

```d
auto locator = new CachedServiceLocator();

locator.registerService("email", new EmailService());

// First lookup - caches result
auto service1 = locator.getService("email");

// Second lookup - returns cached instance
auto service2 = locator.getService("email");

// Clear cache if needed
locator.clearCache();

// Disable caching
locator.setCacheEnabled(false);
```

### Hierarchical Service Locator

```d
auto rootLocator = new HierarchicalServiceLocator();
auto childLocator = new HierarchicalServiceLocator(rootLocator);

// Register shared services in root
rootLocator.registerService("logging", new LoggingService());

// Register specific services in child
childLocator.registerService("email", new EmailService());

// Child can access both
auto log = childLocator.getService("logging");  // From parent
auto email = childLocator.getService("email");  // From self
```

### Real-World Application Example

```d
// Application-wide service locator
auto appServices = new CachedServiceLocator();

// Register core services
appServices.registerService("database", new DatabaseService());
appServices.registerService("cache", new CacheService());
appServices.registerService("logging", new LoggingService());
appServices.registerService("email", new EmailService());

// Use throughout application
class UserController {
    private IServiceLocator _services;

    this(IServiceLocator services) {
        _services = services;
    }

    void createUser(string email) {
        auto db = cast(DatabaseService) _services.getService("database");
        auto log = cast(LoggingService) _services.getService("logging");
        auto mail = cast(EmailService) _services.getService("email");

        log.execute();  // Log operation
        db.execute();   // Save to database
        mail.execute(); // Send welcome email
    }
}

auto controller = new UserController(appServices);
```

### Module-Specific Service Locators

```d
// Create hierarchy for modular application
auto coreServices = new HierarchicalServiceLocator();
auto moduleAServices = new HierarchicalServiceLocator(coreServices);
auto moduleBServices = new HierarchicalServiceLocator(coreServices);

// Core services available to all modules
coreServices.registerService("config", new ConfigService());
coreServices.registerService("logging", new LoggingService());

// Module-specific services
moduleAServices.registerService("featureA", new FeatureAService());
moduleBServices.registerService("featureB", new FeatureBService());

// Each module has access to core + its own services
```

## Benefits

### 1. **Decoupling**

Services are accessed through an abstraction layer, reducing dependencies on concrete implementations.

### 2. **Centralized Service Management**

All service registration and lookup happens in one place, making it easier to manage and configure services.

### 3. **Lazy Initialization**

Services can be created only when needed, reducing startup time and memory usage.

### 4. **Service Discovery**

Clients can discover available services at runtime without compile-time dependencies.

### 5. **Testability**

Easy to substitute mock services for testing by registering test implementations.

### 6. **Flexibility**

Services can be added, removed, or replaced at runtime without modifying client code.

## Design Patterns Used

The Service Locator implementation uses several other patterns:

- **Registry Pattern**: Central storage of services
- **Singleton Pattern**: Single instance per service (in lazy locator)
- **Factory Pattern**: Service creation through factories
- **Decorator Pattern**: Cached and lazy variants extend base behavior

## Best Practices

### 1. **Use Interfaces**

Always program to interfaces, not implementations:

```d
IService service = locator.getService("email");
```

### 2. **Avoid Overuse**

Service Locator can hide dependencies. Consider using Dependency Injection for better explicitness.

### 3. **Register at Startup**

Register all services during application initialization:

```d
void configureServices(IServiceLocator locator) {
    locator.registerService("email", new EmailService());
    locator.registerService("database", new DatabaseService());
    // ... register all services
}
```

### 4. **Use Factories for Expensive Services**

Use lazy loading for services that are expensive to create:

```d
locator.registerFactory("heavyService", () {
    return cast(IService) new ExpensiveService();
});
```

### 5. **Clear Naming**

Use clear, descriptive names for services:

```d
locator.registerService("userDatabase", userDB);
locator.registerService("productCache", productCache);
```

## Performance Considerations

### Service Lookup Performance

- **ServiceLocator**: O(1) lookup (associative array)
- **LazyServiceLocator**: O(1) after first instantiation
- **CachedServiceLocator**: O(1) cache hit, O(1) on miss
- **HierarchicalServiceLocator**: O(h) where h is hierarchy depth

### Memory Usage

- **ServiceLocator**: O(n) for n services
- **LazyServiceLocator**: O(n) for instantiated services, O(m) for m factories
- **CachedServiceLocator**: O(2n) for services + cache
- **HierarchicalServiceLocator**: O(n) per level

### Optimization Tips

1. Use caching for frequently accessed services
2. Use lazy loading for rarely used or expensive services
3. Keep hierarchy depth minimal
4. Clear caches when services are updated
5. Monitor service creation overhead

## Comparison with Dependency Injection

| Aspect | Service Locator | Dependency Injection |
|--------|----------------|---------------------|
| Dependencies | Hidden | Explicit |
| Testability | Good | Better |
| Coupling | Medium | Loose |
| Complexity | Low | Medium |
| Flexibility | High | High |

## Thread Safety

The current implementation is not thread-safe. For multi-threaded applications:

- Add synchronization (mutex/locks) for service registration
- Use thread-local storage for per-thread services
- Consider immutable service registration after initialization

## Testing

Run the comprehensive test suite:

```bash
cd oop
dub test
```

The test suite includes:
- Basic service registration and retrieval
- Multiple service management
- Lazy instantiation
- Caching behavior
- Hierarchical lookups
- Service replacement
- Real-world scenarios

## Common Use Cases

### 1. **Application Services**

Managing application-wide services like logging, configuration, and database connections.

### 2. **Plugin Systems**

Dynamically registering and discovering plugin services.

### 3. **Microservices**

Service discovery in distributed systems.

### 4. **Testing**

Swapping real services with mock implementations.

### 5. **Resource Management**

Managing shared resources like connection pools and caches.

## Related Patterns

- **Dependency Injection**: Alternative approach to dependency management
- **Registry Pattern**: Central storage mechanism
- **Factory Pattern**: Service creation
- **Singleton Pattern**: Ensuring single service instances
- **Abstract Factory**: Creating families of related services

## Conclusion

The Service Locator pattern provides a flexible, centralized approach to service management. While it has some drawbacks (hidden dependencies), it offers benefits in terms of decoupling, flexibility, and ease of use. The implementation includes multiple variants (basic, lazy, cached, hierarchical) to suit different application needs.

The pattern is fully implemented and tested in the UIM OOP library, ready for production use.
