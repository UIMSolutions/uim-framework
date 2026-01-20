# UIM OData Library

OData (Open Data Protocol) client and server library for the UIM framework providing comprehensive support for building and consuming RESTful APIs following the OData standard.

## Overview

OData is an open protocol that allows the creation and consumption of queryable and interoperable RESTful APIs in a simple and standard way. This library provides:

- OData query builder with full query syntax support
- Entity and entity set support
- Filter expressions (eq, ne, gt, lt, ge, le, and, or, not)
- Ordering ($orderby), pagination ($top, $skip)
- Field selection ($select) and expansion ($expand)
- Metadata document support
- JSON format support (OData v4)
- Type-safe query construction
- Client and server utilities

## Features

- **Query Builder**: Fluent API for building OData queries
- **Filter Support**: Complex filter expressions with operators
- **Navigation**: Entity relationships and $expand support
- **Pagination**: $top and $skip for data pagination
- **Sorting**: $orderby with ascending/descending
- **Selection**: $select for field filtering
- **Count**: $count support for total records
- **Metadata**: Service metadata document handling
- **Type Safety**: Strong typing throughout the API
- **JSON Format**: OData JSON format support

## Usage

### Basic Query Building

```d
import uim.odata;

// Create a query builder
auto query = new ODataQueryBuilder("Products");

// Build a simple query
query.filter("Price gt 20")
     .orderBy("Name")
     .top(10)
     .skip(0);

string url = query.build();
// Result: Products?$filter=Price gt 20&$orderby=Name&$top=10&$skip=0
```

### Filter Expressions

```d
auto query = new ODataQueryBuilder("Customers");

// Simple filters
query.filter("Country eq 'USA'");

// Complex filters
query.filter("Age gt 18 and City eq 'New York'");

// Multiple conditions
auto filter = new ODataFilter();
filter.equals("Status", "Active")
      .and()
      .greaterThan("Score", 50);
      
query.filter(filter.build());
```

### Selection and Expansion

```d
auto query = new ODataQueryBuilder("Orders");

// Select specific fields
query.select(["OrderID", "OrderDate", "TotalAmount"]);

// Expand related entities
query.expand("Customer")
     .expand("OrderDetails");

string url = query.build();
// Result: Orders?$select=OrderID,OrderDate,TotalAmount&$expand=Customer,OrderDetails
```

### Ordering and Pagination

```d
auto query = new ODataQueryBuilder("Products");

// Order by single field
query.orderBy("Name");

// Order by multiple fields with direction
query.orderBy("Category asc, Price desc");

// Pagination
query.top(20)    // Take 20 items
     .skip(40);  // Skip first 40 items
```

### OData Client

```d
// Create a client
auto client = new ODataClient("https://services.odata.org/V4/Northwind/Northwind.svc/");

// Query entities
auto products = client.query("Products")
                      .filter("Price lt 50")
                      .top(10)
                      .execute();

// Get single entity by key
auto product = client.get("Products", "5");

// Create entity
client.create("Products", productData);

// Update entity
client.update("Products", "5", updatedData);

// Delete entity
client.delete_("Products", "5");
```

### OData Entity

```d
// Define an entity
auto product = new ODataEntity("Products");
product.set("ProductID", 1);
product.set("ProductName", "Chai");
product.set("UnitPrice", 18.0);
product.set("UnitsInStock", 39);

// Convert to JSON
string json = product.toJSON();

// Create from JSON
auto loaded = ODataEntity.fromJSON(json);
```

### Filter Builder

```d
auto filter = new ODataFilter();

// Comparison operators
filter.equals("Status", "Active")
      .and()
      .greaterThan("Age", 18);

// String functions
filter.startsWith("Name", "A")
      .or()
      .contains("Description", "special");

// Date functions
filter.year("BirthDate").equals(1990);

// Collection operators
filter.any("Orders", "o", "o/Amount gt 100");

string filterString = filter.build();
// Result: Status eq 'Active' and Age gt 18
```

## API Reference

### ODataQueryBuilder

Main class for building OData queries.

#### Methods

- `filter(string expression)` - Add $filter clause
- `orderBy(string fields)` - Add $orderby clause
- `top(int count)` - Add $top clause
- `skip(int count)` - Add $skip clause
- `select(string[] fields)` - Add $select clause
- `expand(string navigation)` - Add $expand clause
- `count(bool include)` - Add $count parameter
- `build()` - Build the query URL
- `buildRelative()` - Build relative URL (without base)

### ODataFilter

Builder for complex filter expressions.

#### Methods

- `equals(string field, T value)` - Field equals value
- `notEquals(string field, T value)` - Field not equals value
- `greaterThan(string field, T value)` - Field greater than value
- `lessThan(string field, T value)` - Field less than value
- `greaterOrEqual(string field, T value)` - Field >= value
- `lessOrEqual(string field, T value)` - Field <= value
- `and()` - Logical AND operator
- `or()` - Logical OR operator
- `not()` - Logical NOT operator
- `contains(string field, string value)` - String contains
- `startsWith(string field, string value)` - String starts with
- `endsWith(string field, string value)` - String ends with
- `any(string collection, string alias, string condition)` - Any operator
- `all(string collection, string alias, string condition)` - All operator

### ODataClient

HTTP client for OData services.

#### Methods

- `query(string entitySet)` - Start a query
- `get(string entitySet, string key)` - Get entity by key
- `create(string entitySet, string data)` - Create new entity
- `update(string entitySet, string key, string data)` - Update entity
- `delete_(string entitySet, string key)` - Delete entity
- `getMetadata()` - Get service metadata

### ODataEntity

Represents an OData entity.

#### Methods

- `set(string field, T value)` - Set field value
- `get(string field)` - Get field value
- `has(string field)` - Check if field exists
- `remove(string field)` - Remove field
- `toJSON()` - Convert to JSON
- `static fromJSON(string json)` - Parse from JSON

## Examples

See the `examples/` directory for complete examples:

- `examples/query_builder.d` - Query building examples
- `examples/filter_expressions.d` - Complex filter examples
- `examples/odata_client.d` - HTTP client usage

## OData Specification

This library implements OData v4 specification:
- [OData v4 Protocol](https://www.odata.org/documentation/)
- [OData URL Conventions](https://docs.oasis-open.org/odata/odata/v4.01/odata-v4.01-part2-url-conventions.html)

## Testing

Run the test suite:

```bash
dub test
```

## License

Apache-2.0 - See LICENSE.txt file for details

## Author

Ozan Nurettin Süel (UIManufaktur)
