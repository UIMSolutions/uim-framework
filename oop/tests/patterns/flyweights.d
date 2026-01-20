module oop.tests.patterns.flyweights;

import uim.oop.patterns.flyweights;
import std.algorithm : canFind;

@safe unittest {
    // Test basic flyweight factory creation
    auto factory = new FlyweightFactory();
    assert(factory !is null);
    assert(factory.flyweightCount() == 0);
}

@safe unittest {
    // Test flyweight reuse
    auto factory = new FlyweightFactory();
    
    auto fw1 = factory.getFlyweight("StateA");
    auto fw2 = factory.getFlyweight("StateA");
    auto fw3 = factory.getFlyweight("StateB");
    
    assert(fw1 is fw2, "Same key should return same flyweight instance");
    assert(fw1 !is fw3, "Different keys should return different instances");
    assert(factory.flyweightCount() == 2);
}

@safe unittest {
    // Test flyweight operation with different extrinsic states
    auto factory = new FlyweightFactory();
    auto fw = factory.getFlyweight("Shared");
    
    string result1 = fw.operation("Context1");
    string result2 = fw.operation("Context2");
    
    assert(result1.length > 0);
    assert(result2.length > 0);
    assert(result1 != result2, "Different extrinsic states produce different results");
}

@safe unittest {
    // Test multiple flyweights with different intrinsic states
    auto factory = new FlyweightFactory();
    
    auto fwA = factory.getFlyweight("A");
    auto fwB = factory.getFlyweight("B");
    auto fwC = factory.getFlyweight("C");
    
    assert(fwA.intrinsicState == "A");
    assert(fwB.intrinsicState == "B");
    assert(fwC.intrinsicState == "C");
    assert(factory.flyweightCount() == 3);
}

@safe unittest {
    // Test unshared flyweight
    auto unshared1 = new UnsharedConcreteFlyweight("unique1");
    auto unshared2 = new UnsharedConcreteFlyweight("unique2");
    
    assert(unshared1 !is unshared2);
    
    string result1 = unshared1.operation("test");
    string result2 = unshared2.operation("test");
    
    assert(result1 != result2);
}

@safe unittest {
    // Test generic flyweight
    auto fw = new GenericFlyweight!int("key1", "sharedData");
    
    assert(fw.key() == "key1");
    assert(fw.sharedData == "sharedData");
    
    string result = fw.operation(42);
    assert(result.length > 0);
}

@safe unittest {
    // Test generic flyweight factory
    auto factory = new GenericFlyweightFactory!(string, int)();
    
    auto fw1 = factory.getFlyweight("type1");
    auto fw2 = factory.getFlyweight("type1");
    auto fw3 = factory.getFlyweight("type2");
    
    assert(fw1 is fw2);
    assert(fw1 !is fw3);
    assert(factory.flyweightCount() == 2);
}

@safe unittest {
    // Test glyph factory basic functionality
    auto glyphFactory = new GlyphFactory();
    
    auto glyphA = glyphFactory.getGlyph('A', "Arial", 12);
    auto glyphB = glyphFactory.getGlyph('B', "Arial", 12);
    
    assert(glyphA !is null);
    assert(glyphB !is null);
    assert(glyphA !is glyphB);
    assert(glyphFactory.glyphCount() == 2);
}

@safe unittest {
    // Test glyph reuse with same parameters
    auto glyphFactory = new GlyphFactory();
    
    auto glyph1 = glyphFactory.getGlyph('X', "Times", 14);
    auto glyph2 = glyphFactory.getGlyph('X', "Times", 14);
    
    assert(glyph1 is glyph2, "Same glyph should be reused");
    assert(glyphFactory.glyphCount() == 1);
}

@safe unittest {
    // Test glyph with different fonts
    auto glyphFactory = new GlyphFactory();
    
    auto glyphArial = glyphFactory.getGlyph('A', "Arial", 12);
    auto glyphTimes = glyphFactory.getGlyph('A', "Times", 12);
    auto glyphArialBig = glyphFactory.getGlyph('A', "Arial", 18);
    
    assert(glyphArial !is glyphTimes);
    assert(glyphArial !is glyphArialBig);
    assert(glyphFactory.glyphCount() == 3);
}

@safe unittest {
    // Test text document character addition
    auto doc = new TextDocument();
    
    doc.addCharacter('H', 0, 0, "black");
    doc.addCharacter('i', 10, 0, "black");
    
    assert(doc.characterCount() == 2);
    assert(doc.uniqueGlyphCount() == 2);
}

@safe unittest {
    // Test text document with repeated characters
    auto doc = new TextDocument();
    
    doc.addCharacter('A', 0, 0, "red");
    doc.addCharacter('A', 10, 0, "blue");
    doc.addCharacter('A', 20, 0, "green");
    doc.addCharacter('B', 30, 0, "red");
    
    assert(doc.characterCount() == 4);
    assert(doc.uniqueGlyphCount() == 2, "Only 2 unique glyphs (A and B)");
}

@safe unittest {
    // Test text document rendering
    auto doc = new TextDocument();
    
    doc.addCharacter('T', 0, 0, "black");
    doc.addCharacter('e', 10, 0, "black");
    doc.addCharacter('s', 20, 0, "black");
    doc.addCharacter('t', 30, 0, "black");
    
    string rendered = doc.render();
    assert(rendered.length > 0);
    assert(rendered.indexOf("Document rendering") >= 0);
}

@safe unittest {
    // Test large text document efficiency
    auto doc = new TextDocument();
    
    // Add 1000 characters, many repeated
    foreach (i; 0..1000) {
        char c = cast(char)('A' + (i % 26));
        doc.addCharacter(c, i, 0, "black");
    }
    
    assert(doc.characterCount() == 1000);
    assert(doc.uniqueGlyphCount() == 26, "Only 26 unique glyphs despite 1000 characters");
}

@safe unittest {
    // Test tree factory
    auto treeFactory = new TreeFactory();
    
    auto oak = treeFactory.getTreeType("Oak", "Green", "oak.png");
    auto pine = treeFactory.getTreeType("Pine", "DarkGreen", "pine.png");
    
    assert(oak !is null);
    assert(pine !is null);
    assert(oak !is pine);
    assert(treeFactory.typeCount() == 2);
}

@safe unittest {
    // Test tree type reuse
    auto treeFactory = new TreeFactory();
    
    auto oak1 = treeFactory.getTreeType("Oak", "Green", "oak.png");
    auto oak2 = treeFactory.getTreeType("Oak", "Green", "oak.png");
    
    assert(oak1 is oak2, "Same tree type should be reused");
    assert(treeFactory.typeCount() == 1);
}

@safe unittest {
    // Test forest creation
    auto forest = new Forest();
    
    forest.plantTree(10, 20, 30, "Oak", "Green", "oak.png");
    forest.plantTree(50, 60, 40, "Pine", "DarkGreen", "pine.png");
    
    assert(forest.treeCount() == 2);
    assert(forest.uniqueTreeTypes() == 2);
}

@safe unittest {
    // Test forest with many trees of same type
    auto forest = new Forest();
    
    foreach (i; 0..100) {
        forest.plantTree(i * 10, i * 5, 25, "Oak", "Green", "oak.png");
    }
    
    assert(forest.treeCount() == 100);
    assert(forest.uniqueTreeTypes() == 1, "All trees share same type");
}

@safe unittest {
    // Test forest with mixed tree types
    auto forest = new Forest();
    
    foreach (i; 0..50) {
        forest.plantTree(i * 10, i * 5, 20, "Oak", "Green", "oak.png");
    }
    
    foreach (i; 0..50) {
        forest.plantTree(i * 15, i * 8, 35, "Pine", "DarkGreen", "pine.png");
    }
    
    foreach (i; 0..30) {
        forest.plantTree(i * 12, i * 6, 28, "Birch", "White", "birch.png");
    }
    
    assert(forest.treeCount() == 130);
    assert(forest.uniqueTreeTypes() == 3);
}

@safe unittest {
    // Test forest rendering
    auto forest = new Forest();
    
    forest.plantTree(0, 0, 10, "Oak", "Green", "oak.png");
    forest.plantTree(20, 30, 15, "Pine", "DarkGreen", "pine.png");
    
    string rendered = forest.draw();
    assert(rendered.length > 0);
    assert(rendered.indexOf("Forest rendering") >= 0);
}

@safe unittest {
    // Test list flyweights
    auto factory = new FlyweightFactory();
    
    factory.getFlyweight("Alpha");
    factory.getFlyweight("Beta");
    factory.getFlyweight("Gamma");
    
    auto list = factory.listFlyweights();
    assert(list.length == 3);
    assert(list.canFind("Alpha"));
    assert(list.canFind("Beta"));
    assert(list.canFind("Gamma"));
}

@safe unittest {
    // Test memory efficiency concept
    auto doc1 = new TextDocument();
    auto doc2 = new TextDocument();
    
    // Both documents use 'A' character
    doc1.addCharacter('A', 0, 0, "black");
    doc2.addCharacter('A', 100, 100, "red");
    
    // Each document tracks its own instances
    assert(doc1.characterCount() == 1);
    assert(doc2.characterCount() == 1);
    
    // But glyphs are created per document's factory
    assert(doc1.uniqueGlyphCount() == 1);
    assert(doc2.uniqueGlyphCount() == 1);
}

@safe unittest {
    // Test character glyph properties
    auto glyph = new CharacterGlyph('X', "Arial", 16);
    
    assert(glyph.character == 'X');
    assert(glyph.fontFamily == "Arial");
    assert(glyph.fontSize == 16);
    
    string rendered = glyph.render(10, 20, "blue");
    assert(rendered.length > 0);
}

@safe unittest {
    // Test tree type properties
    auto treeType = new TreeType("Maple", "Orange", "maple.png");
    
    assert(treeType.name == "Maple");
    assert(treeType.color == "Orange");
    assert(treeType.texture == "maple.png");
    
    string drawn = treeType.draw(100, 200, 50);
    assert(drawn.length > 0);
}

import std.string : indexOf;
