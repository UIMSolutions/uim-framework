module uim.oop.patterns.flyweights.examples.glyphdata;

import uim.oop;

mixin(ShowModule!());

@safe:

// Real-world example: Character rendering with shared glyph data

/**
 * Character glyph (intrinsic state) - shared among all characters with same glyph.
 */
class CharacterGlyph : IMemoryReportable {
    private char _character;
    private string _fontFamily;
    private int _fontSize;
    private ubyte[] _glyphBitmap;  // Simulated bitmap data
    
    this(char character, string fontFamily, int fontSize) {
        _character = character;
        _fontFamily = fontFamily;
        _fontSize = fontSize;
        // Simulate bitmap data (in reality, this would be actual glyph rendering)
        _glyphBitmap = new ubyte[fontSize * fontSize];
    }
    
    @property char character() const { return _character; }
    @property string fontFamily() const { return _fontFamily; }
    @property int fontSize() const { return _fontSize; }
    
    string render(int x, int y, string color) {
        return format("'%s' at (%d,%d) in %s %dpt, color: %s", 
                     _character, x, y, _fontFamily, _fontSize, color);
    }
    
    size_t memoryUsage() const {
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
    
    private static string makeKey(char c, string fontFamily, int fontSize) {
        return format("%s-%s-%d", c, fontFamily, fontSize);
    }
    
    CharacterGlyph getGlyph(char character, string fontFamily, int fontSize) {
        string key = makeKey(character, fontFamily, fontSize);
        
        if (auto glyph = key in _glyphs) {
            return *glyph;
        }
        
        auto newGlyph = new CharacterGlyph(character, fontFamily, fontSize);
        _glyphs[key] = newGlyph;
        return newGlyph;
    }
    
    size_t glyphCount() const {
        return _glyphs.length;
    }
    
    size_t totalMemoryUsage() const {
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
    
    this() {
        _glyphFactory = new GlyphFactory();
    }
    
    void addCharacter(char c, int x, int y, string color, string fontFamily = "Arial", int fontSize = 12) {
        auto glyph = _glyphFactory.getGlyph(c, fontFamily, fontSize);
        _characters ~= CharacterInstance(glyph, CharacterContext(x, y, color));
    }
    
    string render() {
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
    
    size_t characterCount() const {
        return _characters.length;
    }
    
    size_t uniqueGlyphCount() const {
        return _glyphFactory.glyphCount();
    }
    
    size_t memoryUsage() const {
        // Shared glyph memory
        size_t sharedMemory = _glyphFactory.totalMemoryUsage();
        
        // Context memory (per character)
        size_t contextMemory = _characters.length * CharacterContext.sizeof;
        
        return sharedMemory + contextMemory;
    }
}