# Proxy Pattern

## Overview

The Proxy Pattern provides a surrogate or placeholder for another object to control access to it. The proxy acts as an interface to something else, such as a network connection, a large object in memory, a file, or some other resource that is expensive or impossible to duplicate.

## Purpose

The Proxy pattern:
- Controls access to an object
- Provides a placeholder for expensive operations (lazy initialization)
- Adds additional functionality when accessing an object
- Manages remote object access
- Implements access control and security
- Provides caching and performance optimization

## Structure

```
┌─────────────────────────────────────────────────────────────────┐
│                         Proxy Pattern                           │
│                                                                 │
│  ┌──────────┐         ┌──────────────┐         ┌──────────┐   │
│  │  Client  │────────>│  <<ISubject>>│<────────│RealSubject│  │
│  └──────────┘         └──────────────┘         └──────────┘   │
│                              △                                  │
│                              │                                  │
│                         ┌────┴────┐                            │
│                         │  Proxy  │                            │
│                         └─────────┘                            │
│                              │                                  │
│                    ┌─────────┴──────────┐                     │
│                    │                     │                      │
│              ┌─────▼─────┐        ┌────▼────┐                 │
│              │  Virtual  │        │Protection│                 │
│              │   Proxy   │        │  Proxy   │                 │
│              └───────────┘        └──────────┘                 │
└─────────────────────────────────────────────────────────────────┘
```

## Types of Proxies

### 1. Virtual Proxy
Defers the creation and initialization of expensive objects until they're actually needed.

### 2. Protection Proxy
Controls access to the original object based on access rights.

### 3. Remote Proxy
Represents an object in a different address space (different machine, network).

### 4. Caching Proxy
Provides temporary storage for results of expensive operations.

### 5. Logging Proxy
Logs accesses to the real subject for monitoring and auditing.

### 6. Smart Reference Proxy
Performs additional actions when an object is accessed (reference counting, etc.).

## Usage Examples

### Virtual Proxy (Lazy Initialization)

```d
class ExpensiveImage : Subject {
    this(string path) {
        // Simulate expensive image loading
    }
    
    override string execute() {
        return "Image displayed";
    }
}

// Create proxy with factory
auto imageProxy = new VirtualProxy(() {
    return cast(ISubject) new ExpensiveImage("large-file.jpg");
});

// Image not loaded yet
assert(!imageProxy.isInitialized());

// Image loaded on first access
auto result = imageProxy.execute();
assert(imageProxy.isInitialized());
```

### Protection Proxy (Access Control)

```d
class SecureDocument : Subject {
    override string execute() {
        return "Confidential data";
    }
}

auto document = new SecureDocument();
auto proxy = new ProtectionProxy(document, false); // Access denied

auto result = proxy.execute();
assert(result == "Access denied");

// Grant access
proxy.setAccessAllowed(true);
result = proxy.execute();
assert(result == "Confidential data");
```

### Caching Proxy (Performance)

```d
class DatabaseQuery : Subject {
    override string execute() {
        // Expensive database operation
        return "Query result";
    }
}

auto query = new DatabaseQuery();
auto proxy = new CachingProxy(query);

// First call - executes query
auto result1 = proxy.execute();

// Subsequent calls - from cache
auto result2 = proxy.execute(); // Fast!
assert(proxy.isCached());
```

### Logging Proxy (Monitoring)

```d
class APICall : Subject {
    override string execute() {
        return "API response";
    }
}

auto api = new APICall();
auto proxy = new LoggingProxy(api);

proxy.execute();
proxy.execute();

// Check audit trail
auto log = proxy.getLog();
assert(log.length > 0); // All accesses logged
```

### Remote Proxy (Network)

```d
class RemoteService : Subject {
    override string execute() {
        return "Service data";
    }
}

auto service = new RemoteService();
auto proxy = new RemoteProxy(service, "https://api.example.com");

auto result = proxy.execute();
// Result prefixed with remote endpoint info
```

### Smart Reference Proxy (Reference Counting)

```d
class Resource : Subject {
    override string execute() {
        return "Resource accessed";
    }
}

auto resource = new Resource();
auto proxy = new SmartReferenceProxy(resource);

proxy.execute();
proxy.execute();
proxy.execute();

assert(proxy.getAccessCount() == 3);
```

### Proxy Chaining

```d
auto realService = new DatabaseService("prod-db");

// Chain multiple proxies
auto protectedService = new ProtectionProxy(realService, true);
auto cachedService = new CachingProxy(protectedService);
auto loggedService = new LoggingProxy(cachedService);

// Access through chain
auto result = loggedService.execute();
// Result is: logged, checked for cache, access-controlled
```

## Benefits

### 1. **Controlled Access**
Proxies can control access to objects, adding security or validation.

### 2. **Lazy Initialization**
Virtual proxies defer expensive object creation until needed.

### 3. **Performance Optimization**
Caching proxies reduce redundant expensive operations.

### 4. **Remote Access**
Remote proxies hide the complexity of network communication.

### 5. **Additional Functionality**
Proxies can add logging, monitoring, or other cross-cutting concerns.

### 6. **Separation of Concerns**
Keeps the real subject simple by moving auxiliary functionality to the proxy.

## Use Cases

### 1. **Lazy Loading Large Objects**
```d
// Don't load until needed
auto imageProxy = new VirtualProxy(() => loadLargeImage());
```

### 2. **Access Control**
```d
// Check permissions before allowing access
auto proxy = new ProtectionProxy(sensitiveData, hasPermission());
```

### 3. **Caching Expensive Operations**
```d
// Cache database query results
auto proxy = new CachingProxy(databaseQuery);
```

### 4. **Logging and Auditing**
```d
// Track all accesses for security audit
auto proxy = new LoggingProxy(criticalResource);
```

### 5. **Remote Service Access**
```d
// Hide network communication details
auto proxy = new RemoteProxy(service, "https://remote-api.com");
```

### 6. **Resource Management**
```d
// Track resource usage
auto proxy = new SmartReferenceProxy(expensiveResource);
```

## Best Practices

### 1. **Maintain Interface Consistency**
Proxy should implement the same interface as the real subject:
```d
interface ISubject {
    string execute();
}

class Proxy : ISubject {
    string execute() {
        return _realSubject.execute();
    }
}
```

### 2. **Use Factories for Virtual Proxies**
Pass factory functions for lazy initialization:
```d
auto proxy = new VirtualProxy(() => createExpensiveObject());
```

### 3. **Chain Proxies for Multiple Concerns**
Combine different proxy types:
```d
auto chained = new LoggingProxy(
    new CachingProxy(
        new ProtectionProxy(realObject, true)
    )
);
```

### 4. **Clear Cache When Needed**
For caching proxies, provide cache invalidation:
```d
proxy.clearCache(); // When data changes
```

### 5. **Document Proxy Behavior**
Make it clear what additional functionality the proxy provides.

## Performance Considerations

### Virtual Proxy
- **Initialization**: O(1) on first access, then O(1)
- **Memory**: Saves memory until object is created

### Caching Proxy
- **First call**: O(n) where n is operation cost
- **Cached calls**: O(1)
- **Memory**: O(m) where m is cached data size

### Protection Proxy
- **Access check**: O(1)
- **Overhead**: Minimal

### Logging Proxy
- **Log entry**: O(1) per access
- **Memory**: O(n) where n is number of accesses

### Optimization Tips
1. Use virtual proxies for rarely-used expensive objects
2. Implement cache expiration for stale data
3. Use protection proxies only when security is needed
4. Limit log size in logging proxies
5. Consider connection pooling with remote proxies

## Proxy vs Decorator vs Adapter

| Aspect | Proxy | Decorator | Adapter |
|--------|-------|-----------|---------|
| Purpose | Control access | Add functionality | Convert interface |
| Subject | Same interface | Same interface | Different interface |
| Creation | May create subject | Wraps existing | Wraps existing |
| Transparency | Often transparent | Adds visible features | Changes interface |

## Thread Safety

- **Virtual Proxy**: Not thread-safe by default, needs synchronization
- **Protection Proxy**: Thread-safe for read-only access checks
- **Caching Proxy**: Needs synchronization for multi-threaded access
- **Logging Proxy**: Needs synchronization for log writes

For multi-threaded use:
```d
// Add mutex protection
synchronized {
    proxy.execute();
}
```

## Testing

Run the comprehensive test suite:
```bash
cd oop
dub test
```

Tests include:
- Virtual proxy lazy initialization
- Protection proxy access control
- Caching proxy optimization
- Logging proxy tracking
- Remote proxy simulation
- Smart reference counting
- Proxy chaining
- Real-world scenarios

## Common Patterns

### 1. **Copy-on-Write Proxy**
```d
// Create copy only when modified
class CopyOnWriteProxy : IProxy { }
```

### 2. **Firewall Proxy**
```d
// Control network access
class FirewallProxy : IProtectionProxy { }
```

### 3. **Synchronization Proxy**
```d
// Add thread synchronization
class SynchronizationProxy : IProxy { }
```

## Related Patterns

- **Decorator Pattern**: Both wrap objects, but decorator adds behavior while proxy controls access
- **Adapter Pattern**: Changes interface while proxy maintains it
- **Facade Pattern**: Simplifies interface while proxy controls access
- **Flyweight Pattern**: Shares objects while proxy controls access

## Comparison with Other Patterns

### Proxy vs Adapter
- Proxy: Same interface, controls access
- Adapter: Different interface, converts calls

### Proxy vs Decorator
- Proxy: Controls access, may create object
- Decorator: Adds functionality, wraps existing object

### Proxy vs Facade
- Proxy: One-to-one relationship
- Facade: Simplifies complex subsystem

## Real-World Examples

### 1. **ORM Lazy Loading**
```d
// Database record not loaded until accessed
auto userProxy = new VirtualProxy(() => loadUserFromDB(userId));
```

### 2. **Image Placeholder**
```d
// Show placeholder, load actual image on demand
auto imageProxy = new VirtualProxy(() => loadFullResolution());
```

### 3. **API Rate Limiting**
```d
// Control API call frequency
class RateLimitingProxy : ProtectionProxy {
    // Check rate limits before allowing calls
}
```

### 4. **Security Gateway**
```d
// Authenticate and authorize before service access
auto gateway = new ProtectionProxy(service, isAuthenticated());
```

## Conclusion

The Proxy Pattern provides a flexible way to control object access and add functionality transparently. Whether you need lazy initialization, access control, caching, logging, or remote access, proxies offer a clean solution. The pattern is particularly useful when you need to add cross-cutting concerns without modifying the original object.

The implementation includes six proxy types (Virtual, Protection, Caching, Logging, Remote, Smart Reference) with comprehensive tests and real-world examples, ready for production use in the UIM OOP library.
