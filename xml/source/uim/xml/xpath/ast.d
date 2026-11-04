module uim.xml.xpath.ast;

// Base class for all AST nodes
class ASTNode {
}

// Axis of a location step
enum StepAxis {
    Child,
    Descendant,
    Self,
    Parent,
    Attribute
}

// A location path, e.g. "/bookstore/book" or "//title"
class PathNode : ASTNode {
    bool absolute;
    StepNode[] steps;

    this(bool absolute = false, StepNode[] steps = null) {
        this.absolute = absolute;
        this.steps = steps.dup;
    }
}

// A single location step, e.g. "book", "@id", "." or ".."
class StepNode : ASTNode {
    StepAxis axis;
    string nameTest; // "*" matches any element name
    PredicateNode[] predicates;

    this(StepAxis axis = StepAxis.Child, string nameTest = null, PredicateNode[] predicates = null) {
        this.axis = axis;
        this.nameTest = nameTest;
        this.predicates = predicates.dup;
    }
}

// Base class for predicates, e.g. "[@id]", "[@lang='en']", "[1]"
class PredicateNode : ASTNode {
}

// Matches elements carrying the attribute, e.g. "[@id]"
class AttributeExistsPredicate : PredicateNode {
    string name;

    this(string name) {
        this.name = name;
    }
}

// Matches elements whose attribute equals a value, e.g. "[@lang='en']"
class AttributeEqualsPredicate : PredicateNode {
    string name;
    string value;

    this(string name, string value) {
        this.name = name;
        this.value = value;
    }
}

// Selects the n-th element (1-based) of a step result, e.g. "[1]"
class PositionPredicate : PredicateNode {
    size_t position;

    this(size_t position) {
        this.position = position;
    }
}

class FunctionNode : ASTNode {
    string name;
    ASTNode[] arguments;

    this(string name, ASTNode[] arguments) {
        this.name = name;
        this.arguments = arguments.dup;
    }
}

class LiteralNode : ASTNode {
    string value;

    this(string value) {
        this.value = value;
    }
}

// Additional node types can be defined here as needed.
