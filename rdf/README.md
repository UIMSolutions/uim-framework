# UIM RDF Library

A D library for working with RDF (Resource Description Framework), the standard model for data interchange on the Semantic Web.

## Features

- **Complete RDF Support**: Full implementation of RDF triples, graphs, and nodes
- **Multiple Node Types**: URIs, Literals (typed and with language tags), and Blank Nodes
- **Graph Operations**: Add, remove, query, and manipulate RDF graphs
- **Multiple Serialization Formats**: N-Triples, Turtle, and RDF/XML
- **Common Namespaces**: Built-in support for RDF, RDFS, OWL, FOAF, Dublin Core, and more
- **Type-Safe**: Leverages D's strong type system for safe RDF operations
- **Standards Compliant**: Follows W3C RDF specifications

## Installation

Add to your `dub.sdl`:

```sdl
dependency "uim-framework:rdf" version="~>1.0.0"
```

Or in `dub.json`:

```json
{
  "dependencies": {
    "uim-framework:rdf": "~>1.0.0"
  }
}
```

## Quick Start

```d
import uim.rdf;
import std.stdio;

void main() {
    // Create a graph
    auto graph = new DRDFGraph();
  
    // Add namespaces
    graph.addNamespace(CommonNamespaces.FOAF());
  
    // Add triples
    string person = "http://example.org/alice";
    string foaf = "http://xmlns.com/foaf/0.1/";
  
    graph.addLiteral(person, foaf ~ "name", "Alice Johnson");
    graph.addTypedLiteral(person, foaf ~ "age", 30);
    graph.add(person, foaf ~ "knows", "http://example.org/bob");
  
    // Serialize to Turtle
    writeln(DTurtleSerializer.serialize(graph));
}
```

## Core Concepts

### RDF Triples

RDF data is represented as triples: **subject-predicate-object** statements.

```d
auto subject = new DRDFUri("http://example.org/John");
auto predicate = new DRDFUri("http://xmlns.com/foaf/0.1/knows");
auto object = new DRDFUri("http://example.org/Mary");

auto triple = new DRDFTriple(subject, predicate, object);
// Result: <http://example.org/John> <http://xmlns.com/foaf/0.1/knows> <http://example.org/Mary> .
```

### Node Types

#### URI Nodes

URIs identify resources:

```d
auto uri = new DRDFUri("http://example.org/resource");
```

#### Literal Nodes

Literals represent values:

```d
// Simple string literal
auto name = new DRDFLiteral("John Doe");

// Literal with language tag
auto nameDE = new DRDFLiteral("Johann Schmidt", "de");

// Typed literals
auto age = DRDFLiteral.typed(42);        // xsd:integer
auto height = DRDFLiteral.typed(1.85);   // xsd:double
auto active = DRDFLiteral.typed(true);   // xsd:boolean
```

#### Blank Nodes

Blank nodes for anonymous resources:

```d
auto blank = new DRDFBlankNode();           // Auto-generated ID
auto custom = new DRDFBlankNode("myId");    // Custom ID
```

### RDF Graphs

Graphs contain collections of triples:

```d
auto graph = new DRDFGraph("http://example.org/");

// Add triples in various ways
graph.add(subject, predicate, object);

// Add with literal object
graph.addLiteral("http://example.org/john",
                 "http://xmlns.com/foaf/0.1/name",
                 "John Smith");

// Add with typed literal
graph.addTypedLiteral("http://example.org/john",
                      "http://xmlns.com/foaf/0.1/age",
                      35);
```

### Namespaces

Use namespaces for cleaner URIs:

```d
auto graph = new DRDFGraph();
graph.addNamespace(CommonNamespaces.FOAF());
graph.addNamespace(CommonNamespaces.DC());

// Or define custom namespaces
graph.addNamespace("ex", "http://example.org/vocab/");
```

Available common namespaces:

- **RDF**: `http://www.w3.org/1999/02/22-rdf-syntax-ns#`
- **RDFS**: `http://www.w3.org/2000/01/rdf-schema#`
- **OWL**: `http://www.w3.org/2002/07/owl#`
- **XSD**: `http://www.w3.org/2001/XMLSchema#`
- **DC**: `http://purl.org/dc/elements/1.1/`
- **DCTERMS**: `http://purl.org/dc/terms/`
- **FOAF**: `http://xmlns.com/foaf/0.1/`
- **SKOS**: `http://www.w3.org/2004/02/skos/core#`

## Serialization Formats

### N-Triples

Simple line-based format:

```d
string ntriples = DNTriplesSerializer.serialize(graph);
```

Output:

```
<http://example.org/john> <http://xmlns.com/foaf/0.1/name> "John Smith" .
<http://example.org/john> <http://xmlns.com/foaf/0.1/age> "35"^^<http://www.w3.org/2001/XMLSchema#integer> .
```

### Turtle

More readable format with prefixes:

```d
string turtle = DTurtleSerializer.serialize(graph);
```

Output:

```turtle
@base <http://example.org/> .
@prefix foaf: <http://xmlns.com/foaf/0.1/> .

<http://example.org/john>
    foaf:name "John Smith" ;
    foaf:age "35"^^<http://www.w3.org/2001/XMLSchema#integer> .
```

### RDF/XML

XML-based format:

```d
string rdfxml = DRDFXMLSerializer.serialize(graph);
```

## Querying Graphs

Find triples matching a pattern (use `null` to match anything):

```d
// Find all names
auto namePred = new DRDFUri("http://xmlns.com/foaf/0.1/name");
auto nameTriples = graph.find(null, namePred, null);

// Find everything about a specific subject
auto person = new DRDFUri("http://example.org/alice");
auto personTriples = graph.find(person, null, null);

// Get unique subjects, predicates, or objects
auto subjects = graph.subjects();
auto predicates = graph.predicates();
auto objects = graph.objects();
```

## Examples

### FOAF Person

```d
auto graph = new DRDFGraph();
graph.addNamespace(CommonNamespaces.FOAF());
graph.addNamespace(CommonNamespaces.RDF());

string person = "http://example.org/alice";
string foaf = "http://xmlns.com/foaf/0.1/";
string rdf = "http://www.w3.org/1999/02/22-rdf-syntax-ns#";

// Type
graph.add(person, rdf ~ "type", foaf ~ "Person");

// Profile
graph.addLiteral(person, foaf ~ "name", "Alice Johnson");
graph.addLiteral(person, foaf ~ "givenName", "Alice");
graph.addLiteral(person, foaf ~ "familyName", "Johnson");
graph.addLiteral(person, foaf ~ "mbox", "alice@example.org");

// Relationships
graph.add(person, foaf ~ "knows", "http://example.org/bob");
```

### Dublin Core Metadata

```d
auto graph = new DRDFGraph();
graph.addNamespace(CommonNamespaces.DC());

string doc = "http://example.org/documents/report2024";
string dc = "http://purl.org/dc/elements/1.1/";

graph.addLiteral(doc, dc ~ "title", "Annual Report 2024");
graph.addLiteral(doc, dc ~ "creator", "John Doe");
graph.addLiteral(doc, dc ~ "subject", "Business Analytics");
graph.addLiteral(doc, dc ~ "date", "2024-12-31");
graph.addLiteral(doc, dc ~ "type", "Text");
graph.addLiteral(doc, dc ~ "format", "application/pdf");
```

### Knowledge Graph

```d
auto graph = new DRDFGraph();

// Add entities and relationships
graph.addLiteral("http://example.org/paris", 
                 "http://www.w3.org/2000/01/rdf-schema#label", 
                 "Paris");

graph.add("http://example.org/paris",
          "http://www.w3.org/1999/02/22-rdf-syntax-ns#type",
          "http://dbpedia.org/ontology/City");

graph.add("http://example.org/paris",
          "http://dbpedia.org/ontology/country",
          "http://example.org/france");

graph.addTypedLiteral("http://example.org/paris",
                      "http://dbpedia.org/ontology/population",
                      2161000);
```

## Graph Operations

```d
auto graph = new DRDFGraph();

// Size
writeln("Triples: ", graph.size());

// Clear
graph.clear();

// Remove matching triples
graph.remove(subject, null, null);  // Remove all triples about subject

// Check existence
auto results = graph.find(subject, predicate, null);
if (results.length > 0) {
    writeln("Found matching triples");
}
```

## Use Cases

- **Semantic Web Applications**: Build applications using linked data
- **Knowledge Graphs**: Create and query knowledge graphs
- **Data Integration**: Integrate data from multiple sources using RDF
- **Ontology Management**: Work with ontologies and vocabularies
- **Metadata**: Describe resources with rich, structured metadata
- **Linked Open Data**: Publish and consume linked data
- **Triple Stores**: Interface with RDF databases

## Standards

This library implements:

- [RDF 1.1 Concepts](https://www.w3.org/TR/rdf11-concepts/)
- [RDF 1.1 N-Triples](https://www.w3.org/TR/n-triples/)
- [RDF 1.1 Turtle](https://www.w3.org/TR/turtle/)
- [RDF 1.1 XML Syntax](https://www.w3.org/TR/rdf-syntax-grammar/)

## API Reference

### DRDFNode

Base class for all RDF nodes.

**Methods:**

- `string toNTriples()`: Serialize to N-Triples format
- `string toTurtle()`: Serialize to Turtle format

### DRDFUri

Represents a URI node.

**Constructor:**

- `this(string uri)`

### DRDFLiteral

Represents a literal value.

**Constructors:**

- `this(string value)`
- `this(string value, string language)`

**Static Methods:**

- `DRDFLiteral typed(T)(T value)`: Create typed literal

### DRDFBlankNode

Represents a blank node.

**Constructors:**

- `this()`: Auto-generate ID
- `this(string id)`: Custom ID

### DRDFTriple

Represents an RDF triple.

**Constructor:**

- `this(DRDFNode subject, DRDFUri predicate, DRDFNode object)`

**Methods:**

- `bool matches(DRDFNode subject, DRDFUri predicate, DRDFNode object)`: Pattern matching

### DRDFGraph

RDF graph container.

**Methods:**

- `void add(DRDFTriple triple)`: Add triple
- `void add(DRDFNode subject, DRDFUri predicate, DRDFNode object)`: Add components
- `void addLiteral(string subject, string predicate, string literal)`: Add literal triple
- `void addTypedLiteral(T)(string subject, string predicate, T value)`: Add typed literal
- `DRDFTriple[] find(...)`: Query triples
- `size_t size()`: Get triple count
- `void clear()`: Remove all triples
- `void remove(...)`: Remove matching triples
- `void addNamespace(string prefix, string uri)`: Add namespace

## License

Apache License 2.0

## Author

Ozan Nurettin Süel (UIManufaktur)

## Contributing

Contributions are welcome! Please submit issues and pull requests on GitHub.
