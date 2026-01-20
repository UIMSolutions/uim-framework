module rdf.examples.example;

import std.stdio;
import uim.rdf;

void main() {
    writeln("=== RDF Library Examples ===\n");
    
    example1_BasicTriple();
    example2_LiteralNodes();
    example3_BlankNodes();
    example4_GraphOperations();
    example5_NamespacesAndPrefixes();
    example6_NTriplesSerialization();
    example7_TurtleSerialization();
    example8_FOAFPerson();
    example9_DublinCore();
    example10_GraphQuerying();
}

void example1_BasicTriple() {
    writeln("Example 1: Basic RDF Triple");
    writeln("----------------------------");
    
    // Create a simple triple: <John> <knows> <Mary>
    auto subject = new DRDFUri("http://example.org/John");
    auto predicate = new DRDFUri("http://xmlns.com/foaf/0.1/knows");
    auto object = new DRDFUri("http://example.org/Mary");
    
    auto triple = new DRDFTriple(subject, predicate, object);
    
    writeln("Triple: ", triple.toNTriples());
    writeln();
}

void example2_LiteralNodes() {
    writeln("Example 2: Literal Nodes");
    writeln("------------------------");
    
    // String literal
    auto name = new DRDFLiteral("John Doe");
    writeln("String literal: ", name.toNTriples());
    
    // Literal with language tag
    auto nameDE = new DRDFLiteral("Johann Schmidt", "de");
    writeln("German name: ", nameDE.toNTriples());
    
    // Typed literals
    auto age = DRDFLiteral.typed(42);
    writeln("Age (integer): ", age.toNTriples());
    
    auto height = DRDFLiteral.typed(1.85);
    writeln("Height (double): ", height.toNTriples());
    
    auto isActive = DRDFLiteral.typed(true);
    writeln("Active (boolean): ", isActive.toNTriples());
    writeln();
}

void example3_BlankNodes() {
    writeln("Example 3: Blank Nodes");
    writeln("----------------------");
    
    // Blank nodes for anonymous resources
    auto blank1 = new DRDFBlankNode();
    auto blank2 = new DRDFBlankNode();
    auto blank3 = new DRDFBlankNode("customId");
    
    writeln("Auto-generated blank node: ", blank1.toNTriples());
    writeln("Another auto-generated: ", blank2.toNTriples());
    writeln("Custom ID blank node: ", blank3.toNTriples());
    writeln();
}

void example4_GraphOperations() {
    writeln("Example 4: Graph Operations");
    writeln("---------------------------");
    
    auto graph = new DRDFGraph("http://example.org/");
    
    // Add triples using different methods
    graph.add("http://example.org/John", 
              "http://xmlns.com/foaf/0.1/name",
              "http://example.org/JohnDoe");
    
    graph.addLiteral("http://example.org/John",
                     "http://xmlns.com/foaf/0.1/givenName",
                     "John");
    
    graph.addTypedLiteral("http://example.org/John",
                          "http://xmlns.com/foaf/0.1/age",
                          30);
    
    writeln("Graph size: ", graph.size(), " triples");
    writeln("Subjects: ", graph.subjects().length);
    writeln("Predicates: ", graph.predicates().length);
    writeln("Objects: ", graph.objects().length);
    writeln();
}

void example5_NamespacesAndPrefixes() {
    writeln("Example 5: Namespaces and Prefixes");
    writeln("-----------------------------------");
    
    // Common namespaces
    auto foaf = CommonNamespaces.FOAF();
    auto dc = CommonNamespaces.DC();
    auto rdf = CommonNamespaces.RDF();
    
    writeln("FOAF namespace: ", foaf.prefix, " -> ", foaf.uri);
    writeln("Dublin Core: ", dc.prefix, " -> ", dc.uri);
    writeln("RDF: ", rdf.prefix, " -> ", rdf.uri);
    
    // Expand prefixed names
    writeln("foaf:name expands to: ", foaf.expand("name"));
    writeln("dc:title expands to: ", dc.expand("title"));
    writeln();
}

void example6_NTriplesSerialization() {
    writeln("Example 6: N-Triples Serialization");
    writeln("-----------------------------------");
    
    auto graph = new DRDFGraph();
    
    graph.add("http://example.org/book1",
              "http://purl.org/dc/elements/1.1/title",
              "http://example.org/BookTitle");
    
    graph.addLiteral("http://example.org/book1",
                     "http://purl.org/dc/elements/1.1/title",
                     "The Great Book");
    
    graph.addLiteral("http://example.org/book1",
                     "http://purl.org/dc/elements/1.1/creator",
                     "Jane Author");
    
    writeln("N-Triples format:");
    writeln(DNTriplesSerializer.serialize(graph));
}

void example7_TurtleSerialization() {
    writeln("Example 7: Turtle Serialization");
    writeln("--------------------------------");
    
    auto graph = new DRDFGraph("http://example.org/");
    
    // Add namespaces
    graph.addNamespace("foaf", "http://xmlns.com/foaf/0.1/");
    graph.addNamespace("ex", "http://example.org/");
    
    // Add triples
    graph.addLiteral("http://example.org/john",
                     "http://xmlns.com/foaf/0.1/name",
                     "John Smith");
    
    graph.addLiteral("http://example.org/john",
                     "http://xmlns.com/foaf/0.1/mbox",
                     "john@example.org");
    
    graph.addTypedLiteral("http://example.org/john",
                          "http://xmlns.com/foaf/0.1/age",
                          35);
    
    writeln("Turtle format:");
    writeln(DTurtleSerializer.serialize(graph));
}

void example8_FOAFPerson() {
    writeln("Example 8: FOAF Person Description");
    writeln("-----------------------------------");
    
    auto graph = new DRDFGraph();
    graph.addNamespace(CommonNamespaces.FOAF());
    graph.addNamespace(CommonNamespaces.RDF());
    
    string person = "http://example.org/people/alice";
    string foafNS = "http://xmlns.com/foaf/0.1/";
    string rdfNS = "http://www.w3.org/1999/02/22-rdf-syntax-ns#";
    
    // Type declaration
    graph.add(person, rdfNS ~ "type", foafNS ~ "Person");
    
    // Basic info
    graph.addLiteral(person, foafNS ~ "name", "Alice Johnson");
    graph.addLiteral(person, foafNS ~ "givenName", "Alice");
    graph.addLiteral(person, foafNS ~ "familyName", "Johnson");
    graph.addLiteral(person, foafNS ~ "nick", "AliceJ");
    
    // Contact
    graph.addLiteral(person, foafNS ~ "mbox", "alice@example.org");
    graph.addLiteral(person, foafNS ~ "homepage", "http://alice.example.org");
    
    // Relationships
    graph.add(person, foafNS ~ "knows", "http://example.org/people/bob");
    graph.add(person, foafNS ~ "knows", "http://example.org/people/charlie");
    
    writeln("FOAF Person (Turtle format):");
    writeln(DTurtleSerializer.serialize(graph));
}

void example9_DublinCore() {
    writeln("Example 9: Dublin Core Metadata");
    writeln("--------------------------------");
    
    auto graph = new DRDFGraph();
    graph.addNamespace(CommonNamespaces.DC());
    graph.addNamespace(CommonNamespaces.DCTERMS());
    
    string document = "http://example.org/documents/report2024";
    string dcNS = "http://purl.org/dc/elements/1.1/";
    
    // Dublin Core metadata
    graph.addLiteral(document, dcNS ~ "title", "Annual Report 2024");
    graph.addLiteral(document, dcNS ~ "creator", "John Doe");
    graph.addLiteral(document, dcNS ~ "subject", "Business Analytics");
    graph.addLiteral(document, dcNS ~ "description", 
                     "Comprehensive analysis of business performance in 2024");
    graph.addLiteral(document, dcNS ~ "publisher", "Example Corp");
    graph.addLiteral(document, dcNS ~ "date", "2024-12-31");
    graph.addLiteral(document, dcNS ~ "type", "Text");
    graph.addLiteral(document, dcNS ~ "format", "application/pdf");
    
    // Add literal with language tag
    auto langLiteral = new DRDFLiteral("en", "en");
    graph.add(new DRDFUri(document), new DRDFUri(dcNS ~ "language"), langLiteral);
    
    writeln("Dublin Core metadata (N-Triples):");
    writeln(DNTriplesSerializer.serialize(graph));
}

void example10_GraphQuerying() {
    writeln("Example 10: Graph Querying");
    writeln("--------------------------");
    
    auto graph = new DRDFGraph();
    
    // Add some data
    graph.addLiteral("http://example.org/person1", 
                     "http://xmlns.com/foaf/0.1/name", "Alice");
    graph.addTypedLiteral("http://example.org/person1",
                          "http://xmlns.com/foaf/0.1/age", 30);
    
    graph.addLiteral("http://example.org/person2",
                     "http://xmlns.com/foaf/0.1/name", "Bob");
    graph.addTypedLiteral("http://example.org/person2",
                          "http://xmlns.com/foaf/0.1/age", 25);
    
    graph.add("http://example.org/person1",
              "http://xmlns.com/foaf/0.1/knows",
              "http://example.org/person2");
    
    // Query: Find all names
    auto namePred = new DRDFUri("http://xmlns.com/foaf/0.1/name");
    auto nameTriples = graph.find(null, namePred, null);
    
    writeln("All names:");
    foreach (triple; nameTriples) {
        writeln("  ", triple.object.toString());
    }
    
    // Query: Find everything about person1
    auto person1 = new DRDFUri("http://example.org/person1");
    auto person1Triples = graph.find(person1, null, null);
    
    writeln("\nEverything about person1:");
    foreach (triple; person1Triples) {
        writeln("  ", triple.toNTriples());
    }
    
    writeln("\nTotal triples in graph: ", graph.size());
    writeln();
}
