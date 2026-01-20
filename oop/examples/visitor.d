module oop.examples.visitor;

import std.stdio;
import uim.oop.patterns.visitors;

void main() {
    writeln("=== Visitor Pattern Examples ===\n");
    
    // Example 1: Shape Operations
    writeln("1. Shape Rendering and Calculations:");
    auto circle = new Circle("Circle1", 5.0);
    auto rectangle = new Rectangle("Rect1", 4.0, 3.0);
    auto triangle = new Triangle("Triangle1", 6.0, 4.0);
    
    writeln("   Shapes created:");
    writeln("     - ", circle.name, " (radius: ", circle.radius(), ")");
    writeln("     - ", rectangle.name, " (", rectangle.width(), "x", rectangle.height(), ")");
    writeln("     - ", triangle.name, " (base: ", triangle.baseLength(), ", height: ", triangle.height(), ")");
    
    // Calculate total area
    auto areaCalc = new AreaCalculator();
    circle.accept(areaCalc);
    rectangle.accept(areaCalc);
    triangle.accept(areaCalc);
    
    writeln("\n   Total area: ", areaCalc.totalArea());
    
    // Calculate total perimeter
    auto perimCalc = new PerimeterCalculator();
    circle.accept(perimCalc);
    rectangle.accept(perimCalc);
    triangle.accept(perimCalc);
    
    writeln("   Total perimeter: ", perimCalc.totalPerimeter());
    
    // Generate drawing commands
    auto drawer = new DrawingVisitor();
    circle.accept(drawer);
    rectangle.accept(drawer);
    triangle.accept(drawer);
    
    writeln("\n   Drawing commands:");
    foreach (cmd; drawer.commands()) {
        writeln("     ", cmd);
    }
    writeln();
    
    // Example 2: File System Operations
    writeln("2. File System Analysis:");
    auto root = new DirectoryElement("root");
    auto documents = new DirectoryElement("documents");
    auto images = new DirectoryElement("images");
    
    auto doc1 = new FileElement("readme.txt", 1024);
    auto doc2 = new FileElement("notes.txt", 2048);
    auto img1 = new FileElement("photo1.jpg", 5120);
    auto img2 = new FileElement("photo2.jpg", 6144);
    auto config = new FileElement("config.ini", 512);
    
    documents.addChild(doc1);
    documents.addChild(doc2);
    images.addChild(img1);
    images.addChild(img2);
    root.addChild(documents);
    root.addChild(images);
    root.addChild(config);
    
    writeln("   File system structure created");
    
    // Calculate total size
    auto sizeCalc = new SizeCalculator();
    root.accept(sizeCalc);
    writeln("\n   Total size: ", sizeCalc.totalSize(), " bytes");
    
    // Count files and directories
    auto counter = new FileCounter();
    root.accept(counter);
    writeln("   Files: ", counter.fileCount());
    writeln("   Directories: ", counter.dirCount());
    
    // List all files
    auto lister = new FileLister();
    root.accept(lister);
    writeln("\n   File listing:");
    foreach (listing; lister.listings()) {
        writeln("   ", listing);
    }
    writeln();
    
    // Example 3: Expression Evaluation
    writeln("3. Expression Tree Evaluation:");
    
    // Expression: (5 + 3) * 2
    auto expr1 = new MultiplyExpression(
        new AddExpression(
            new NumberExpression(5.0),
            new NumberExpression(3.0)
        ),
        new NumberExpression(2.0)
    );
    
    auto evaluator1 = new ExpressionEvaluator();
    expr1.accept(evaluator1);
    writeln("   Expression: (5 + 3) * 2 = ", evaluator1.result());
    
    // Expression: 10 + (4 * 3)
    auto expr2 = new AddExpression(
        new NumberExpression(10.0),
        new MultiplyExpression(
            new NumberExpression(4.0),
            new NumberExpression(3.0)
        )
    );
    
    auto evaluator2 = new ExpressionEvaluator();
    expr2.accept(evaluator2);
    writeln("   Expression: 10 + (4 * 3) = ", evaluator2.result());
    
    // Expression: (2 * 3) + (4 * 5)
    auto expr3 = new AddExpression(
        new MultiplyExpression(
            new NumberExpression(2.0),
            new NumberExpression(3.0)
        ),
        new MultiplyExpression(
            new NumberExpression(4.0),
            new NumberExpression(5.0)
        )
    );
    
    auto evaluator3 = new ExpressionEvaluator();
    expr3.accept(evaluator3);
    writeln("   Expression: (2 * 3) + (4 * 5) = ", evaluator3.result());
    writeln();
    
    // Example 4: Object Structure with Visitor
    writeln("4. Object Structure with Multiple Visitors:");
    auto structure = new ObjectStructure();
    
    auto shape1 = new Circle("SmallCircle", 3.0);
    auto shape2 = new Rectangle("LargeRect", 10.0, 8.0);
    auto shape3 = new Triangle("MediumTri", 7.0, 5.0);
    
    structure.addElement(shape1);
    structure.addElement(shape2);
    structure.addElement(shape3);
    
    writeln("   Object structure contains ", structure.elementCount(), " shapes");
    
    // Apply area calculator
    auto areaVisitor = new AreaCalculator();
    structure.accept(areaVisitor);
    writeln("\n   Total area (via structure): ", areaVisitor.totalArea());
    writeln("   Visited: ", areaVisitor.visited());
    
    // Apply drawing visitor
    auto drawVisitor = new DrawingVisitor();
    structure.accept(drawVisitor);
    writeln("\n   Drawing commands (via structure):");
    foreach (cmd; drawVisitor.commands()) {
        writeln("     ", cmd);
    }
    writeln();
    
    // Example 5: Complex File System
    writeln("5. Complex File System with Nested Directories:");
    auto projectRoot = new DirectoryElement("MyProject");
    
    auto srcDir = new DirectoryElement("src");
    auto testsDir = new DirectoryElement("tests");
    auto docsDir = new DirectoryElement("docs");
    
    auto mainFile = new FileElement("main.d", 2048);
    auto utilsFile = new FileElement("utils.d", 1536);
    
    auto test1 = new FileElement("test_main.d", 1024);
    auto test2 = new FileElement("test_utils.d", 896);
    
    auto readme = new FileElement("README.md", 3072);
    auto license = new FileElement("LICENSE", 512);
    
    srcDir.addChild(mainFile);
    srcDir.addChild(utilsFile);
    
    testsDir.addChild(test1);
    testsDir.addChild(test2);
    
    docsDir.addChild(readme);
    
    projectRoot.addChild(srcDir);
    projectRoot.addChild(testsDir);
    projectRoot.addChild(docsDir);
    projectRoot.addChild(license);
    
    writeln("   Project structure:");
    auto projectLister = new FileLister();
    projectRoot.accept(projectLister);
    foreach (listing; projectLister.listings()) {
        writeln("   ", listing);
    }
    
    auto projectSize = new SizeCalculator();
    projectRoot.accept(projectSize);
    writeln("\n   Total project size: ", projectSize.totalSize(), " bytes");
    
    auto projectCounter = new FileCounter();
    projectRoot.accept(projectCounter);
    writeln("   Total files: ", projectCounter.fileCount());
    writeln("   Total directories: ", projectCounter.dirCount());
    writeln();
    
    // Example 6: Benefits of Visitor Pattern
    writeln("6. Benefits of Visitor Pattern:");
    writeln("   ✓ Separates algorithm from object structure");
    writeln("   ✓ Easy to add new operations (new visitors)");
    writeln("   ✓ Gathers related operations in one place");
    writeln("   ✓ Can visit elements of different types");
    writeln("   ✓ Accumulates state while visiting");
    writeln();
    
    writeln("   Without Visitor Pattern:");
    writeln("   - Each element class has methods for all operations");
    writeln("   - Adding new operation requires modifying all classes");
    writeln("   - Operations scattered across many classes");
    writeln();
    
    writeln("   With Visitor Pattern:");
    writeln("   - Operations grouped in visitor classes");
    writeln("   - New operations = new visitor class");
    writeln("   - Element classes remain unchanged");
    writeln();
    
    // Example 7: Visitor Statistics
    writeln("7. Visitor Pattern Statistics:");
    
    auto statsStructure = new ObjectStructure();
    statsStructure.addElement(new Circle("C1", 5.0));
    statsStructure.addElement(new Circle("C2", 7.0));
    statsStructure.addElement(new Rectangle("R1", 4.0, 6.0));
    statsStructure.addElement(new Rectangle("R2", 3.0, 8.0));
    statsStructure.addElement(new Triangle("T1", 5.0, 4.0));
    
    auto statsCalc = new AreaCalculator();
    statsStructure.accept(statsCalc);
    
    writeln("   Analyzed ", statsStructure.elementCount(), " shapes");
    writeln("   Combined area: ", statsCalc.totalArea());
    writeln("   Average area per shape: ", statsCalc.totalArea() / statsStructure.elementCount());
    writeln();
    
    // Example 8: Real-world Application
    writeln("8. Real-world Application - Build System:");
    writeln("   Imagine a build system that:");
    writeln("   - Counts source files (FileCounter visitor)");
    writeln("   - Calculates total project size (SizeCalculator visitor)");
    writeln("   - Generates file lists (FileLister visitor)");
    writeln("   - All without modifying file/directory classes");
    writeln();
    
    writeln("   Additional visitors could:");
    writeln("   - Check for large files");
    writeln("   - Find files modified recently");
    writeln("   - Calculate code complexity");
    writeln("   - Generate documentation");
    writeln("   - All by adding new visitor classes!");
}
