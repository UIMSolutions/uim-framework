module xpath.ast;

class ASTNode {
    // Base class for all AST nodes
}

class FunctionNode : ASTNode {
    string name;
    ASTNode[] arguments;

    this(string name, ASTNode[] arguments) {
        this.name = name;
        this.arguments = arguments;
    }
}

class LiteralNode : ASTNode {
    string value;

    this(string value) {
        this.value = value;
    }
}

// Additional node types can be defined here as needed.