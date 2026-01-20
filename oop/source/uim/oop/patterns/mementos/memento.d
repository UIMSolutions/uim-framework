/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.mementos.memento;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Base memento implementation.
 */
class Memento : IMemento {
    private string _name;
    private SysTime _timestamp;
    
    this(string name) @safe {
        _name = name;
        _timestamp = Clock.currTime();
    }
    
    @safe string name() const {
        return _name;
    }
    
    @safe SysTime timestamp() const {
        return _timestamp;
    }
}



/**
 * Versioned memento with version tracking.
 */
class VersionedMemento : Memento, IVersionedMemento {
    private int _version;
    private string _description;
    
    this(string name, int ver, string desc) @safe {
        super(name);
        _version = ver;
        _description = desc;
    }
    
    @safe int version_() const {
        return _version;
    }
    
    @safe string description() const {
        return _description;
    }
}

// Real-world example: Text Editor



/**
 * History manager for text editor with undo support.
 */
class EditorHistory : IHistoryManager {
    private TextEditor _editor;
    private IMemento[] _history;
    
    this(TextEditor editor) @safe {
        _editor = editor;
    }
    
    @safe void backup() {
        _history ~= _editor.save();
    }
    
    @safe bool undo() {
        if (!canUndo()) {
            return false;
        }
        
        auto memento = _history[$-1];
        _history = _history[0..$-1];
        _editor.restore(memento);
        
        return true;
    }
    
    @safe bool canUndo() const {
        return _history.length > 0;
    }
    
    @safe size_t undoCount() const {
        return _history.length;
    }
}

// Real-world example: Game State

/**
 * Game character with save/load capability.
 */
class GameCharacter : IOriginator {
    private string _name;
    private int _health;
    private int _mana;
    private int _level;
    private int[string] _inventory;
    
    this(string name) @safe {
        _name = name;
        _health = 100;
        _mana = 50;
        _level = 1;
    }
    
    @safe void takeDamage(int damage) {
        _health -= damage;
        if (_health < 0) _health = 0;
    }
    
    @safe void useMana(int amount) {
        _mana -= amount;
        if (_mana < 0) _mana = 0;
    }
    
    @safe void levelUp() {
        _level++;
        _health += 10;
        _mana += 5;
    }
    
    @safe void addItem(string item, int quantity = 1) {
        if (item in _inventory) {
            _inventory[item] += quantity;
        } else {
            _inventory[item] = quantity;
        }
    }
    
    @safe string name() const {
        return _name;
    }
    
    @safe int health() const {
        return _health;
    }
    
    @safe int mana() const {
        return _mana;
    }
    
    @safe int level() const {
        return _level;
    }
    
    @safe int getItemCount(string item) const {
        if (item in _inventory) {
            return _inventory[item];
        }
        return 0;
    }
    
    @safe IMemento save() {
        return new GameCharacterMemento(_health, _mana, _level, _inventory.dup);
    }
    
    @safe void restore(IMemento memento) {
        auto gameMemento = cast(GameCharacterMemento)memento;
        if (gameMemento !is null) {
            _health = gameMemento.getHealth();
            _mana = gameMemento.getMana();
            _level = gameMemento.getLevel();
            _inventory = gameMemento.getInventory().dup;
        }
    }
    
    private static class GameCharacterMemento : Memento {
        private int _savedHealth;
        private int _savedMana;
        private int _savedLevel;
        private int[string] _savedInventory;
        
        this(int health, int mana, int level, int[string] inventory) @safe {
            super("GameCharacter");
            _savedHealth = health;
            _savedMana = mana;
            _savedLevel = level;
            _savedInventory = inventory;
        }
        
        @safe int getHealth() const {
            return _savedHealth;
        }
        
        @safe int getMana() const {
            return _savedMana;
        }
        
        @safe int getLevel() const {
            return _savedLevel;
        }
        
        @trusted int[string] getInventory() const {
            return cast(int[string])_savedInventory;
        }
    }
}



// Real-world example: Configuration Manager



/**
 * Multi-level undo manager with redo support.
 */
class MultiLevelUndoManager : IMultiLevelUndoManager {
    private IOriginator _originator;
    private IMemento[] _undoStack;
    private IMemento[] _redoStack;
    private string[] _undoDescriptions;
    private string[] _redoDescriptions;
    private IMemento _currentState;
    
    this(IOriginator originator) @safe {
        _originator = originator;
        _currentState = originator.save();
    }
    
    @safe void save(string description = "") {
        // Save current state to undo stack
        _undoStack ~= _currentState;
        _undoDescriptions ~= description;
        
        // Create new current state
        _currentState = _originator.save();
        
        // Clear redo stack
        _redoStack = [];
        _redoDescriptions = [];
    }
    
    @safe bool undo() {
        if (!canUndo()) {
            return false;
        }
        
        // Move current state to redo stack
        _redoStack ~= _currentState;
        _redoDescriptions ~= _undoDescriptions[$-1];
        
        // Restore previous state
        _currentState = _undoStack[$-1];
        _undoStack = _undoStack[0..$-1];
        _undoDescriptions = _undoDescriptions[0..$-1];
        
        _originator.restore(_currentState);
        
        return true;
    }
    
    @safe bool redo() {
        if (!canRedo()) {
            return false;
        }
        
        // Move current state to undo stack
        _undoStack ~= _currentState;
        _undoDescriptions ~= _redoDescriptions[$-1];
        
        // Restore next state
        _currentState = _redoStack[$-1];
        _redoStack = _redoStack[0..$-1];
        _redoDescriptions = _redoDescriptions[0..$-1];
        
        _originator.restore(_currentState);
        
        return true;
    }
    
    @safe bool canUndo() const {
        return _undoStack.length > 0;
    }
    
    @safe bool canRedo() const {
        return _redoStack.length > 0;
    }
    
    @safe string[] undoHistory() const {
        return _undoDescriptions.dup;
    }
    
    @safe string[] redoHistory() const {
        return _redoDescriptions.dup;
    }
}

// Unit tests

@safe unittest {
    // Test basic memento creation
    auto memento = new Memento("Test");
    assert(memento.name() == "Test");
    assert(memento.timestamp() <= Clock.currTime());
}

@safe unittest {
    // Test generic memento
    auto memento = new GenericMemento!int("Number", 42);
    assert(memento.name() == "Number");
    assert(memento.getState() == 42);
}

@safe unittest {
    // Test caretaker
    auto caretaker = new Caretaker();
    assert(caretaker.count() == 0);
    
    caretaker.addMemento(new Memento("M1"));
    assert(caretaker.count() == 1);
    
    caretaker.addMemento(new Memento("M2"));
    assert(caretaker.count() == 2);
    
    auto m = caretaker.getMemento(0);
    assert(m !is null);
    assert(m.name() == "M1");
}

@safe unittest {
    // Test text editor save/restore
    auto editor = new TextEditor();
    editor.setText("Hello");
    
    auto memento = editor.save();
    
    editor.setText("World");
    assert(editor.content() == "World");
    
    editor.restore(memento);
    assert(editor.content() == "Hello");
}

@safe unittest {
    // Test editor history
    auto editor = new TextEditor();
    auto history = new EditorHistory(editor);
    
    editor.setText("First");
    history.backup();
    
    editor.setText("Second");
    history.backup();
    
    editor.setText("Third");
    
    assert(editor.content() == "Third");
    assert(history.canUndo());
    
    history.undo();
    assert(editor.content() == "Second");
    
    history.undo();
    assert(editor.content() == "First");
}

@safe unittest {
    // Test game character save/restore
    auto character = new GameCharacter("Hero");
    assert(character.health() == 100);
    assert(character.level() == 1);
    
    auto memento = character.save();
    
    character.takeDamage(50);
    character.levelUp();
    
    assert(character.health() == 60);
    assert(character.level() == 2);
    
    character.restore(memento);
    assert(character.health() == 100);
    assert(character.level() == 1);
}

@safe unittest {
    // Test game save manager
    auto character = new GameCharacter("Hero");
    auto saveManager = new GameSaveManager(character);
    
    character.levelUp();
    saveManager.createSnapshot("level2");
    
    character.levelUp();
    saveManager.createSnapshot("level3");
    
    assert(saveManager.hasSnapshot("level2"));
    assert(saveManager.hasSnapshot("level3"));
    assert(!saveManager.hasSnapshot("level99"));
    
    character.levelUp();
    assert(character.level() == 4);
    
    saveManager.restoreSnapshot("level2");
    assert(character.level() == 2);
}

@safe unittest {
    // Test configuration save/restore
    auto config = new Configuration();
    config.set("theme", "dark");
    config.set("language", "en");
    
    auto memento = config.save();
    
    config.set("theme", "light");
    config.set("font", "Arial");
    
    assert(config.get("theme") == "light");
    assert(config.has("font"));
    
    config.restore(memento);
    assert(config.get("theme") == "dark");
    assert(!config.has("font"));
}

@safe unittest {
    // Test versioned memento
    auto memento = new VersionedMemento("V1", 1, "Initial version");
    assert(memento.version_() == 1);
    assert(memento.description() == "Initial version");
}
