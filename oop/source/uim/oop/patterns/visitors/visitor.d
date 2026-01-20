/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.visitors.visitor;

import uim.oop.patterns.visitors.interfaces;
import std.format;
import std.algorithm : remove;
import std.conv : to;

/**
 * Abstract base element that implements common functionality.
 */
abstract class BaseElement : IElement {
    protected string _name;
    
    this(string elementName) @safe {
        _name = elementName;
    }
    
    @safe string name() const {
        return _name;
    }
    
    abstract void accept(IVisitor visitor);
}

/**
 * Object structure that holds a collection of elements.
 */
class ObjectStructure : IObjectStructure {
    private IElement[] _elements;
    
    @safe void addElement(IElement element) {
        _elements ~= element;
    }
    
    @safe void removeElement(IElement element) {
        foreach (i, elem; _elements) {
            if (elem is element) {
                _elements = _elements.remove(i);
                break;
            }
        }
    }
    
    @safe void accept(IVisitor visitor) {
        foreach (element; _elements) {
            element.accept(visitor);
        }
    }
    
    @safe size_t elementCount() const {
        return _elements.length;
    }
    
    IElement[] elements() const @trusted {
        IElement[] result;
        foreach (elem; _elements) {
            result ~= cast(IElement)elem;
        }
        return result;
    }
}

/**
 * Abstract base visitor with common functionality.
 */
abstract class BaseVisitor : IVisitor {
    protected string[] _visited;
    
    @safe string[] visited() const {
        return _visited.dup;
    }
    
    abstract void visit(IElement element);
}

// Real-world example: Shape rendering system

/**
 * Shape element interface.
 */
interface IShape : IElement {
    @safe double area() const;
}

/**
 * Circle shape.
 */
class Circle : BaseElement, IShape {
    private double _radius;
    
    this(string name, double radius) @safe {
        super(name);
        _radius = radius;
    }
    
    @safe double radius() const {
        return _radius;
    }
    
    @safe double area() const {
        return 3.14159 * _radius * _radius;
    }
    
    override @safe void accept(IVisitor visitor) {
        visitor.visit(this);
    }
}

/**
 * Rectangle shape.
 */
class Rectangle : BaseElement, IShape {
    private double _width;
    private double _height;
    
    this(string name, double width, double height) @safe {
        super(name);
        _width = width;
        _height = height;
    }
    
    @safe double width() const {
        return _width;
    }
    
    @safe double height() const {
        return _height;
    }
    
    @safe double area() const {
        return _width * _height;
    }
    
    override @safe void accept(IVisitor visitor) {
        visitor.visit(this);
    }
}

/**
 * Triangle shape.
 */
class Triangle : BaseElement, IShape {
    private double _base;
    private double _height;
    
    this(string name, double base, double height) @safe {
        super(name);
        _base = base;
        _height = height;
    }
    
    @safe double baseLength() const {
        return _base;
    }
    
    @safe double height() const {
        return _height;
    }
    
    @safe double area() const {
        return 0.5 * _base * _height;
    }
    
    override @safe void accept(IVisitor visitor) {
        visitor.visit(this);
    }
}

/**
 * Area calculator visitor.
 */
class AreaCalculator : BaseVisitor {
    private double _totalArea;
    
    this() @safe {
        _totalArea = 0.0;
    }
    
    override @safe void visit(IElement element) {
        _visited ~= element.name;
        
        if (auto shape = cast(IShape)element) {
            _totalArea += shape.area();
        }
    }
    
    @safe double totalArea() const {
        return _totalArea;
    }
}

/**
 * Perimeter calculator visitor.
 */
class PerimeterCalculator : BaseVisitor {
    private double _totalPerimeter;
    
    this() @safe {
        _totalPerimeter = 0.0;
    }
    
    override @safe void visit(IElement element) {
        _visited ~= element.name;
        
        if (auto circle = cast(Circle)element) {
            _totalPerimeter += 2.0 * 3.14159 * circle.radius();
        } else if (auto rect = cast(Rectangle)element) {
            _totalPerimeter += 2.0 * (rect.width() + rect.height());
        } else if (auto tri = cast(Triangle)element) {
            // Simplified: assume equilateral triangle
            _totalPerimeter += 3.0 * tri.baseLength();
        }
    }
    
    @safe double totalPerimeter() const {
        return _totalPerimeter;
    }
}

/**
 * Drawing visitor that generates drawing commands.
 */
class DrawingVisitor : BaseVisitor {
    private string[] _commands;
    
    override @safe void visit(IElement element) {
        _visited ~= element.name;
        
        if (auto circle = cast(Circle)element) {
            _commands ~= "Draw circle '" ~ circle.name ~ "' with radius " ~ circle.radius().to!string;
        } else if (auto rect = cast(Rectangle)element) {
            _commands ~= "Draw rectangle '" ~ rect.name ~ "' " ~ rect.width().to!string ~ "x" ~ rect.height().to!string;
        } else if (auto tri = cast(Triangle)element) {
            _commands ~= "Draw triangle '" ~ tri.name ~ "' base=" ~ tri.baseLength().to!string;
        }
    }
    
    @safe string[] commands() const {
        return _commands.dup;
    }
}

// Real-world example: File system operations

/**
 * File system element.
 */
abstract class FileSystemElement : BaseElement {
    this(string name) @safe {
        super(name);
    }
}

/**
 * File element.
 */
class FileElement : FileSystemElement {
    private size_t _size;
    
    this(string name, size_t size) @safe {
        super(name);
        _size = size;
    }
    
    @safe size_t size() const {
        return _size;
    }
    
    override @safe void accept(IVisitor visitor) {
        visitor.visit(this);
    }
}

/**
 * Directory element.
 */
class DirectoryElement : FileSystemElement {
    private FileSystemElement[] _children;
    
    this(string name) @safe {
        super(name);
    }
    
    @safe void addChild(FileSystemElement child) {
        _children ~= child;
    }
    
    FileSystemElement[] children() const @trusted {
        FileSystemElement[] result;
        foreach (child; _children) {
            result ~= cast(FileSystemElement)child;
        }
        return result;
    }
    
    override @safe void accept(IVisitor visitor) {
        visitor.visit(this);
        
        // Visit children
        foreach (child; _children) {
            child.accept(visitor);
        }
    }
}

/**
 * Size calculator visitor for file system.
 */
class SizeCalculator : BaseVisitor {
    private size_t _totalSize;
    
    this() @safe {
        _totalSize = 0;
    }
    
    override @safe void visit(IElement element) {
        _visited ~= element.name;
        
        if (auto file = cast(FileElement)element) {
            _totalSize += file.size();
        }
    }
    
    @safe size_t totalSize() const {
        return _totalSize;
    }
}

/**
 * File counter visitor.
 */
class FileCounter : BaseVisitor {
    private size_t _fileCount;
    private size_t _dirCount;
    
    this() @safe {
        _fileCount = 0;
        _dirCount = 0;
    }
    
    override @safe void visit(IElement element) {
        _visited ~= element.name;
        
        if (cast(FileElement)element) {
            _fileCount++;
        } else if (cast(DirectoryElement)element) {
            _dirCount++;
        }
    }
    
    @safe size_t fileCount() const {
        return _fileCount;
    }
    
    @safe size_t dirCount() const {
        return _dirCount;
    }
}

/**
 * File listing visitor.
 */
class FileLister : BaseVisitor {
    private string[] _listings;
    private int _depth;
    
    this() @safe {
        _depth = 0;
    }
    
    override @safe void visit(IElement element) {
        string indent = "";
        for (int i = 0; i < _depth; i++) {
            indent ~= "  ";
        }
        
        if (auto file = cast(FileElement)element) {
            _listings ~= indent ~ "File: " ~ file.name ~ " (" ~ file.size().to!string ~ " bytes)";
        } else if (auto dir = cast(DirectoryElement)element) {
            _listings ~= indent ~ "Dir: " ~ dir.name;
            _depth++;
            // Children will be visited automatically
        }
        
        _visited ~= element.name;
    }
    
    @safe string[] listings() const {
        return _listings.dup;
    }
}

// Real-world example: Expression evaluation

/**
 * Expression element.
 */
interface IExpression : IElement {
}

/**
 * Number expression.
 */
class NumberExpression : BaseElement, IExpression {
    private double _value;
    
    this(double value) @safe {
        super("Number");
        _value = value;
    }
    
    @safe double value() const {
        return _value;
    }
    
    override @safe void accept(IVisitor visitor) {
        visitor.visit(this);
    }
}

/**
 * Addition expression.
 */
class AddExpression : BaseElement, IExpression {
    private IExpression _left;
    private IExpression _right;
    
    this(IExpression left, IExpression right) @safe {
        super("Add");
        _left = left;
        _right = right;
    }
    
    IExpression left() const @trusted {
        return cast(IExpression)_left;
    }
    
    IExpression right() const @trusted {
        return cast(IExpression)_right;
    }
    
    override @safe void accept(IVisitor visitor) {
        _left.accept(visitor);
        _right.accept(visitor);
        visitor.visit(this);
    }
}

/**
 * Multiplication expression.
 */
class MultiplyExpression : BaseElement, IExpression {
    private IExpression _left;
    private IExpression _right;
    
    this(IExpression left, IExpression right) @safe {
        super("Multiply");
        _left = left;
        _right = right;
    }
    
    IExpression left() const @trusted {
        return cast(IExpression)_left;
    }
    
    IExpression right() const @trusted {
        return cast(IExpression)_right;
    }
    
    override @safe void accept(IVisitor visitor) {
        _left.accept(visitor);
        _right.accept(visitor);
        visitor.visit(this);
    }
}

/**
 * Expression evaluator visitor.
 */
class ExpressionEvaluator : BaseVisitor {
    private double[] _stack;
    
    override @safe void visit(IElement element) {
        _visited ~= element.name;
        
        if (auto num = cast(NumberExpression)element) {
            _stack ~= num.value();
        } else if (cast(AddExpression)element) {
            if (_stack.length >= 2) {
                double right = _stack[$-1];
                double left = _stack[$-2];
                _stack = _stack[0..$-2];
                _stack ~= left + right;
            }
        } else if (cast(MultiplyExpression)element) {
            if (_stack.length >= 2) {
                double right = _stack[$-1];
                double left = _stack[$-2];
                _stack = _stack[0..$-2];
                _stack ~= left * right;
            }
        }
    }
    
    @safe double result() const {
        return _stack.length > 0 ? _stack[$-1] : 0.0;
    }
}

// Unit tests

@safe unittest {
    // Test basic element
    class TestElement : BaseElement {
        this() @safe { super("Test"); }
        override void accept(IVisitor visitor) {
            visitor.visit(this);
        }
    }
    
    auto element = new TestElement();
    assert(element.name == "Test");
}

@safe unittest {
    // Test object structure
    class Elem : BaseElement {
        this(string name) @safe { super(name); }
        override void accept(IVisitor visitor) {
            visitor.visit(this);
        }
    }
    
    auto structure = new ObjectStructure();
    structure.addElement(new Elem("A"));
    structure.addElement(new Elem("B"));
    
    assert(structure.elementCount() == 2);
}

@safe unittest {
    // Test shape area calculation
    auto circle = new Circle("Circle1", 5.0);
    auto rect = new Rectangle("Rect1", 4.0, 3.0);
    
    auto calculator = new AreaCalculator();
    circle.accept(calculator);
    rect.accept(calculator);
    
    assert(calculator.totalArea() > 0);
    assert(calculator.visited().length == 2);
}

@safe unittest {
    // Test shape perimeter calculation
    auto circle = new Circle("C", 3.0);
    auto calculator = new PerimeterCalculator();
    
    circle.accept(calculator);
    
    assert(calculator.totalPerimeter() > 0);
}

@safe unittest {
    // Test drawing visitor
    auto circle = new Circle("MyCircle", 10.0);
    auto drawer = new DrawingVisitor();
    
    circle.accept(drawer);
    
    auto commands = drawer.commands();
    assert(commands.length == 1);
}

@safe unittest {
    // Test file system size calculation
    auto root = new DirectoryElement("root");
    auto file1 = new FileElement("file1.txt", 100);
    auto file2 = new FileElement("file2.txt", 200);
    
    root.addChild(file1);
    root.addChild(file2);
    
    auto sizeCalc = new SizeCalculator();
    root.accept(sizeCalc);
    
    assert(sizeCalc.totalSize() == 300);
}

@safe unittest {
    // Test file counter
    auto root = new DirectoryElement("root");
    auto subdir = new DirectoryElement("subdir");
    auto file1 = new FileElement("file1.txt", 100);
    
    root.addChild(subdir);
    root.addChild(file1);
    
    auto counter = new FileCounter();
    root.accept(counter);
    
    assert(counter.fileCount() == 1);
    assert(counter.dirCount() == 2);
}

@safe unittest {
    // Test expression evaluation
    auto expr = new AddExpression(
        new NumberExpression(5.0),
        new NumberExpression(3.0)
    );
    
    auto evaluator = new ExpressionEvaluator();
    expr.accept(evaluator);
    
    assert(evaluator.result() == 8.0);
}
