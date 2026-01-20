# UIM-JSONLD - JSON-LD Library

**Version**: 1.0.0  
**Author**: Ozan Nurettin Süel (aka UIManufaktur)  
**License**: Apache 2.0  
**Language**: D

## Overview

UIM-JSONLD is a comprehensive JSON-LD (JSON for Linking Data) library for the D programming language. It provides tools for creating, parsing, and manipulating JSON-LD documents with support for contexts, graphs, and semantic web features.

## Features

- **Context Management**: Define and manage @context with vocabularies, terms, and prefixes
- **Node Objects**: Create and manipulate JSON-LD nodes with IDs, types, and properties
- **Graph Support**: Build and manage graphs containing multiple nodes
- **Document Structure**: Complete JSON-LD document with context and graph
- **Fluent Builder API**: Easy-to-use chainable interface
- **Type Safety**: Strongly typed D implementation
- **Standard Compliant**: Follows JSON-LD 1.1 specification
- **File I/O**: Load and save JSON-LD documents

## Installation

Add to your `dub.sdl`:

```sdl
dependency "uim-jsonld" path="../jsonld"
```

## JSON-LD Overview

JSON-LD is a lightweight Linked Data format that extends JSON with semantic annotations. It uses special keywords prefixed with `@` to add structured data capabilities.

### Key Concepts

- **@context**: Defines how terms map to IRIs
- **@id**: Unique identifier for a node
- **@type**: Type(s) of a node
- **@graph**: Collection of nodes
- **@vocab**: Default vocabulary for terms

## Usage Examples

### Creating a Simple Person Document

```d
import uim.jsons;

auto doc = new DJSONLDDocument();

// Set vocabulary
doc.context.vocab("http://schema.org/");

// Create a person node
auto person = new DJSONLDNode("http://example.com/person/john");
person.addType("Person");
person.set("name", "John Doe");
person.set("email", "john@example.com");
person.set("age", 30);

doc.addNode(person);

// Output JSON-LD
writeln(doc.toString());

/* Output:
{
  "@context": {
    "@vocab": "http://schema.org/"
  },
  "@id": "http://example.com/person/john",
  "@type": "Person",
  "name": "John Doe",
  "email": "john@example.com",
  "age": 30
}
*/
```

### Using the Fluent Builder API

```d
import uim.jsons;

auto doc = jsonld()
  .vocab("http://schema.org/")
  .node("http://example.com/person/john")
    .type("Person")
    .property("name", "John Doe")
    .property("email", "john@example.com")
    .property("age", 30)
  .build();

writeln(doc.toString());
```

### Working with Context

```d
import uim.jsons;

// Create context
auto ctx = new DJSONLDContext();

// Set vocabulary
ctx.vocab("http://schema.org/");

// Add custom terms
ctx.addTerm("name", "http://schema.org/name");
ctx.addTerm("email", "http://schema.org/email");

// Add prefixes
ctx.addPrefix("ex", "http://example.com/");
ctx.addPrefix("foaf", "http://xmlns.com/foaf/0.1/");

// Expand terms
writeln(ctx.expand("name"));  // http://schema.org/name
writeln(ctx.expand("ex:person"));  // http://example.com/person
writeln(ctx.expand("foaf:Person"));  // http://xmlns.com/foaf/0.1/Person
```

### Multiple Nodes and Graphs

```d
import uim.jsons;

auto doc = jsonld()
  .vocab("http://schema.org/")
  
  // First person
  .node("http://example.com/person/john")
    .type("Person")
    .property("name", "John Doe")
    .property("knows", Json("http://example.com/person/jane"))
  
  // Second person
  .node("http://example.com/person/jane")
    .type("Person")
    .property("name", "Jane Smith")
  
  .build();

writeln(doc.toString());

/* Output:
{
  "@context": {
    "@vocab": "http://schema.org/"
  },
  "@graph": [
    {
      "@id": "http://example.com/person/john",
      "@type": "Person",
      "name": "John Doe",
      "knows": "http://example.com/person/jane"
    },
    {
      "@id": "http://example.com/person/jane",
      "@type": "Person",
      "name": "Jane Smith"
    }
  ]
}
*/
```

### Schema.org Example: Product

```d
import uim.jsons;

auto product = jsonld()
  .vocab("http://schema.org/")
  .node("http://example.com/product/12345")
    .type("Product")
    .property("name", "Wireless Headphones")
    .property("description", "High-quality wireless headphones with noise cancellation")
    .property("brand", Json.emptyObject
      .set("@type", "Brand")
      .set("name", "AudioTech"))
    .property("offers", Json.emptyObject
      .set("@type", "Offer")
      .set("price", "99.99")
      .set("priceCurrency", "USD"))
  .build();

writeln(product.toString());
```

### Working with Multiple Types

```d
import uim.jsons;

auto node = new DJSONLDNode("http://example.com/resource");
node.addType("http://schema.org/Person");
node.addType("http://schema.org/Artist");
node.addType("http://xmlns.com/foaf/0.1/Agent");

node.set("name", "Leonardo da Vinci");

/* Produces:
{
  "@id": "http://example.com/resource",
  "@type": ["http://schema.org/Person", "http://schema.org/Artist", "http://xmlns.com/foaf/0.1/Agent"],
  "name": "Leonardo da Vinci"
}
*/
```

### Parsing JSON-LD Documents

```d
import uim.jsons;

string jsonldStr = `{
  "@context": {
    "@vocab": "http://schema.org/"
  },
  "@id": "http://example.com/person/john",
  "@type": "Person",
  "name": "John Doe",
  "email": "john@example.com"
}`;

auto doc = DJSONLDDocument.parse(jsonldStr);

auto person = doc.graph.nodes()[0];
writeln("Name: ", person.get("name").get!string);
writeln("Email: ", person.get("email").get!string);
```

### Working with Graphs Directly

```d
import uim.jsons;

auto graph = new DJSONLDGraph("http://example.com/graph1");

// Add multiple nodes
auto alice = new DJSONLDNode("http://example.com/alice");
alice.addType("http://schema.org/Person");
alice.set("name", "Alice");
graph.addNode(alice);

auto bob = new DJSONLDNode("http://example.com/bob");
bob.addType("http://schema.org/Person");
bob.set("name", "Bob");
graph.addNode(bob);

// Find nodes by type
auto people = graph.findByType("http://schema.org/Person");
writeln("Found ", people.length, " people");

// Check if node exists
if (graph.hasNode("http://example.com/alice")) {
    auto node = graph.getNode("http://example.com/alice");
    writeln(node.get("name").get!string);
}
```

### File Operations

```d
import uim.jsons;

// Create document
auto doc = jsonld()
  .vocab("http://schema.org/")
  .node("http://example.com/person/1")
    .type("Person")
    .property("name", "John Doe")
  .build();

// Save to file
doc.saveFile("person.jsonld");

// Load from file
auto loaded = DJSONLDDocument.loadFile("person.jsonld");
writeln(loaded.toString());
```

### Context with Custom Prefixes

```d
import uim.jsons;

auto doc = jsonld()
  .prefix("schema", "http://schema.org/")
  .prefix("ex", "http://example.com/")
  .prefix("foaf", "http://xmlns.com/foaf/0.1/")
  
  .node("ex:john")
    .type("schema:Person")
    .property("foaf:name", "John Doe")
  .build();

/* Produces:
{
  "@context": {
    "schema": "http://schema.org/",
    "ex": "http://example.com/",
    "foaf": "http://xmlns.com/foaf/0.1/"
  },
  "@id": "ex:john",
  "@type": "schema:Person",
  "foaf:name": "John Doe"
}
*/
```

### Blank Nodes

```d
import uim.jsons;

auto doc = jsonld()
  .vocab("http://schema.org/")
  
  // Node with ID
  .node("http://example.com/person/john")
    .type("Person")
    .property("name", "John Doe")
  
  // Blank node (auto-generated ID)
  .node()
    .type("Address")
    .property("streetAddress", "123 Main St")
    .property("addressLocality", "Springfield")
  
  .build();

// Blank node will have ID like "_:b0"
```

### Complete Example: Organization with Employees

```d
import uim.jsons;

auto org = jsonld()
  .vocab("http://schema.org/")
  .prefix("ex", "http://example.com/")
  
  // Organization
  .node("ex:acme-corp")
    .type("Organization")
    .property("name", "ACME Corporation")
    .property("url", "http://example.com")
  
  // CEO
  .node("ex:person/jane")
    .type("Person")
    .property("name", "Jane Smith")
    .property("jobTitle", "CEO")
    .property("worksFor", Json("ex:acme-corp"))
  
  // CTO
  .node("ex:person/john")
    .type("Person")
    .property("name", "John Doe")
    .property("jobTitle", "CTO")
    .property("worksFor", Json("ex:acme-corp"))
  
  .build();

writeln(org.toString());
```

### Accessing Node Properties

```d
import uim.jsons;

auto person = new DJSONLDNode("http://example.com/person/1");
person.set("name", "John Doe");
person.set("age", 30);
person.set("active", true);

// Check property existence
if (person.has("name")) {
    string name = person.get("name").get!string;
    writeln("Name: ", name);
}

// Get all property names
foreach (propName; person.propertyNames()) {
    writeln(propName, ": ", person.get(propName));
}

// Type conversions
long age = person.get("age").get!long;
bool active = person.get("active").get!bool;
```

### Error Handling

```d
import uim.jsons;

try {
    auto doc = DJSONLDDocument.loadFile("config.jsonld");
    
    auto node = doc.graph.getNode("http://example.com/missing");
    if (node is null) {
        writeln("Node not found");
    }
    
} catch (JSONLDException e) {
    writeln("JSON-LD error: ", e.msg);
} catch (InvalidDocumentException e) {
    writeln("Invalid document: ", e.msg);
} catch (ContextException e) {
    writeln("Context error: ", e.msg);
}
```

## API Reference

### DJSONLDDocument
- `context()` / `context(DJSONLDContext)` - Get/set context
- `graph()` / `graph(DJSONLDGraph)` - Get/set graph
- `addNode(DJSONLDNode)` - Add node to document
- `getNode(string id)` - Get node by ID
- `toJson()` - Convert to JSON
- `toString()` - Pretty print
- `parse(string)` - Parse from JSON string
- `loadFile(string)` / `saveFile(string)` - File I/O

### DJSONLDContext
- `vocab()` / `vocab(string)` - Get/set vocabulary
- `base()` / `base(string)` - Get/set base IRI
- `addTerm(string, string)` - Add term mapping
- `addPrefix(string, string)` - Add prefix mapping
- `expand(string)` - Expand compact IRI
- `hasTerm(string)` - Check term existence
- `merge(DJSONLDContext)` - Merge contexts

### DJSONLDNode
- `id()` / `id(string)` - Get/set node ID
- `types()` - Get all types
- `addType(string)` - Add type
- `set(string, Json)` - Set property
- `get(string)` - Get property value
- `has(string)` - Check property existence
- `propertyNames()` - Get all property names
- `toJson()` / `fromJson(Json)` - JSON conversion

### DJSONLDGraph
- `id()` / `id(string)` - Get/set graph ID
- `addNode(DJSONLDNode)` - Add node
- `getNode(string)` - Get node by ID
- `hasNode(string)` - Check node existence
- `removeNode(string)` - Remove node
- `nodeIds()` - Get all node IDs
- `nodes()` - Get all nodes
- `findByType(string)` - Find nodes by type
- `count()` - Get node count

### DJSONLDBuilder
- `vocab(string)` - Set vocabulary
- `base(string)` - Set base IRI
- `term(string, string)` - Add term
- `prefix(string, string)` - Add prefix
- `node(string)` - Start new node
- `type(string)` - Add type to current node
- `property(string, value)` - Add property
- `build()` - Build document

## JSON-LD Keywords

- `@context` - Context definition
- `@id` - Node identifier
- `@type` - Node type(s)
- `@value` - Literal value
- `@language` - Language tag
- `@graph` - Node collection
- `@list` - Ordered collection
- `@set` - Unordered collection
- `@reverse` - Reverse properties
- `@vocab` - Default vocabulary
- `@base` - Base IRI

## XSD Datatypes

Commonly used XML Schema datatypes available via `XSDTypes`:
- `string`, `boolean`, `integer`, `double`, `float`
- `date`, `dateTime`, `time`
- `anyURI`

## Testing

```bash
cd jsonld
dub test
```

## License

Copyright © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)

Licensed under the Apache License, Version 2.0.

## Dependencies

- uim-oop - Object-oriented patterns
- uim-core - Core utilities
- uim-json - JSON processing

## Resources

- [JSON-LD 1.1 Specification](https://www.w3.org/TR/json-ld11/)
- [JSON-LD Playground](https://json-ld.org/playground/)
- [Schema.org](https://schema.org/)
- [Linked Data](https://www.w3.org/DesignIssues/LinkedData.html)
