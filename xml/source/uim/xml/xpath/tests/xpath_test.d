module uim.xml.xpath.tests.xpath_test;

import uim.xml.builders;
import uim.xml.xpath.ast;
import uim.xml.xpath.evaluator;
import uim.xml.xpath.lexer;
import uim.xml.xpath.parser;
import uim.xml.xpath.types;

// Lexer: tokenizes a location path
unittest {
    auto lexer = new XPathLexer;
    auto tokens = lexer.tokenize("/bookstore/book/title");

    assert(tokens.length == 7); // including the EndOfInput token
    assert(tokens[0].type == TokenType.Slash);
    assert(tokens[1].type == TokenType.Identifier && tokens[1].value == "bookstore");
    assert(tokens[2].type == TokenType.Slash);
    assert(tokens[3].type == TokenType.Identifier && tokens[3].value == "book");
    assert(tokens[5].type == TokenType.Identifier && tokens[5].value == "title");
    assert(tokens[6].type == TokenType.EndOfInput);
}

// Lexer: tokenizes predicates, wildcards and descendant steps
unittest {
    auto tokens = new XPathLexer("//book[@lang='en'][1]").tokenize();

    assert(tokens[0].type == TokenType.DoubleSlash);
    assert(tokens[1].type == TokenType.Identifier && tokens[1].value == "book");
    assert(tokens[2].type == TokenType.LBracket);
    assert(tokens[3].type == TokenType.At);
    assert(tokens[4].type == TokenType.Identifier && tokens[4].value == "lang");
    assert(tokens[5].type == TokenType.Equals);
    assert(tokens[6].type == TokenType.String && tokens[6].value == "en");
    assert(tokens[7].type == TokenType.RBracket);
    assert(tokens[8].type == TokenType.LBracket);
    assert(tokens[9].type == TokenType.Number && tokens[9].value == "1");
    assert(tokens[10].type == TokenType.RBracket);
}

// Lexer: reports invalid input
unittest {
    import std.exception : assertThrown;

    assertThrown!XPathException(new XPathLexer("book\"unterminated").tokenize());
    assertThrown!XPathException(new XPathLexer("book#title").tokenize());
}

// Parser: builds an AST for an absolute path
unittest {
    auto parser = new XPathParser(new XPathLexer);
    auto ast = parser.parse("/bookstore/book/title");

    assert(ast !is null);
    auto path = cast(PathNode)ast;
    assert(path !is null);
    assert(path.absolute);
    assert(path.steps.length == 3);
    assert(path.steps[0].nameTest == "bookstore");
    assert(path.steps[0].axis == StepAxis.Child);
    assert(path.steps[2].nameTest == "title");
}

// Parser: relative paths, descendant axis, wildcards and predicates
unittest {
    auto parser = new XPathParser;

    auto relative = cast(PathNode)parser.parse("book/title");
    assert(relative !is null && !relative.absolute && relative.steps.length == 2);

    auto descendant = cast(PathNode)parser.parse("//title");
    assert(descendant.absolute);
    assert(descendant.steps[0].axis == StepAxis.Descendant);

    auto wildcard = cast(PathNode)parser.parse("/bookstore/*");
    assert(wildcard.steps[1].nameTest == "*");

    auto predicated = cast(PathNode)parser.parse("/bookstore/book[@lang='en'][1]");
    auto step = predicated.steps[1];
    assert(step.predicates.length == 2);
    auto equals = cast(AttributeEqualsPredicate)step.predicates[0];
    assert(equals !is null && equals.name == "lang" && equals.value == "en");
    auto position = cast(PositionPredicate)step.predicates[1];
    assert(position !is null && position.position == 1);

    auto self = cast(PathNode)parser.parse(".");
    assert(self.steps[0].axis == StepAxis.Self);

    auto parent = cast(PathNode)parser.parse("../title");
    assert(parent.steps[0].axis == StepAxis.Parent);
}

// Parser: rejects invalid expressions
unittest {
    import std.exception : assertThrown;

    auto parser = new XPathParser;
    assertThrown!XPathException(parser.parse("/bookstore/"));
    assertThrown!XPathException(parser.parse("/bookstore["));
    assertThrown!XPathException(parser.parse(""));
}

// Evaluator: selects elements in a document tree
unittest {
    auto bookstore = element("bookstore")
        .add(element("book").attribute("lang", "en")
            .add(element("title").text("D Language"))
            .add(element("price").text("42")))
        .add(element("book").attribute("lang", "de")
            .add(element("title").text("D Sprache")))
        .add(element("magazine")
            .add(element("title").text("Monthly")));

    auto parser = new XPathParser;
    auto evaluator = new XPathEvaluator;

    // absolute child path
    auto titles = evaluator.evaluate(parser.parse("/bookstore/book/title"), bookstore);
    assert(titles.length == 2);

    // descendant step
    auto allTitles = evaluator.evaluate(parser.parse("//title"), bookstore);
    assert(allTitles.length == 3);

    // wildcard
    auto anyChildren = evaluator.evaluate(parser.parse("/bookstore/*"), bookstore);
    assert(anyChildren.length == 3);

    // attribute equality predicate
    auto german = evaluator.evaluate(parser.parse("/bookstore/book[@lang='de']/title"), bookstore);
    assert(german.length == 1);

    // attribute existence predicate
    auto withLang = evaluator.evaluate(parser.parse("//book[@lang]"), bookstore);
    assert(withLang.length == 2);

    // position predicate (1-based)
    auto first = evaluator.evaluate(parser.parse("/bookstore/book[1]"), bookstore);
    assert(first.length == 1);
    assert(first[0].attributeValue("lang") == "en");

    auto second = evaluator.evaluate(parser.parse("/bookstore/book[2]/title"), bookstore);
    assert(second.length == 1);

    // no match
    auto missing = evaluator.evaluate(parser.parse("/bookstore/dvd"), bookstore);
    assert(missing.length == 0);
    assert(evaluator.evaluate(parser.parse("/other"), bookstore).length == 0);
}
