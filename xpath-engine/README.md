# XPath Engine

## Overview
The XPath Engine is a D programming language implementation of an XPath processor. It allows users to evaluate XPath expressions against XML documents, providing a way to navigate and query XML data efficiently.

## Features
- **XPath Parsing**: The engine can parse XPath expressions and convert them into an abstract syntax tree (AST).
- **Evaluation**: It evaluates the parsed XPath expressions against XML documents, returning the results.
- **Tokenization**: The engine tokenizes XPath expressions for easier processing.

## Installation
To install the XPath Engine, you can use the DUB package manager. Clone the repository and run the following command in the project directory:

```bash
dub build
```

## Usage
After building the project, you can use the XPath Engine in your D applications. Here is a simple example of how to use the engine:

```d
import xpath;

void main() {
    auto parser = new XPathParser();
    auto ast = parser.parse("/bookstore/book/title");
    
    auto evaluator = new XPathEvaluator();
    auto result = evaluator.evaluate(ast, contextNode);
    
    writeln(result);
}
```

## Contribution
Contributions are welcome! Please fork the repository and submit a pull request with your changes. Ensure that you include tests for any new features or bug fixes.

## License
This project is licensed under the MIT License. See the LICENSE file for more details.