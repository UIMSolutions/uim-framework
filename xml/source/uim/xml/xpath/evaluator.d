module uim.xml.xpath.evaluator;

import std.array : array;
import std.algorithm : filter;
import uim.xml.builders;
import uim.xml.xpath.ast;
import uim.xml.xpath.types;

class XPathEvaluator {
    // Evaluates the given AST against the provided context element
    // and returns the selected elements
    XMLElement[] evaluate(ASTNode ast, XMLElement context) {
        auto path = cast(PathNode)ast;
        if (path is null) {
            throw new XPathException("Cannot evaluate AST node of type "
                ~ (ast is null ? "null" : ast.classinfo.name));
        }
        if (context is null) {
            return [];
        }

        XMLElement[] current;
        StepNode[] steps = path.steps;

        if (path.absolute) {
            // the context element acts as the document element:
            // the first step tests the context element itself
            if (steps.length == 0) {
                return [context];
            }
            if (steps[0].axis == StepAxis.Descendant) {
                current = selectDescendants(steps[0], [context]);
                steps = steps[1 .. $];
            } else {
                if (!matchesName(steps[0], context) || !matchesFilters(steps[0], context)) {
                    return [];
                }
                current = [context];
                steps = steps[1 .. $];
            }
        } else {
            current = [context];
        }

        foreach (step; steps) {
            current = applyStep(step, current);
        }
        return current;
    }

    private XMLElement[] applyStep(StepNode step, XMLElement[] nodes) {
        switch (step.axis) {
            case StepAxis.Child:
                return selectChildren(step, nodes);
            case StepAxis.Descendant:
                return selectDescendants(step, nodes);
            case StepAxis.Self:
                return nodes.filter!(node => matchesName(step, node) && matchesFilters(step, node)).array;
            case StepAxis.Parent:
                throw new XPathException("Parent axis is not supported: elements have no parent link");
            case StepAxis.Attribute:
                throw new XPathException("Attribute steps do not select elements");
            default:
                throw new XPathException("Unsupported step axis");
        }
    }

    // Selects matching children of each context node
    private XMLElement[] selectChildren(StepNode step, XMLElement[] nodes) {
        XMLElement[] result;
        foreach (node; nodes) {
            auto candidates = node.children
                .filter!(child => matchesName(step, child) && matchesFilters(step, child))
                .array;
            result ~= applyPositions(step, candidates);
        }
        return result;
    }

    // Selects matching descendants (transitive children) of each context node
    private XMLElement[] selectDescendants(StepNode step, XMLElement[] nodes) {
        XMLElement[] result;
        foreach (node; nodes) {
            auto candidates = descendants(node)
                .filter!(child => matchesName(step, child) && matchesFilters(step, child))
                .array;
            result ~= applyPositions(step, candidates);
        }
        return result;
    }

    private XMLElement[] descendants(XMLElement node) {
        XMLElement[] result;
        foreach (child; node.children) {
            result ~= child;
            result ~= descendants(child);
        }
        return result;
    }

    private bool matchesName(StepNode step, XMLElement node) {
        return step.nameTest is null || step.nameTest == "*" || step.nameTest == node.name;
    }

    // Applies all non-position predicates to a single candidate
    private bool matchesFilters(StepNode step, XMLElement node) {
        foreach (predicate; step.predicates) {
            if (auto exists = cast(AttributeExistsPredicate)predicate) {
                if (!node.hasAttribute(exists.name)) {
                    return false;
                }
            } else if (auto equals = cast(AttributeEqualsPredicate)predicate) {
                if (node.attributeValue(equals.name) != equals.value) {
                    return false;
                }
            }
        }
        return true;
    }

    // Applies position predicates (1-based) to a step result set
    private XMLElement[] applyPositions(StepNode step, XMLElement[] candidates) {
        auto result = candidates;
        foreach (predicate; step.predicates) {
            if (auto position = cast(PositionPredicate)predicate) {
                result = position.position >= 1 && position.position <= result.length
                    ? [result[position.position - 1]]
                    : [];
            }
        }
        return result;
    }
}
