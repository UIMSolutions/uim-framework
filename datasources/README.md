# UIM DataSources - Data Source Management Library

Updated on 1. February 2026


A flexible, async-friendly data source management library for D language built with vibe.d. Provides abstraction for multiple data sources (Json, CSV, Database, REST APIs) with filtering, caching, and transformation capabilities.

## Overview

UIM DataSources provides a unified interface for working with multiple data sources. It abstracts away the complexity of different data formats and provides common operations like filtering, caching, and transformation.

## Key Features

### Core Capabilities
- **Multiple Sources**: Support for Json, CSV, Database, REST APIs, XML, YAML
- **Unified Interface**: IValueSource interface for all source types
- **Provider Pattern**: Manage multiple data sources through DataProvider
- **Async Operations**: All operations are asynchronous with vibe.d integration
- **Type Safe**: Leverages D's strong type system with Json serialization

### Advanced Features
- **Filtering**: Fluent query builder with multiple operators
- **Caching**: In-memory cache with TTL and LRU eviction
- **Transformation**: Field mapping and data transformation pipeline
- **Query Building**: Fluent API for building complex queries
- **Result Wrapping**: Standardized result objects with metadata

### Data Source Types
- **Json**: In-memory Json document storage
- **CSV**: Comma-separated values (interface, implementation extensible)
- **Database**: Database connectivity (interface, implementation extensible)
- **REST**: HTTP REST API endpoints (interface, implementation extensible)
- **XML/YAML**: Document formats (interface, implementation extensible)

## Installation

Add the dependency to your `dub.sdl`:

```d
dependency "uim-datasources" version="*"
```

## Quick Start

### Basic Data Source Usage

```d
import uim.datasources;

void main() {
    // Create a Json data source
    auto jsonSource = new JsonDataSource("users", [
        Json(["id": Json(1), "name": Json("Alice")]),
        Json(["id": Json(2), "name": Json("Bob")])
    ]);

    // Register with provider
    auto provider = new DataProvider();
    provider.registerSource("users", jsonSource);

    // Read data
    provider.fetch("users", (bool success, Json[] results) {
        if (success) {
            foreach (row; results) {
                writeln("User: ", row["name"].get!string);
            }
        }
    });
}
```

### Filtering Data

```d
auto filter = new DataFilter();
filter.where("age", FilterOperator.GreaterThan, Json(18))
      .and("status", FilterOperator.Equal, Json("active"))
      .orderBy("name", "ASC")
      .limit(10);

writeln(filter.toQueryString());
// Output: age > 18 AND status = active ORDER BY name ASC LIMIT 10
```

### Caching Results

```d
auto source = new JsonDataSource("products", products);
auto cachedSource = new CachedDataSource(source, 500); // 500 item cache

cachedSource.readAll((bool success, Json[] results) {
    // Results are cached automatically
    writeln("Cache hits: ", cachedSource._cache.getTotalHits());
});
```

### Data Transformation

```d
auto transformer = new DataTransformer();
transformer.addMapping("user_name", "name");
transformer.addMapping("user_email", "email");
transformer.addMappingWithTransformer(
    "price", 
    "formatted_price", 
    new NumberTransformer(2)  // 2 decimal places
);

auto result = transformer.transformRecord(Json(["user_name": Json("John")]));
writeln(result); // {"name": "John"}
```

## Core Components

### IValueSource Interface

```d
interface IValueSource {
    string name();
    DataSourceType type();
    bool isAvailable() @safe;
    
    void connect(void delegate(bool success) @safe callback) @trusted;
    void disconnect() @safe;
    void readAll(void delegate(bool success, Json[] results) @safe callback) @trusted;
    void read(string query, void delegate(bool success, Json[] results) @safe callback) @trusted;
    void write(Json data, void delegate(bool success, Json result) @safe callback) @trusted;
    void count(void delegate(bool success, long count) @safe callback) @trusted;
    
    string[string] schema();
}
```

### IValueProvider Interface

```d
interface IValueProvider {
    IValueProvider registerSource(string sourceName, IValueSource source);
    IValueSource getSource(string sourceName);
    bool hasSource(string sourceName);
    IValueSource[] getAllSources();
    
    void query(string sourceName, string query, void delegate(...) callback) @trusted;
    void fetch(string sourceName, void delegate(...) callback) @trusted;
    void persist(string sourceName, Json data, void delegate(...) callback) @trusted;
    
    bool areSourcesAvailable() @safe;
}
```

### IFilter Interface

```d
interface IFilter {
    IFilter where(string field, FilterOperator op, Json value);
    IFilter and(string field, FilterOperator op, Json value);
    IFilter or(string field, FilterOperator op, Json value);
    IFilter orderBy(string field, string direction = "ASC");
    IFilter limit(size_t count);
    IFilter offset(size_t count);
    
    Json toJson();
    string toQueryString();
    void reset();
}
```

## Filter Operators

```d
enum FilterOperator {
  Equal,              // =
  NotEqual,           // !=
  GreaterThan,        // >
  GreaterThanOrEqual, // >=
  LessThan,           // <
  LessThanOrEqual,    // <=
  In,                 // IN (array)
  NotIn,              // NOT IN
  Contains,           // LIKE %x%
  NotContains,        // NOT LIKE
  StartsWith,         // LIKE x%
  EndsWith,           // LIKE %x
  Between,            // BETWEEN x AND y
  IsNull,             // IS NULL
  IsNotNull           // IS NOT NULL
}
```

## Module Structure

```
uim.datasources
├── uim.datasources.interfaces    # Interface contracts
│   ├── datasource.d              # IValueSource, DataSourceType
│   ├── provider.d                # IValueProvider
│   └── filter.d                  # IFilter, FilterOperator
├── uim.datasources.providers     # Data source implementations
│   └── base.d                    # BaseDataSource, JsonDataSource, DataProvider
├── uim.datasources.queries       # Query building
│   └── filter.d                  # DataFilter, FilterCondition
├── uim.datasources.transforms    # Data transformation
│   └── transformer.d             # DataTransformer, field mapping
├── uim.datasources.cache         # Caching layer
│   └── cache.d                   # DataCache, CachedDataSource
└── uim.datasources.helpers       # Utility functions
```

## Usage Examples

### Example 1: User Management System

```d
class UserDataManager {
    private DataProvider _provider;
    private DataCache _cache;

    this() {
        _provider = new DataProvider();
        _cache = new DataCache(100);

        auto usersSource = new JsonDataSource("users", []);
        _provider.registerSource("users", usersSource);
    }

    void getActiveUsers(void delegate(bool, Json[]) @safe callback) @trusted {
        auto filter = new DataFilter();
        filter.where("status", FilterOperator.Equal, Json("active"))
              .orderBy("created_at", "DESC");

        _provider.query("users", filter.toQueryString(), callback);
    }

    void addUser(Json userData, void delegate(bool, Json) @safe callback) @trusted {
        _provider.persist("users", userData, (bool success, Json result) {
            if (success) {
                _cache.clear(); // Invalidate cache
            }
            callback(success, result);
        });
    }
}
```

### Example 2: Product Search with Caching

```d
class ProductRepository {
    private IValueSource _source;

    this() {
        auto source = new JsonDataSource("products", loadProducts());
        _source = new CachedDataSource(source, 1000);
    }

    void searchByPrice(double minPrice, double maxPrice, 
                      void delegate(bool, Json[]) @safe callback) @trusted {
        auto filter = new DataFilter();
        filter.where("price", FilterOperator.GreaterThanOrEqual, Json(minPrice))
              .and("price", FilterOperator.LessThanOrEqual, Json(maxPrice))
              .limit(50);

        _source.read(filter.toQueryString(), callback);
    }
}
```

### Example 3: Data Transformation Pipeline

```d
class OrderDataProcessor {
    private DataTransformer _transformer;

    this() {
        _transformer = new DataTransformer();
        
        // Map database columns to API fields
        _transformer.addMapping("order_id", "id");
        _transformer.addMapping("customer_name", "name");
        _transformer.addMappingWithTransformer(
            "total_amount",
            "formatted_total",
            new NumberTransformer(2)
        );
    }

    Json[] processOrders(Json[] rawOrders) {
        return _transformer.transformRecords(rawOrders);
    }
}
```

## Design Patterns

### 1. **Abstract Factory Pattern**
   - IValueSource interface for creating different source types
   - Factory methods in DataProvider

### 2. **Adapter Pattern**
   - Different data sources adapted through IValueSource interface
   - CachedDataSource wraps any IValueSource

### 3. **Strategy Pattern**
   - Different transformers implement ITransformer
   - Filter operators as strategies

### 4. **Decorator Pattern**
   - CachedDataSource decorates IValueSource with caching

### 5. **Repository Pattern**
   - DataProvider acts as repository for multiple sources

## Performance Considerations

1. **Caching**: LRU eviction with configurable max size
2. **Lazy Evaluation**: Filters only evaluate needed conditions
3. **Async Operations**: Non-blocking with vibe.d
4. **Memory Efficient**: Streaming-based where possible
5. **TTL Support**: Automatic cache expiration

## Extension Points

### Adding Custom Data Source

```d
class CustomDataSource : BaseDataSource {
    this(string name) {
        super(name, DataSourceType.Json);
    }

    override void connect(void delegate(bool success) @safe callback) @trusted {
        // Connection logic
        callback(true);
    }

    override void readAll(void delegate(bool success, Json[] results) @safe callback) @trusted {
        // Read logic
        callback(true, results);
    }

    // Implement other abstract methods...
}
```

### Custom Transformers

```d
class CustomTransformer : UIMObject, ITransformer {
    Json transform(Json value) {
        // Custom transformation logic
        return value;
    }

    Json[] transformArray(Json[] values) {
        // Batch transformation
        return values;
    }
}
```

## Thread Safety

Framework is async-safe with vibe.d's task system. For multi-threaded environments:
- Use separate source instances per thread
- Synchronize access to shared DataProvider
- Leverage vibe.d's fiber-based concurrency

## Dependencies

- **uim-core**: Core framework utilities
- **uim-oop**: Object-oriented patterns
- **uim-entities**: Entity support
- **vibe-d**: Async I/O framework (v0.9.6+)

## Future Enhancements

Planned features:
- Connection pooling for database sources
- REST API client implementation
- CSV file reading/writing
- XML/YAML parsing
- Query optimization
- Batch operations
- Transaction support
- Full-text search
- GraphQL support
