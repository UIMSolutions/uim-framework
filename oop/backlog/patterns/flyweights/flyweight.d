/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.patterns.flyweights.flyweight;

import uim.oop;

@safe:
/**
 * Concrete flyweight storing intrinsic (shared) state.
 */
class ConcreteFlyweight : IFlyweight {
    private string _intrinsicState;
    
    this(string intrinsicState) {
        _intrinsicState = intrinsicState;
    }
    
    @property string intrinsicState() const {
        return _intrinsicState;
    }
    
    string operation(string extrinsicState) {
        return format("ConcreteFlyweight[%s] with extrinsic: %s", _intrinsicState, extrinsicState);
    }
}

/**
 * Unshared concrete flyweight (not shared in factory).
 * Used for objects that don't benefit from sharing.
 */
class UnsharedConcreteFlyweight : IFlyweight {
    private string _allState;
    
    this(string allState) {
        _allState = allState;
    }
    
    string operation(string extrinsicState) {
        return format("UnsharedFlyweight[%s] with: %s", _allState, extrinsicState);
    }
}

/**
 * Generic flyweight with typed extrinsic state.
 */
class GenericFlyweight(TExtrinsic) : IGenericFlyweight!TExtrinsic {
    private string _key;
    private string _sharedData;
    
    this(string key, string sharedData) {
        _key = key;
        _sharedData = sharedData;
    }
    
    string operation(TExtrinsic extrinsicState) {
        static if (is(TExtrinsic == struct) || is(TExtrinsic == class)) {
            return format("Flyweight[%s](%s) operating on complex state", _key, _sharedData);
        } else {
            return format("Flyweight[%s](%s) with extrinsic: %s", _key, _sharedData, extrinsicState);
        }
    }
    
    string key() const {
        return _key;
    }
    
    @property string sharedData() const {
        return _sharedData;
    }
}

/**
 * Flyweight factory manages and reuses flyweight instances.
 */
class FlyweightFactory : IFlyweightFactory!ConcreteFlyweight {
    private ConcreteFlyweight[string] _flyweights;
    
    ConcreteFlyweight getFlyweight(string key) {
        if (auto fw = key in _flyweights) {
            return *fw;
        }
        
        auto newFlyweight = new ConcreteFlyweight(key);
        _flyweights[key] = newFlyweight;
        return newFlyweight;
    }
    
    size_t flyweightCount() const {
        return _flyweights.length;
    }
    
    string[] listFlyweights() const {
        return _flyweights.keys.dup;
    }
}

/**
 * Generic flyweight factory.
 */
class GenericFlyweightFactory(T, TExtrinsic) : IFlyweightFactory!(GenericFlyweight!TExtrinsic) {
    private GenericFlyweight!TExtrinsic[string] _flyweights;
    
    GenericFlyweight!TExtrinsic getFlyweight(string key) {
        if (auto fw = key in _flyweights) {
            return *fw;
        }
        
        auto newFlyweight = new GenericFlyweight!TExtrinsic(key, key);
        _flyweights[key] = newFlyweight;
        return newFlyweight;
    }
    
    size_t flyweightCount() const {
        return _flyweights.length;
    }
    
    string[] listFlyweights() const {
        return _flyweights.keys.dup;
    }
}



// Tree rendering example

/**
 * Tree type flyweight (intrinsic state).
 */
class TreeType : IMemoryReportable {
    private string _name;
    private string _color;
    private string _texture;
    
    this(string name, string color, string texture) {
        _name = name;
        _color = color;
        _texture = texture;
    }
    
    @property string name() const { return _name; }
    @property string color() const { return _color; }
    @property string texture() const { return _texture; }
    
    string draw(int x, int y, int height) {
        return format("%s tree at (%d,%d) height=%d, color=%s", 
                     _name, x, y, height, _color);
    }
    
    size_t memoryUsage() const {
        return _name.length + _color.length + _texture.length;
    }
}

/**
 * Tree factory for managing tree type flyweights.
 */
class TreeFactory {
    private TreeType[string] _treeTypes;
    
    TreeType getTreeType(string name, string color, string texture) {
        string key = name ~ "-" ~ color;
        
        if (auto treeType = key in _treeTypes) {
            return *treeType;
        }
        
        auto newType = new TreeType(name, color, texture);
        _treeTypes[key] = newType;
        return newType;
    }
    
    size_t typeCount() const {
        return _treeTypes.length;
    }
}

/**
 * Tree instance with extrinsic state.
 */
struct Tree {
    int x;
    int y;
    int height;
    TreeType treeType;
    
    string draw() {
        return treeType.draw(x, y, height);
    }
}

/**
 * Forest containing many trees using flyweight pattern.
 */
class Forest {
    private Tree[] _trees;
    private TreeFactory _treeFactory;
    
    this() {
        _treeFactory = new TreeFactory();
    }
    
    void plantTree(int x, int y, int height, string name, string color, string texture) {
        auto treeType = _treeFactory.getTreeType(name, color, texture);
        _trees ~= Tree(x, y, height, treeType);
    }
    
    string draw() {
        string result = "Forest rendering:\n";
        foreach (tree; _trees) {
            result ~= tree.draw() ~ "\n";
        }
        return result;
    }
    
    size_t treeCount() const {
        return _trees.length;
    }
    
    size_t uniqueTreeTypes() const {
        return _treeFactory.typeCount();
    }
}

@safe unittest {
    // Test basic flyweight factory
    auto factory = new FlyweightFactory();
    auto fw1 = factory.getFlyweight("A");
    auto fw2 = factory.getFlyweight("A");
    auto fw3 = factory.getFlyweight("B");
    
    assert(fw1 is fw2, "Same key should return same instance");
    assert(fw1 !is fw3, "Different keys should return different instances");
    assert(factory.flyweightCount() == 2);
}

@safe unittest {
    // Test flyweight operation
    auto factory = new FlyweightFactory();
    auto fw = factory.getFlyweight("SharedState");
    
    string result1 = fw.operation("Context1");
    string result2 = fw.operation("Context2");
    
    assert(result1.length > 0);
    assert(result2.length > 0);
    assert(result1 != result2);
}

@safe unittest {
    // Test generic flyweight
    auto fw = new GenericFlyweight!int("key1", "shared");
    string result = fw.operation(42);
    
    assert(result.length > 0);
    assert(fw.key() == "key1");
}

@safe unittest {
    // Test glyph factory reuse
    auto glyphFactory = new GlyphFactory();
    
    auto glyph1 = glyphFactory.getGlyph('A', "Arial", 12);
    auto glyph2 = glyphFactory.getGlyph('A', "Arial", 12);
    auto glyph3 = glyphFactory.getGlyph('B', "Arial", 12);
    
    assert(glyph1 is glyph2, "Same character should reuse glyph");
    assert(glyph1 !is glyph3, "Different characters have different glyphs");
    assert(glyphFactory.glyphCount() == 2);
}

@safe unittest {
    // Test text document
    auto doc = new TextDocument();
    doc.addCharacter('H', 0, 0, "black");
    doc.addCharacter('e', 10, 0, "black");
    doc.addCharacter('l', 20, 0, "black");
    doc.addCharacter('l', 30, 0, "black");
    doc.addCharacter('o', 40, 0, "black");
    
    assert(doc.characterCount() == 5);
    assert(doc.uniqueGlyphCount() == 4); // H, e, l, o (l is shared)
    
    string rendered = doc.render();
    assert(rendered.length > 0);
}

@safe unittest {
    // Test tree factory
    auto treeFactory = new TreeFactory();
    
    auto oak1 = treeFactory.getTreeType("Oak", "Green", "oak.png");
    auto oak2 = treeFactory.getTreeType("Oak", "Green", "oak.png");
    auto pine = treeFactory.getTreeType("Pine", "DarkGreen", "pine.png");
    
    assert(oak1 is oak2, "Same tree type should be reused");
    assert(oak1 !is pine, "Different tree types are different");
    assert(treeFactory.typeCount() == 2);
}

@safe unittest {
    // Test forest with many trees
    auto forest = new Forest();
    
    // Plant 100 oak trees
    foreach (i; 0..100) {
        forest.plantTree(i * 10, i * 5, 20 + i % 10, "Oak", "Green", "oak.png");
    }
    
    // Plant 50 pine trees
    foreach (i; 0..50) {
        forest.plantTree(i * 15, i * 8, 30 + i % 15, "Pine", "DarkGreen", "pine.png");
    }
    
    assert(forest.treeCount() == 150);
    assert(forest.uniqueTreeTypes() == 2, "Should only have 2 tree types despite 150 trees");
}

@safe unittest {
    // Test memory efficiency
    auto doc = new TextDocument();
    
    // Add 1000 'A' characters at different positions
    foreach (i; 0..1000) {
        doc.addCharacter('A', i, 0, "black");
    }
    
    assert(doc.characterCount() == 1000);
    assert(doc.uniqueGlyphCount() == 1, "All share the same glyph");
}

@safe unittest {
    // Test list flyweights
    auto factory = new FlyweightFactory();
    factory.getFlyweight("Alpha");
    factory.getFlyweight("Beta");
    factory.getFlyweight("Gamma");
    
    auto list = factory.listFlyweights();
    assert(list.length == 3);
}

import std.algorithm : canFind;
