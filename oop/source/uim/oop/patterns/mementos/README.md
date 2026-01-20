# Memento Pattern

## Purpose
The Memento Pattern is a behavioral design pattern that lets you save and restore the previous state of an object without revealing the details of its implementation. It provides the ability to restore an object to its previous state (undo via rollback) while maintaining encapsulation.

## Problem It Solves
- **State Restoration**: When you need to restore an object's state to a previous point in time
- **Undo/Redo**: When implementing undo/redo functionality in applications
- **Snapshots**: When you need to create checkpoints or savepoints in your application
- **Encapsulation**: When you want to preserve encapsulation boundaries while saving/restoring state
- **Transaction Rollback**: When operations need to be rolled back if they fail
- **Version Control**: When tracking multiple versions of an object's state

## UML Class Diagram
```
┌────────────────┐
│  <<interface>> │
│    IMemento    │
├────────────────┤
│ + name()       │
│ + timestamp()  │
└────────▲───────┘
         │
         │ implements
         │
┌────────┴───────┐         ┌──────────────────┐
│    Memento     │◄────────│  <<interface>>   │
├────────────────┤         │   IOriginator    │
│ - _name        │         ├──────────────────┤
│ - _timestamp   │         │ + save()         │
└────────────────┘         │ + restore()      │
                           └────────▲─────────┘
                                    │
                                    │ implements
                                    │
                           ┌────────┴─────────┐
                           │   Originator     │
                           ├──────────────────┤
                           │ - _state         │
                           ├──────────────────┤
                           │ + save()         │
                           │ + restore()      │
                           └──────────────────┘

┌──────────────────┐
│  <<interface>>   │           ┌──────────────┐
│   ICaretaker     │──────────►│  IMemento    │
├──────────────────┤  stores   └──────────────┘
│ + addMemento()   │
│ + getMemento()   │
│ + count()        │
│ + clear()        │
└──────────────────┘
```

## Components

### 1. IMemento
The memento interface that declares methods for retrieving metadata.
```d
interface IMemento {
    string name() const;
    SysTime timestamp() const;
}
```

### 2. IOriginator
Interface for objects that can create and restore from mementos.
```d
interface IOriginator {
    IMemento save();
    void restore(IMemento memento);
}
```

### 3. ICaretaker
Interface for managing a collection of mementos.
```d
interface ICaretaker {
    void addMemento(IMemento memento);
    IMemento getMemento(size_t index);
    size_t count() const;
    void clear();
}
```

### 4. Memento
Concrete memento storing an object's state.
```d
class Memento : IMemento {
    private string _name;
    private SysTime _timestamp;
    // Actual state stored in derived classes
}
```

### 5. IHistoryManager
Interface for managing undo operations.
```d
interface IHistoryManager {
    void backup();
    bool undo();
    bool canUndo() const;
    size_t undoCount() const;
}
```

### 6. ISnapshotManager
Interface for managing named snapshots.
```d
interface ISnapshotManager {
    void createSnapshot(string name);
    bool restoreSnapshot(string name);
    bool hasSnapshot(string name) const;
    string[] snapshotNames() const;
    bool deleteSnapshot(string name);
}
```

### 7. IMultiLevelUndoManager
Interface for multi-level undo/redo with history.
```d
interface IMultiLevelUndoManager {
    void save(string description = "");
    bool undo();
    bool redo();
    bool canUndo() const;
    bool canRedo() const;
    string[] undoHistory() const;
    string[] redoHistory() const;
}
```

## Real-World Examples

### Example 1: Text Editor with Undo
A text editor that supports undo operations:
```d
auto editor = new TextEditor();
auto history = new EditorHistory(editor);

// Type text
editor.setText("Hello");
history.backup();

editor.appendText(" World");
history.backup();

// Undo last change
history.undo();
// Content is back to "Hello"
```

**Key Features:**
- Stores both text content and cursor position
- History management with multiple undo levels
- Private memento class accessible only to TextEditor
- Efficient state storage

### Example 2: Game Save/Load System
A game with checkpoint and save system:
```d
auto character = new GameCharacter("Warrior");
auto saveManager = new GameSaveManager(character);

// Progress in game
character.levelUp();
character.addItem("Sword", 1);
saveManager.createSnapshot("checkpoint1");

// Continue playing
character.levelUp();
character.takeDamage(50);

// Load earlier save
saveManager.restoreSnapshot("checkpoint1");
// Character state restored to checkpoint1
```

**Key Features:**
- Complete character state (health, mana, level, inventory)
- Named snapshots for multiple save slots
- Save management (create, restore, delete)
- Preserves complex state including collections

### Example 3: Configuration Rollback
Application configuration with rollback capability:
```d
auto config = new Configuration();
auto undoManager = new MultiLevelUndoManager(config);

// Initial settings
config.set("theme", "dark");
config.set("language", "en");
undoManager.save("Initial config");

// Make changes
config.set("theme", "light");
undoManager.save("Changed theme");

config.set("fontSize", "14");
undoManager.save("Changed font size");

// Undo changes
undoManager.undo(); // Removes fontSize
undoManager.undo(); // Restores dark theme

// Redo if needed
undoManager.redo(); // Reapplies light theme
```

**Key Features:**
- Multi-level undo/redo support
- Change descriptions for history tracking
- Automatic redo stack clearing on new changes
- Dictionary-based configuration storage

## Benefits

1. **Encapsulation Preservation**: Internal state remains hidden from external objects
2. **Simplified Originator**: Originator doesn't need to manage multiple versions of itself
3. **Undo/Redo Support**: Easy implementation of undo/redo functionality
4. **Checkpointing**: Create save points for rollback if operations fail
5. **State History**: Maintain a complete history of state changes
6. **Flexibility**: Multiple mementos can be stored and restored independently

## When to Use

- When you need to implement undo/redo functionality
- When you need to create snapshots of an object's state
- When you want to restore an object to a previous state
- When you need transaction rollback capability
- When implementing save/load systems in applications or games
- When you want to preserve encapsulation while saving state
- When implementing version control or history tracking

## When Not to Use

- When object state is simple enough to be copied directly
- When the cost of creating mementos is too high (memory or performance)
- When state changes are so frequent that storing mementos is impractical
- When you need to track individual property changes (use Observer instead)

## Implementation Considerations

### 1. Private Memento Class
Keep memento internal to the originator for strong encapsulation:
```d
class TextEditor : IOriginator {
    private string _content;
    
    IMemento save() {
        return new TextEditorMemento(_content);
    }
    
    // Private memento - only TextEditor can access
    private static class TextEditorMemento : Memento {
        private string _savedContent;
        
        this(string content) {
            super("TextEditor");
            _savedContent = content;
        }
        
        string getContent() const {
            return _savedContent;
        }
    }
}
```

### 2. Type-Safe Restoration
Use casting to ensure type safety during restoration:
```d
void restore(IMemento memento) {
    auto textMemento = cast(TextEditorMemento)memento;
    if (textMemento !is null) {
        _content = textMemento.getContent();
    }
}
```

### 3. Caretaker Pattern
Use caretaker to manage memento lifecycle:
```d
class EditorHistory : IHistoryManager {
    private TextEditor _editor;
    private IMemento[] _history;
    
    void backup() {
        _history ~= _editor.save();
    }
    
    bool undo() {
        if (_history.length > 0) {
            auto memento = _history[$-1];
            _history = _history[0..$-1];
            _editor.restore(memento);
            return true;
        }
        return false;
    }
}
```

### 4. Memory Management
Limit history size to prevent memory issues:
```d
class BoundedHistory : IHistoryManager {
    private IMemento[] _history;
    private size_t _maxSize = 50;
    
    void backup() {
        _history ~= _editor.save();
        if (_history.length > _maxSize) {
            _history = _history[1..$]; // Remove oldest
        }
    }
}
```

## Advanced Features

### 1. Generic Mementos
Type-safe mementos with generic state:
```d
class GenericMemento(TState) : Memento {
    private TState _state;
    
    this(string name, TState state) {
        super(name);
        _state = state;
    }
    
    TState getState() const {
        return _state;
    }
}

// Usage
auto memento = new GenericMemento!int("Counter", 42);
```

### 2. Versioned Mementos
Track version numbers and descriptions:
```d
class VersionedMemento : Memento {
    private int _version;
    private string _description;
    
    int version_() const { return _version; }
    string description() const { return _description; }
}
```

### 3. Compressed Mementos
Reduce memory usage for large states:
```d
interface ICompressedMemento : IMemento {
    size_t compressedSize() const;
    size_t originalSize() const;
}
```

### 4. Snapshot Management
Named saves with multiple slots:
```d
interface ISnapshotManager {
    void createSnapshot(string name);
    bool restoreSnapshot(string name);
    string[] snapshotNames() const;
}
```

## Comparison with Other Patterns

### Memento vs Command
- **Memento**: Stores object state snapshots
- **Command**: Encapsulates operations with undo logic

### Memento vs Prototype
- **Memento**: Saves/restores state of same object
- **Prototype**: Creates new objects by cloning

### Memento vs State
- **Memento**: Captures and restores state externally
- **State**: Changes behavior based on internal state

## Best Practices

1. **Keep Mementos Immutable**: Once created, memento state should not change
2. **Private Access**: Only the originator should access memento internals
3. **Limit History Size**: Prevent memory issues with bounded history
4. **Use Caretakers**: Delegate memento management to caretaker objects
5. **Add Metadata**: Include timestamps, descriptions, version numbers
6. **Validate Restoration**: Check memento type before restoring
7. **Consider Compression**: For large states, implement compression
8. **Clear Redo on Save**: When new state is saved, clear redo stack

## Common Pitfalls

1. **Memory Leaks**: Not limiting history size leads to unbounded memory growth
2. **Breaking Encapsulation**: Exposing memento internals to external objects
3. **Wrong Memento Type**: Restoring incompatible memento types
4. **Expensive Copies**: Creating deep copies of large objects frequently
5. **Missing Validation**: Not checking if restoration is valid

## Testing Strategy

1. **State Preservation**: Verify state is correctly saved and restored
2. **Multiple Undo/Redo**: Test multiple levels of undo and redo
3. **History Management**: Test history limits and clearing
4. **Named Snapshots**: Verify snapshot creation, retrieval, deletion
5. **Type Safety**: Test restoration with wrong memento types
6. **Edge Cases**: Empty state, null mementos, boundary conditions

## Performance Considerations

### Memory Usage
- Store only essential state, not derived data
- Implement history size limits
- Use compression for large states
- Share immutable data between mementos

### Time Complexity
- Save: O(n) where n is state size
- Restore: O(n) where n is state size
- Undo/Redo: O(1) for accessing memento, O(n) for restoration

## Related Patterns

- **Command**: Often used together - commands for undo, mementos for state
- **Iterator**: Can use memento to save iteration state
- **Prototype**: Similar concept but creates new objects
- **Caretaker**: Specialized pattern for managing mementos
- **Observer**: Can notify when state changes (complementary)

## See Also
- [Command Pattern](../commands/README.md)
- [State Pattern](../states/README.md)
- [Prototype Pattern](../prototypes/README.md)
- [Iterator Pattern](../iterators/README.md) (when implemented)
