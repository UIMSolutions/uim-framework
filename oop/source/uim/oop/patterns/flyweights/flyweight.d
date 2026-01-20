module uim.oop.patterns.flyweights.flyweight;

import uim.oop.patterns.flyweights.interfaces;
import std.format;

/**
 * Concrete flyweight storing intrinsic (shared) state.
 */
class ConcreteFlyweight : IFlyweight {
    private string _intrinsicState;
    
    this(string intrinsicState) @safe {
        _intrinsicState = intrinsicState;
    }
    
    @property string intrinsicState() const @safe {
        return _intrinsicState;
    }
    
    string operation(string extrinsicState) @safe {
        return format("ConcreteFlyweight[%s] with extrinsic: %s", _intrinsicState, extrinsicState);
    }
}

/**
 * Unshared concrete flyweight (not shared in factory).
 * Used for objects that don't benefit from sharing.
 */
class UnsharedConcreteFlyweight : IFlyweight {
    private string _allState;
    
    this(string allState) @safe {
        _allState = allState;
    }
    
    string operation(string extrinsicState) @safe {
        return format("UnsharedFlyweight[%s] with: %s", _allState, extrinsicState);
    }
}

/**
 * Generic flyweight with typed extrinsic state.
 */
class GenericFlyweight(TExtrinsic) : IGenericFlyweight!TExtrinsic {
    private string _key;
    private string _sharedData;
    
    this(string key, string sharedData) @safe {
        _key = key;
        _sharedData = sharedData;
    }
    
    string operation(TExtrinsic extrinsicState) @safe {
        static if (is(TExtrinsic == struct) || is(TExtrinsic == class)) {
            return format("Flyweight[%s](%s) operating on complex state", _key, _sharedData);
        } else {
            return format("Flyweight[%s](%s) with extrinsic: %s", _key, _sharedData, extrinsicState);
        }
    }
    
    string key() const @safe {
        return _key;
    }
    
    @property string sharedData() const @safe {
        return _sharedData;
    }
}

/**
 * Flyweight factory manages and reuses flyweight instances.
 */
class FlyweightFactory : IFlyweightFactory!ConcreteFlyweight {
    private ConcreteFlyweight[string] _flyweights;
    
    ConcreteFlyweight getFlyweight(string key) @safe {
        if (auto fw = key in _flyweights) {
            return *fw;
        }
        
        auto newFlyweight = new ConcreteFlyweight(key);
        _flyweights[key] = newFlyweight;
        return newFlyweight;
    }
    
    size_t flyweightCount() const @safe {
        return _flyweights.length;
    }
    
    string[] listFlyweights() const @safe {
        return _flyweights.keys.dup;
    }
}

/**
 * Generic flyweight factory.
 */
class GenericFlyweightFactory(T, TExtrinsic) : IFlyweightFactory!(GenericFlyweight!TExtrinsic) {
    private GenericFlyweight!TExtrinsic[string] _flyweights;
    
    GenericFlyweight!TExtrinsic getFlyweight(string key) @safe {
        if (auto fw = key in _flyweights) {
            return *fw;
        }
        
        auto newFlyweight = new GenericFlyweight!TExtrinsic(key, key);
        _flyweights[key] = newFlyweight;
        return newFlyweight;
    }
    
    size_t flyweightCount() const @safe {
        return _flyweights.length;
    }
    
    string[] listFlyweights() const @safe {
        return _flyweights.keys.dup;
    }
}

// Real-world example: Character rendering with shared glyph data

/**
 * Character glyph (intrinsic state) - shared among all characters with same glyph.
 */
class CharacterGlyph : IMemoryReportable {
    private char _character;
    private string _fontFamily;
    private int _fontSize;
    private ubyte[] _glyphBitmap;  // Simulated bitmap data
    
    this(char character, string fontFamily, int fontSize) @safe {
        _character = character;
        _fontFamily = fontFamily;
        _fontSize = fontSize;
        // Simulate bitmap data (in reality, this would be actual glyph rendering)
        _glyphBitmap = new ubyte[fontSize * fontSize];
    }
    
    @property char character() const @safe { return _character; }
    @property string fontFamily() const @safe { return _fontFamily; }
    @property int fontSize() const @safe { return _fontSize; }
    
    string render(int x, int y, string color) @safe {
        return format("'%s' at (%d,%d) in %s %dpt, color: %s", 
                     _character, x, y, _fontFamily, _fontSize, color);
    }
    
    size_t memoryUsage() const @safe {
        return _glyphBitmap.length + _fontFamily.length + char.sizeof + int.sizeof;
    }
}

/**
 * Character context (extrinsic state) - unique for each character instance.
 */
struct CharacterContext {
    int x;
    int y;
    string color;
}

/**
 * Glyph factory manages shared glyph instances.
 */
class GlyphFactory {
    private CharacterGlyph[string] _glyphs;
    
    private static string makeKey(char c, string fontFamily, int fontSize) @safe {
        return format("%s-%s-%d", c, fontFamily, fontSize);
    }
    
    CharacterGlyph getGlyph(char character, string fontFamily, int fontSize) @safe {
        string key = makeKey(character, fontFamily, fontSize);
        
        if (auto glyph = key in _glyphs) {
            return *glyph;
        }
        
        auto newGlyph = new CharacterGlyph(character, fontFamily, fontSize);
        _glyphs[key] = newGlyph;
        return newGlyph;
    }
    
    size_t glyphCount() const @safe {
        return _glyphs.length;
    }
    
    size_t totalMemoryUsage() const @safe {
        size_t total = 0;
        foreach (glyph; _glyphs) {
            total += glyph.memoryUsage();
        }
        return total;
    }
}

/**
 * Text document using flyweight pattern for character rendering.
 */
class TextDocument {
    private struct CharacterInstance {
        CharacterGlyph glyph;
        CharacterContext context;
    }
    
    private CharacterInstance[] _characters;
    private GlyphFactory _glyphFactory;
    
    this() @safe {
        _glyphFactory = new GlyphFactory();
    }
    
    void addCharacter(char c, int x, int y, string color, string fontFamily = "Arial", int fontSize = 12) @safe {
        auto glyph = _glyphFactory.getGlyph(c, fontFamily, fontSize);
        _characters ~= CharacterInstance(glyph, CharacterContext(x, y, color));
    }
    
    string render() @safe {
        string result = "Document rendering:\n";
        foreach (charInst; _characters) {
            result ~= charInst.glyph.render(
                charInst.context.x, 
                charInst.context.y, 
                charInst.context.color
            ) ~ "\n";
        }
        return result;
    }
    
    size_t characterCount() const @safe {
        return _characters.length;
    }
    
    size_t uniqueGlyphCount() const @safe {
        return _glyphFactory.glyphCount();
    }
    
    size_t memoryUsage() const @safe {
        // Shared glyph memory
        size_t sharedMemory = _glyphFactory.totalMemoryUsage();
        
        // Context memory (per character)
        size_t contextMemory = _characters.length * CharacterContext.sizeof;
        
        return sharedMemory + contextMemory;
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
    
    this(string name, string color, string texture) @safe {
        _name = name;
        _color = color;
        _texture = texture;
    }
    
    @property string name() const @safe { return _name; }
    @property string color() const @safe { return _color; }
    @property string texture() const @safe { return _texture; }
    
    string draw(int x, int y, int height) @safe {
        return format("%s tree at (%d,%d) height=%d, color=%s", 
                     _name, x, y, height, _color);
    }
    
    size_t memoryUsage() const @safe {
        return _name.length + _color.length + _texture.length;
    }
}

/**
 * Tree factory for managing tree type flyweights.
 */
class TreeFactory {
    private TreeType[string] _treeTypes;
    
    TreeType getTreeType(string name, string color, string texture) @safe {
        string key = name ~ "-" ~ color;
        
        if (auto treeType = key in _treeTypes) {
            return *treeType;
        }
        
        auto newType = new TreeType(name, color, texture);
        _treeTypes[key] = newType;
        return newType;
    }
    
    size_t typeCount() const @safe {
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
    
    string draw() @safe {
        return treeType.draw(x, y, height);
    }
}

/**
 * Forest containing many trees using flyweight pattern.
 */
class Forest {
    private Tree[] _trees;
    private TreeFactory _treeFactory;
    
    this() @safe {
        _treeFactory = new TreeFactory();
    }
    
    void plantTree(int x, int y, int height, string name, string color, string texture) @safe {
        auto treeType = _treeFactory.getTreeType(name, color, texture);
        _trees ~= Tree(x, y, height, treeType);
    }
    
    string draw() @safe {
        string result = "Forest rendering:\n";
        foreach (tree; _trees) {
            result ~= tree.draw() ~ "\n";
        }
        return result;
    }
    
    size_t treeCount() const @safe {
        return _trees.length;
    }
    
    size_t uniqueTreeTypes() const @safe {
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
