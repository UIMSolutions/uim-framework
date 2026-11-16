# Business Delegate Pattern

## Overview

The **Business Delegate Pattern** is a J2EE design pattern that provides an abstraction layer between the presentation tier and business tier. It decouples the presentation and business tiers, reducing coupling and hiding the implementation details of business services.

## Purpose

- **Decoupling**: Separates presentation layer from business service implementation
- **Abstraction**: Hides business service lookup complexity and implementation details
- **Performance**: Enables caching and reduces network calls
- **Flexibility**: Makes it easy to change or replace business services
- **Reusability**: Provides a single entry point for accessing business services

## Structure

```
┌──────────────────┐
│     Client       │
│ (Presentation)   │
└────────┬─────────┘
         │ uses
         ▼
┌──────────────────┐
│ Business Delegate│ ◄──► ┌──────────────────┐
│                  │      │ Business Lookup  │
└────────┬─────────┘      │   Service        │
         │ delegates      └────────┬─────────┘
         ▼                         │ locates
┌──────────────────┐              ▼
│ Business Service │ ◄─────────────┐
│                  │                │
└──────────────────┘                │
         ▲                          │
         │ implements               │
    ┌────┴──────┬──────────┐       │
    │           │          │       │
┌───▼────┐ ┌───▼────┐ ┌───▼────┐  │
│  EJB   │ │  JMS   │ │  REST  │  │
│Service │ │Service │ │Service │◄─┘
└────────┘ └────────┘ └────────┘
```

## Components

### 1. Interfaces

#### `IBusinessService`
Base interface for all business services:
- `execute()` - Execute business operation
- `serviceName()` - Get service name

#### `IBusinessLookup`
Service registry and lookup interface:
- `getBusinessService(name)` - Look up service by name
- `registerService(name, service)` - Register a service
- `hasService(name)` - Check if service exists
- `removeService(name)` - Remove a service

#### `IBusinessDelegate`
Delegate interface for client interaction:
- `doTask()` - Execute business operation
- `serviceType()` - Get service type

#### `IGenericBusinessDelegate<TInput, TOutput>`
Generic delegate with typed operations:
- `doTask(input)` - Execute with typed input/output

#### `ICacheableBusinessDelegate`
Adds caching capabilities:
- `enableCache()` / `disableCache()` - Control caching
- `clearCache()` - Clear cached data
- `isCacheEnabled()` - Check cache status

#### `IRetryableBusinessDelegate`
Adds retry logic:
- `setMaxRetries(attempts)` - Configure retries
- `retryCount()` - Get retry count

### 2. Core Classes

#### `BusinessLookup`
Service registry implementation that manages service registration and lookup.

#### `BusinessDelegate`
Basic delegate implementation that forwards requests to business services through the lookup service.

#### `CacheableBusinessDelegate`
Decorator that adds caching to delegate operations for improved performance.

#### `RetryableBusinessDelegate`
Decorator that automatically retries failed operations with configurable retry logic.

#### `LoggingBusinessDelegate`
Decorator that adds logging capabilities to track delegate operations.

#### `CompositeBusinessDelegate`
Composite that can delegate to multiple services and combine their results.

### 3. Business Services

#### `EJBService`
Simulates Enterprise JavaBeans-style business service.

#### `JMSService`
Simulates Java Message Service-style messaging service.

#### `RESTService`
Simulates RESTful web service operations.

#### `DatabaseService`
Simulates database operations.

#### `EmailService`
Handles email operations.

#### `AuthenticationService`
Provides authentication functionality.

#### `PaymentService`
Processes payment transactions.

#### `LoggingService`
Provides logging functionality.

#### `CalculationService`
Generic calculation service with typed operations.

## Usage Examples

### Basic Business Delegate

```d
import uim.oop.patterns.delegates;

// Create lookup service
auto lookup = new BusinessLookup();

// Register business service
auto ejbService = new EJBService("EJB Processing Complete");
lookup.registerService("EJB", ejbService);

// Create delegate
auto delegate_ = new BusinessDelegate(lookup, "EJB");

// Execute through delegate
string result = delegate_.doTask();
// Output: "EJB Processing Complete"
```

### Multiple Services with Lookup

```d
// Register multiple services
auto lookup = new BusinessLookup();
lookup.registerService("EJB", new EJBService("EJB Response"));
lookup.registerService("JMS", new JMSService("JMS Response"));
lookup.registerService("REST", new RESTService("/api/users", "GET"));

// Create delegates for each service
auto ejbDelegate = new BusinessDelegate(lookup, "EJB");
auto jmsDelegate = new BusinessDelegate(lookup, "JMS");
auto restDelegate = new BusinessDelegate(lookup, "REST");

// Use delegates
writeln(ejbDelegate.doTask());   // "EJB Response"
writeln(jmsDelegate.doTask());   // "JMS Response"
writeln(restDelegate.doTask());  // "REST GET /api/users: Success"
```

### Cacheable Business Delegate

```d
auto lookup = new BusinessLookup();
auto service = new DatabaseService("SELECT * FROM users");
lookup.registerService("DB", service);

// Create cacheable delegate
auto cacheableDelegate = new CacheableBusinessDelegate(lookup, "DB");

// First call - executes service
string result1 = cacheableDelegate.doTask();

// Second call - returns cached result (faster)
string result2 = cacheableDelegate.doTask();

// Clear cache when needed
cacheableDelegate.clearCache();

// Disable caching temporarily
cacheableDelegate.disableCache();
```

### Retryable Business Delegate

```d
auto lookup = new BusinessLookup();
auto service = new RESTService("/api/data", "GET");
lookup.registerService("REST", service);

// Create delegate with retry logic (max 3 retries)
auto retryDelegate = new RetryableBusinessDelegate(lookup, "REST", 3);

// Executes with automatic retry on failure
string result = retryDelegate.doTask();

// Check how many retries were performed
int retries = retryDelegate.retryCount();

// Change max retries
retryDelegate.setMaxRetries(5);
```

### Logging Business Delegate

```d
auto lookup = new BusinessLookup();
auto service = new EmailService("user@example.com", "Welcome");
lookup.registerService("Email", service);

// Create logging delegate
auto loggingDelegate = new LoggingBusinessDelegate(lookup, "Email");

// Execute with automatic logging
string result = loggingDelegate.doTask();

// View logs
auto logs = loggingDelegate.logs();
foreach (log; logs) {
    writeln(log);
}

// Clear logs
loggingDelegate.clearLogs();

// Disable logging
loggingDelegate.setLoggingEnabled(false);
```

### Composite Business Delegate

```d
auto lookup = new BusinessLookup();

// Register multiple services
lookup.registerService("Auth", new AuthenticationService(...));
lookup.registerService("Payment", new PaymentService());
lookup.registerService("Email", new EmailService(...));

// Create composite delegate
auto composite = new CompositeBusinessDelegate("OrderProcessing");

// Add multiple delegates
composite.addDelegate(new BusinessDelegate(lookup, "Auth"));
composite.addDelegate(new BusinessDelegate(lookup, "Payment"));
composite.addDelegate(new BusinessDelegate(lookup, "Email"));

// Execute all delegates and combine results
string result = composite.doTask();
// Output: "Auth result | Payment result | Email result"
```

### Generic Business Delegate

```d
// Create calculation service
auto calcService = new CalculationService("sum");

// Create generic delegate with typed operations
auto delegate_ = new GenericBusinessDelegate!(double[], double)(
    calcService, 
    "Calculator"
);

// Execute with typed input/output
double result = delegate_.doTask([10.0, 20.0, 30.0]);
// Output: 60.0 (sum)
```

### Real-World E-Commerce Example

```d
// Setup business services
auto lookup = new BusinessLookup();
lookup.registerService("Auth", new AuthenticationService(...));
lookup.registerService("Inventory", new DatabaseService("SELECT stock FROM inventory"));
lookup.registerService("Payment", new PaymentService());
lookup.registerService("Shipping", new RESTService("/api/shipping", "POST"));
lookup.registerService("Email", new EmailService(...));

// Create specialized delegates
auto authDelegate = new BusinessDelegate(lookup, "Auth");
auto inventoryDelegate = new CacheableBusinessDelegate(lookup, "Inventory");
auto paymentDelegate = new RetryableBusinessDelegate(lookup, "Payment", 3);
auto shippingDelegate = new LoggingBusinessDelegate(lookup, "Shipping");
auto emailDelegate = new BusinessDelegate(lookup, "Email");

// Process order workflow
class OrderProcessor {
    private IBusinessDelegate _auth;
    private IBusinessDelegate _inventory;
    private IBusinessDelegate _payment;
    private IBusinessDelegate _shipping;
    private IBusinessDelegate _email;

    this(/* delegates */) {
        // Initialize delegates
    }

    string processOrder() {
        // 1. Authenticate
        string authResult = _auth.doTask();
        if (authResult.indexOf("failed") >= 0) {
            return "Authentication failed";
        }

        // 2. Check inventory (cached)
        string inventoryResult = _inventory.doTask();

        // 3. Process payment (with retries)
        string paymentResult = _payment.doTask();

        // 4. Arrange shipping (logged)
        string shippingResult = _shipping.doTask();

        // 5. Send confirmation email
        string emailResult = _email.doTask();

        return "Order processed successfully";
    }
}
```

## Benefits

### 1. **Loose Coupling**
Presentation tier doesn't depend directly on business service implementations.

### 2. **Flexibility**
Easy to switch between different service implementations:

```d
// Replace service without changing client code
lookup.registerService("Payment", new PayPalService());
// or
lookup.registerService("Payment", new StripeService());
```

### 3. **Performance Optimization**
Cache frequently accessed data:

```d
auto cachedDelegate = new CacheableBusinessDelegate(lookup, "ProductCatalog");
// Subsequent calls are served from cache
```

### 4. **Simplified Client Code**
Clients don't need to handle:
- Service lookup complexity
- Network communication details
- Retry logic
- Caching strategies

### 5. **Testability**
Easy to mock services for testing:

```d
// For testing, register mock services
lookup.registerService("Payment", new MockPaymentService());
```

### 6. **Composability**
Combine multiple delegates with decorators:

```d
// Cached + Logged + Retryable
auto baseDelegate = new BusinessDelegate(lookup, "API");
auto cachedDelegate = new CacheableBusinessDelegate(lookup, "API");
auto loggingDelegate = new LoggingBusinessDelegate(lookup, "API");
```

## Design Patterns Used

The Business Delegate pattern incorporates several other patterns:

- **Service Locator**: `BusinessLookup` for service discovery
- **Decorator**: `CacheableBusinessDelegate`, `RetryableBusinessDelegate`, `LoggingBusinessDelegate`
- **Composite**: `CompositeBusinessDelegate` for multiple services
- **Facade**: Simplified interface to complex subsystems

## Best Practices

### 1. **Use Service Lookup**
Always access services through the lookup service:

```d
// Good
auto service = lookup.getBusinessService("ServiceName");

// Avoid direct instantiation in delegates
// auto service = new ConcreteService(); // Don't do this
```

### 2. **Cache Appropriate Data**
Only cache stable, frequently accessed data:

```d
// Good for caching
auto catalogDelegate = new CacheableBusinessDelegate(lookup, "ProductCatalog");

// Bad for caching (constantly changing)
// auto stockDelegate = new CacheableBusinessDelegate(lookup, "LiveStock");
```

### 3. **Handle Service Unavailability**
Always check for service availability:

```d
string result = delegate_.doTask();
if (result.startsWith("Error:")) {
    // Handle error
}
```

### 4. **Use Retries Wisely**
Configure appropriate retry counts:

```d
// Network calls: more retries
auto remoteDelegate = new RetryableBusinessDelegate(lookup, "RemoteAPI", 5);

// Local operations: fewer retries
auto localDelegate = new RetryableBusinessDelegate(lookup, "LocalDB", 2);
```

### 5. **Log Important Operations**
Use logging for critical operations:

```d
auto criticalDelegate = new LoggingBusinessDelegate(lookup, "PaymentGateway");
```

## Performance Considerations

### Caching
- **Cache Hit**: O(1) - Instant return
- **Cache Miss**: O(n) - Service execution time
- **Memory**: O(k) where k is cached entries

### Service Lookup
- **Registration**: O(1) - Associative array insert
- **Lookup**: O(1) - Associative array lookup
- **Removal**: O(1) - Associative array delete

### Retry Logic
- **Best Case**: O(1) - Success on first attempt
- **Worst Case**: O(n) - n retry attempts
- **Average**: Depends on service reliability

## Related Patterns

- **Service Locator**: Used by Business Lookup
- **Session Facade**: Similar purpose, different implementation
- **Transfer Object**: Often used with Business Delegate
- **Decorator**: For adding features to delegates
- **Proxy**: Similar structure, different intent

## Thread Safety

The current implementation is **not thread-safe**. For concurrent access:
- Add synchronization to `BusinessLookup`
- Use thread-safe cache implementations
- Consider immutable delegates

## Testing

Comprehensive unit tests are included:

```bash
# Run all tests
dub test

# Run pattern tests
cd oop
dub test
```

## Common Use Cases

### 1. **Web Applications**
Separate web layer from business logic layer.

### 2. **Microservices**
Delegate to different microservices through unified interface.

### 3. **SOA (Service-Oriented Architecture)**
Access different services through consistent delegate interface.

### 4. **Legacy System Integration**
Wrap legacy systems behind delegate interface.

### 5. **Multi-Tier Applications**
Decouple presentation, business, and data tiers.

## Conclusion

The Business Delegate pattern is essential for:
- Enterprise applications with multiple tiers
- Systems requiring service flexibility
- Applications needing performance optimization through caching
- Projects requiring clean separation of concerns

Use `BusinessDelegate` for basic delegation, add `CacheableBusinessDelegate` for performance, `RetryableBusinessDelegate` for reliability, and `CompositeBusinessDelegate` for complex workflows.

---

**Implementation Status**: ✅ Complete  
**Test Coverage**: ✅ Comprehensive  
**Documentation**: ✅ Full

**Author**: Ozan Nurettin Süel (UIManufaktur)  
**License**: Apache 2.0  
**Version**: 1.0.0
