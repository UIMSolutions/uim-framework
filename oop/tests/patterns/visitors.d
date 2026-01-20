module oop.tests.patterns.visitors;

import uim.oop.patterns.visitors;

@safe unittest {
    // Test base element creation
    class SimpleElement : BaseElement {
        this() @safe { super("Simple"); }
        override void accept(IVisitor visitor) {
            visitor.visit(this);
        }
    }
    
    auto element = new SimpleElement();
    assert(element !is null);
    assert(element.name == "Simple");
}

@safe unittest {
    // Test element name property
    class NamedElement : BaseElement {
        this(string name) @safe { super(name); }
        override void accept(IVisitor visitor) {
            visitor.visit(this);
        }
    }
    
    auto element = new NamedElement("TestElement");
    assert(element.name == "TestElement");
}

@safe unittest {
    // Test object structure add element
    class Elem : BaseElement {
        this(string name) @safe { super(name); }
        override void accept(IVisitor visitor) {
            visitor.visit(this);
        }
    }
    
    auto structure = new ObjectStructure();
    structure.addElement(new Elem("A"));
    
    assert(structure.elementCount() == 1);
}

@safe unittest {
    // Test object structure multiple elements
    class E : BaseElement {
        this(string name) @safe { super(name); }
        override void accept(IVisitor visitor) {
            visitor.visit(this);
        }
    }
    
    auto structure = new ObjectStructure();
    structure.addElement(new E("E1"));
    structure.addElement(new E("E2"));
    structure.addElement(new E("E3"));
    
    assert(structure.elementCount() == 3);
}

@safe unittest {
    // Test object structure remove element
    class El : BaseElement {
        this(string name) @safe { super(name); }
        override void accept(IVisitor visitor) {
            visitor.visit(this);
        }
    }
    
    auto structure = new ObjectStructure();
    auto elem1 = new El("E1");
    auto elem2 = new El("E2");
    
    structure.addElement(elem1);
    structure.addElement(elem2);
    
    assert(structure.elementCount() == 2);
    
    structure.removeElement(elem1);
    assert(structure.elementCount() == 1);
}

@safe unittest {
    // Test visitor visiting elements
    class TestElement : BaseElement {
        this(string name) @safe { super(name); }
        override void accept(IVisitor visitor) {
            visitor.visit(this);
        }
    }
    
    class TestVisitor : BaseVisitor {
        int visitCount = 0;
        
        override void visit(IElement element) {
            visitCount++;
            _visited ~= element.name;
        }
    }
    
    auto element = new TestElement("Test");
    auto visitor = new TestVisitor();
    
    element.accept(visitor);
    
    assert(visitor.visitCount == 1);
    assert(visitor.visited().length == 1);
}

@safe unittest {
    // Test circle shape
    auto circle = new Circle("MyCircle", 5.0);
    
    assert(circle.name == "MyCircle");
    assert(circle.radius() == 5.0);
    assert(circle.area() > 0);
}

@safe unittest {
    // Test rectangle shape
    auto rect = new Rectangle("MyRect", 4.0, 3.0);
    
    assert(rect.name == "MyRect");
    assert(rect.width() == 4.0);
    assert(rect.height() == 3.0);
    assert(rect.area() == 12.0);
}

@safe unittest {
    // Test triangle shape
    auto triangle = new Triangle("MyTri", 6.0, 4.0);
    
    assert(triangle.name == "MyTri");
    assert(triangle.baseLength() == 6.0);
    assert(triangle.height() == 4.0);
    assert(triangle.area() == 12.0);
}

@safe unittest {
    // Test area calculator with circle
    auto circle = new Circle("C1", 10.0);
    auto calculator = new AreaCalculator();
    
    circle.accept(calculator);
    
    assert(calculator.totalArea() > 0);
    assert(calculator.visited().length == 1);
}

@safe unittest {
    // Test area calculator with multiple shapes
    auto circle = new Circle("C", 5.0);
    auto rect = new Rectangle("R", 4.0, 3.0);
    auto triangle = new Triangle("T", 6.0, 4.0);
    
    auto calculator = new AreaCalculator();
    circle.accept(calculator);
    rect.accept(calculator);
    triangle.accept(calculator);
    
    double expectedArea = circle.area() + rect.area() + triangle.area();
    assert(calculator.totalArea() > 0);
    assert(calculator.visited().length == 3);
}

@safe unittest {
    // Test perimeter calculator
    auto circle = new Circle("C", 5.0);
    auto calculator = new PerimeterCalculator();
    
    circle.accept(calculator);
    
    assert(calculator.totalPerimeter() > 0);
}

@safe unittest {
    // Test perimeter calculator with rectangle
    auto rect = new Rectangle("R", 4.0, 3.0);
    auto calculator = new PerimeterCalculator();
    
    rect.accept(calculator);
    
    assert(calculator.totalPerimeter() == 14.0);
}

@safe unittest {
    // Test drawing visitor
    auto circle = new Circle("Circle1", 7.5);
    auto drawer = new DrawingVisitor();
    
    circle.accept(drawer);
    
    auto commands = drawer.commands();
    assert(commands.length == 1);
}

@safe unittest {
    // Test drawing visitor with multiple shapes
    auto circle = new Circle("C", 5.0);
    auto rect = new Rectangle("R", 10.0, 5.0);
    
    auto drawer = new DrawingVisitor();
    circle.accept(drawer);
    rect.accept(drawer);
    
    auto commands = drawer.commands();
    assert(commands.length == 2);
}

@safe unittest {
    // Test file element
    auto file = new FileElement("test.txt", 1024);
    
    assert(file.name == "test.txt");
    assert(file.size() == 1024);
}

@safe unittest {
    // Test directory element
    auto dir = new DirectoryElement("mydir");
    
    assert(dir.name == "mydir");
}

@safe unittest {
    // Test directory with children
    auto dir = new DirectoryElement("root");
    auto file1 = new FileElement("file1.txt", 100);
    auto file2 = new FileElement("file2.txt", 200);
    
    dir.addChild(file1);
    dir.addChild(file2);
    
    auto children = dir.children();
    assert(children.length == 2);
}

@safe unittest {
    // Test size calculator
    auto file = new FileElement("data.bin", 5000);
    auto calculator = new SizeCalculator();
    
    file.accept(calculator);
    
    assert(calculator.totalSize() == 5000);
}

@safe unittest {
    // Test size calculator with directory
    auto root = new DirectoryElement("root");
    auto file1 = new FileElement("file1.txt", 100);
    auto file2 = new FileElement("file2.txt", 200);
    auto file3 = new FileElement("file3.txt", 300);
    
    root.addChild(file1);
    root.addChild(file2);
    root.addChild(file3);
    
    auto calculator = new SizeCalculator();
    root.accept(calculator);
    
    assert(calculator.totalSize() == 600);
}

@safe unittest {
    // Test file counter
    auto root = new DirectoryElement("root");
    auto file = new FileElement("file.txt", 100);
    
    root.addChild(file);
    
    auto counter = new FileCounter();
    root.accept(counter);
    
    assert(counter.fileCount() == 1);
    assert(counter.dirCount() == 1);
}

@safe unittest {
    // Test file counter with nested directories
    auto root = new DirectoryElement("root");
    auto subdir1 = new DirectoryElement("subdir1");
    auto subdir2 = new DirectoryElement("subdir2");
    auto file1 = new FileElement("file1.txt", 100);
    auto file2 = new FileElement("file2.txt", 200);
    
    subdir1.addChild(file1);
    subdir2.addChild(file2);
    root.addChild(subdir1);
    root.addChild(subdir2);
    
    auto counter = new FileCounter();
    root.accept(counter);
    
    assert(counter.fileCount() == 2);
    assert(counter.dirCount() == 3);
}

@safe unittest {
    // Test file lister
    auto root = new DirectoryElement("root");
    auto file = new FileElement("test.txt", 512);
    
    root.addChild(file);
    
    auto lister = new FileLister();
    root.accept(lister);
    
    auto listings = lister.listings();
    assert(listings.length >= 1);
}

@safe unittest {
    // Test number expression
    auto num = new NumberExpression(42.0);
    
    assert(num.value() == 42.0);
}

@safe unittest {
    // Test addition expression
    auto left = new NumberExpression(10.0);
    auto right = new NumberExpression(5.0);
    auto add = new AddExpression(left, right);
    
    assert(add.left() !is null);
    assert(add.right() !is null);
}

@safe unittest {
    // Test multiplication expression
    auto left = new NumberExpression(3.0);
    auto right = new NumberExpression(4.0);
    auto mul = new MultiplyExpression(left, right);
    
    assert(mul.left() !is null);
    assert(mul.right() !is null);
}

@safe unittest {
    // Test expression evaluator with addition
    auto expr = new AddExpression(
        new NumberExpression(7.0),
        new NumberExpression(3.0)
    );
    
    auto evaluator = new ExpressionEvaluator();
    expr.accept(evaluator);
    
    assert(evaluator.result() == 10.0);
}

@safe unittest {
    // Test expression evaluator with multiplication
    auto expr = new MultiplyExpression(
        new NumberExpression(6.0),
        new NumberExpression(7.0)
    );
    
    auto evaluator = new ExpressionEvaluator();
    expr.accept(evaluator);
    
    assert(evaluator.result() == 42.0);
}

@safe unittest {
    // Test complex expression
    auto expr = new AddExpression(
        new MultiplyExpression(
            new NumberExpression(2.0),
            new NumberExpression(3.0)
        ),
        new NumberExpression(4.0)
    );
    
    auto evaluator = new ExpressionEvaluator();
    expr.accept(evaluator);
    
    assert(evaluator.result() == 10.0);
}

@safe unittest {
    // Test object structure accept visitor
    class E : BaseElement {
        this(string name) @safe { super(name); }
        override void accept(IVisitor visitor) {
            visitor.visit(this);
        }
    }
    
    class CountVisitor : BaseVisitor {
        int count = 0;
        override void visit(IElement element) {
            count++;
            _visited ~= element.name;
        }
    }
    
    auto structure = new ObjectStructure();
    structure.addElement(new E("E1"));
    structure.addElement(new E("E2"));
    structure.addElement(new E("E3"));
    
    auto visitor = new CountVisitor();
    structure.accept(visitor);
    
    assert(visitor.count == 3);
}

@safe unittest {
    // Test visitor visited tracking
    class Elem : BaseElement {
        this(string name) @safe { super(name); }
        override void accept(IVisitor visitor) {
            visitor.visit(this);
        }
    }
    
    class TrackingVisitor : BaseVisitor {
        override void visit(IElement element) {
            _visited ~= element.name;
        }
    }
    
    auto elem1 = new Elem("First");
    auto elem2 = new Elem("Second");
    auto elem3 = new Elem("Third");
    
    auto visitor = new TrackingVisitor();
    elem1.accept(visitor);
    elem2.accept(visitor);
    elem3.accept(visitor);
    
    auto visited = visitor.visited();
    assert(visited.length == 3);
    assert(visited[0] == "First");
    assert(visited[1] == "Second");
    assert(visited[2] == "Third");
}

@safe unittest {
    // Test shape area accuracy
    auto circle = new Circle("C", 10.0);
    double circleArea = circle.area();
    
    assert(circleArea > 314.0 && circleArea < 315.0);
}

@safe unittest {
    // Test nested directory structure
    auto root = new DirectoryElement("root");
    auto dir1 = new DirectoryElement("dir1");
    auto dir2 = new DirectoryElement("dir2");
    auto file1 = new FileElement("file1.txt", 100);
    auto file2 = new FileElement("file2.txt", 200);
    auto file3 = new FileElement("file3.txt", 300);
    
    dir1.addChild(file1);
    dir1.addChild(file2);
    dir2.addChild(file3);
    root.addChild(dir1);
    root.addChild(dir2);
    
    auto calculator = new SizeCalculator();
    root.accept(calculator);
    
    assert(calculator.totalSize() == 600);
    
    auto counter = new FileCounter();
    root.accept(counter);
    
    assert(counter.fileCount() == 3);
    assert(counter.dirCount() == 3);
}
