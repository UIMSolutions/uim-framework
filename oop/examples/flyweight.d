module oop.examples.flyweight;

import std.stdio;
import uim.oop.patterns.flyweights;

void main() {
    writeln("=== Flyweight Pattern Examples ===\n");
    
    // Example 1: Basic Flyweight Pattern
    writeln("1. Basic Flyweight Factory:");
    auto factory = new FlyweightFactory();
    
    auto fw1 = factory.getFlyweight("Red");
    auto fw2 = factory.getFlyweight("Blue");
    auto fw3 = factory.getFlyweight("Red"); // Reuses fw1
    
    writeln("   Created flyweights, count: ", factory.flyweightCount());
    writeln("   fw1 is fw3: ", fw1 is fw3, " (both use 'Red')");
    writeln("   fw1 is fw2: ", fw1 is fw2, " (different colors)");
    
    writeln("\n   Using flyweights with different contexts:");
    writeln("   ", fw1.operation("Position(10,20)"));
    writeln("   ", fw1.operation("Position(30,40)"));
    writeln("   ", fw2.operation("Position(50,60)"));
    writeln();
    
    // Example 2: Text Document with Character Glyphs
    writeln("2. Text Document with Shared Glyphs:");
    auto doc = new TextDocument();
    
    string text = "Hello World!";
    int x = 0;
    foreach (c; text) {
        doc.addCharacter(c, x, 0, "black", "Arial", 12);
        x += 10;
    }
    
    writeln("   Text: '", text, "'");
    writeln("   Total characters: ", doc.characterCount());
    writeln("   Unique glyphs: ", doc.uniqueGlyphCount());
    writeln("   Memory savings: ", doc.characterCount() - doc.uniqueGlyphCount(), 
            " glyph objects saved!");
    writeln();
    
    // Example 3: Large Text Document
    writeln("3. Large Text Document (Memory Efficiency Demo):");
    auto largeDoc = new TextDocument();
    
    string paragraph = "The quick brown fox jumps over the lazy dog. " ~
                      "The quick brown fox jumps over the lazy dog. " ~
                      "The quick brown fox jumps over the lazy dog.";
    
    x = 0;
    int y = 0;
    foreach (c; paragraph) {
        largeDoc.addCharacter(c, x, y, "black", "Times", 12);
        x += 8;
        if (x > 400) {
            x = 0;
            y += 15;
        }
    }
    
    writeln("   Paragraph length: ", paragraph.length, " characters");
    writeln("   Unique glyphs needed: ", largeDoc.uniqueGlyphCount());
    writeln("   Reuse factor: ", paragraph.length / largeDoc.uniqueGlyphCount(), "x");
    writeln("   Estimated memory saved: ~", 
            (paragraph.length - largeDoc.uniqueGlyphCount()) * 200, " bytes");
    writeln();
    
    // Example 4: Forest with Many Trees
    writeln("4. Forest Simulation:");
    auto forest = new Forest();
    
    writeln("   Planting 1000 oak trees...");
    foreach (i; 0..1000) {
        forest.plantTree(i % 100 * 10, i / 100 * 20, 15 + i % 5, 
                        "Oak", "Green", "oak_texture.png");
    }
    
    writeln("   Planting 500 pine trees...");
    foreach (i; 0..500) {
        forest.plantTree(i % 50 * 15, i / 50 * 25, 25 + i % 8, 
                        "Pine", "DarkGreen", "pine_texture.png");
    }
    
    writeln("   Planting 300 birch trees...");
    foreach (i; 0..300) {
        forest.plantTree(i % 30 * 20, i / 30 * 30, 18 + i % 6, 
                        "Birch", "White", "birch_texture.png");
    }
    
    writeln("\n   Forest Statistics:");
    writeln("   Total trees: ", forest.treeCount());
    writeln("   Unique tree types: ", forest.uniqueTreeTypes());
    writeln("   Memory efficiency: ", forest.treeCount() / forest.uniqueTreeTypes(), 
            "x trees per type");
    writeln("   Instead of 1800 tree objects, we have only ", 
            forest.uniqueTreeTypes(), " shared type objects!");
    writeln();
    
    // Example 5: Rendering Sample Trees
    writeln("5. Sample Tree Rendering:");
    auto smallForest = new Forest();
    smallForest.plantTree(10, 20, 15, "Oak", "Green", "oak.png");
    smallForest.plantTree(50, 60, 25, "Pine", "DarkGreen", "pine.png");
    smallForest.plantTree(100, 80, 18, "Oak", "Green", "oak.png");
    smallForest.plantTree(150, 100, 30, "Birch", "White", "birch.png");
    
    writeln(smallForest.draw());
    writeln("   Note: The two Oak trees share the same TreeType object!");
    writeln();
    
    // Example 6: Multi-Font Document
    writeln("6. Multi-Font Document:");
    auto styledDoc = new TextDocument();
    
    x = 0;
    string title = "TITLE";
    foreach (c; title) {
        styledDoc.addCharacter(c, x, 0, "blue", "Arial", 24);
        x += 20;
    }
    
    x = 0;
    y = 30;
    string body = "Body text in different font";
    foreach (c; body) {
        styledDoc.addCharacter(c, x, y, "black", "Times", 12);
        x += 8;
    }
    
    writeln("   Title (Arial 24): '", title, "'");
    writeln("   Body (Times 12): '", body, "'");
    writeln("   Total characters: ", styledDoc.characterCount());
    writeln("   Unique glyphs: ", styledDoc.uniqueGlyphCount());
    writeln();
    
    // Example 7: Comparing With and Without Flyweight
    writeln("7. Memory Comparison (Conceptual):");
    
    writeln("\n   WITHOUT Flyweight Pattern:");
    writeln("   - 10,000 character objects");
    writeln("   - Each with full glyph data (bitmap, font info)");
    writeln("   - Estimated: 10,000 × 200 bytes = 2,000,000 bytes");
    
    writeln("\n   WITH Flyweight Pattern:");
    writeln("   - 10,000 character contexts (position, color)");
    writeln("   - 50 shared glyph objects (A-Z, a-z, punctuation)");
    writeln("   - Estimated: (10,000 × 20) + (50 × 200) = 210,000 bytes");
    writeln("   - Memory saved: ~90% reduction!");
    
    writeln();
    
    // Example 8: Generic Flyweight
    writeln("8. Generic Flyweight Example:");
    auto genericFactory = new GenericFlyweightFactory!(string, int)();
    
    auto fw10 = genericFactory.getFlyweight("Type1");
    auto fw11 = genericFactory.getFlyweight("Type2");
    auto fw12 = genericFactory.getFlyweight("Type1"); // Reuses fw10
    
    writeln("   Created generic flyweights, count: ", genericFactory.flyweightCount());
    writeln("   ", fw10.operation(100));
    writeln("   ", fw11.operation(200));
    writeln("   ", fw12.operation(300), " (reuses Type1)");
    writeln();
    
    // Example 9: Performance Implications
    writeln("9. Performance Benefits:");
    writeln("   ✓ Reduced memory footprint");
    writeln("   ✓ Faster object creation (reuse existing)");
    writeln("   ✓ Better cache performance (fewer unique objects)");
    writeln("   ✓ Ideal for objects with shared state");
    writeln();
    writeln("   Trade-offs:");
    writeln("   ✗ Slightly more complex code");
    writeln("   ✗ Need to manage extrinsic state separately");
    writeln("   ✗ Factory lookup overhead (usually minimal)");
}
