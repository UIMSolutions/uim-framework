# Command Pattern

## Purpose
The Command Pattern is a behavioral design pattern that turns a request into a stand-alone object containing all information about the request. This transformation allows you to parameterize methods with different requests, queue or log requests, and support undoable operations.

## Problem It Solves
- **Direct Coupling**: When the invoker (requester) is tightly coupled to the receiver (performer), making it difficult to decouple requests from their implementations
- **Request Management**: When you need to queue, log, or schedule requests for execution at different times
- **Undo/Redo**: When you need to support reversible operations
- **Macro Operations**: When you need to compose multiple operations into a single compound operation
- **Request History**: When you need to maintain a history of executed operations

## UML Class Diagram
```
┌─────────────────┐
│   <<interface>> │
│     ICommand    │
├─────────────────┤
│ + execute()     │
│ + name()        │
└────────▲────────┘
         │
         │ implements
         │
┌────────┴────────┐         ┌──────────────┐
│  BaseCommand    │         │  IInvoker    │
├─────────────────┤         ├──────────────┤
│ - _name         │         │ - _command   │
├─────────────────┤         ├──────────────┤
│ + execute()     │◄────────│ + setCommand()│
│ + name()        │         │ + execute()  │
└────────▲────────┘         └──────────────┘
         │
         │ extends
         │
┌────────┴──────────┐
│ UndoableCommand   │
├───────────────────┤       ┌──────────────┐
│ - _executed       │       │  IReceiver   │
├───────────────────┤       ├──────────────┤
│ + execute()       │──────►│ + action()   │
│ + undo()          │       └──────────────┘
│ + canUndo()       │
│ # doExecute()     │
│ # doUndo()        │
└───────────────────┘
```

## Components

### 1. ICommand
The main command interface that declares the execution method.
```d
interface ICommand {
    void execute();
    string name() const;
}
```

### 2. IUndoableCommand
Extended interface for commands that support undo operations.
```d
interface IUndoableCommand : ICommand {
    void undo();
    bool canUndo() const;
}
```

### 3. BaseCommand
Abstract base class providing common command functionality.
```d
abstract class BaseCommand : ICommand {
    protected string _name;
    abstract void execute();
    string name() const;
}
```

### 4. UndoableCommand
Abstract base class for commands with undo support.
```d
abstract class UndoableCommand : BaseCommand, IUndoableCommand {
    protected bool _executed;
    void execute();
    void undo();
    bool canUndo() const;
    protected abstract void doExecute();
    protected abstract void doUndo();
}
```

### 5. IInvoker
Interface for command invokers that execute commands.
```d
interface IInvoker {
    void setCommand(ICommand command);
    void executeCommand();
}
```

### 6. ICommandQueue
Interface for managing command queues.
```d
interface ICommandQueue {
    void enqueue(ICommand command);
    void executeAll();
    void clear();
    size_t size() const;
}
```

### 7. ICommandHistory
Interface for tracking command history with undo/redo support.
```d
interface ICommandHistory {
    void record(IUndoableCommand command);
    bool undo();
    bool redo();
    bool canUndo() const;
    bool canRedo() const;
    void clear();
}
```

### 8. IMacroCommand
Interface for composite commands that execute multiple commands.
```d
interface IMacroCommand : ICommand {
    void addCommand(ICommand command);
    size_t commandCount() const;
}
```

## Real-World Examples

### Example 1: Text Editor
A text editor with undo/redo functionality:
```d
auto editor = new TextEditor();
auto history = new CommandHistory();

// Type text
auto cmd1 = new InsertTextCommand(editor, "Hello");
cmd1.execute();
history.record(cmd1);

auto cmd2 = new InsertTextCommand(editor, " World");
cmd2.execute();
history.record(cmd2);

// Undo
history.undo(); // Text: "Hello"
history.undo(); // Text: ""

// Redo
history.redo(); // Text: "Hello"
```

**Key Features:**
- Insert and delete text operations
- Full undo/redo support
- Command history tracking
- State preservation for undo

### Example 2: Smart Home Control
A smart home system with light control:
```d
auto livingRoom = new Light("Living Room");
auto bedroom = new Light("Bedroom");

// Control individual lights
auto cmd1 = new LightOnCommand(livingRoom);
cmd1.execute(); // Living room light on

auto cmd2 = new SetBrightnessCommand(livingRoom, 50);
cmd2.execute(); // Set brightness to 50%

// Undo operations
cmd2.undo(); // Restore previous brightness
cmd1.undo(); // Turn light off
```

**Key Features:**
- Device control abstraction
- Undo support for all operations
- State preservation (brightness levels)
- Multiple device types

### Example 3: Remote Control with Macros
A universal remote control with scene support:
```d
auto remote = new RemoteControl();

// Create a "Movie Night" macro
auto movieScene = new MacroCommand("Movie Night");
movieScene.addCommand(new LightOffCommand(light1));
movieScene.addCommand(new LightOffCommand(light2));
movieScene.addCommand(new LightOnCommand(light3));
movieScene.addCommand(new SetBrightnessCommand(light3, 20));

// Assign to remote button
remote.setCommand("movie", movieScene);

// Execute entire scene with one button press
remote.pressButton("movie");
```

**Key Features:**
- Button-command mapping
- Macro commands (composite pattern)
- Multi-device coordination
- Scene management

## Benefits

1. **Decoupling**: Separates the object that invokes the operation from the one that knows how to perform it
2. **Extensibility**: New commands can be added without changing existing code
3. **Undo/Redo**: Easy implementation of reversible operations
4. **Command Queuing**: Commands can be queued and executed later
5. **Command History**: Maintains a log of executed commands
6. **Macro Commands**: Compose multiple commands into compound operations
7. **Transaction Support**: Group commands for atomic execution
8. **Remote Execution**: Commands can be transferred and executed remotely

## When to Use

- When you need to parameterize objects with operations
- When you need to queue operations, schedule their execution, or execute them remotely
- When you need to support undo/redo functionality
- When you want to log changes for auditing or crash recovery
- When you need to structure a system around high-level operations built on primitive operations
- When you want to support transactions or command history

## When Not to Use

- For simple, one-time operations that don't need to be undone or logged
- When the overhead of command objects is not justified
- When operations are so simple that a direct method call is clearer

## Implementation Considerations

### 1. Command Storage
Commands encapsulate all necessary information:
```d
class SetBrightnessCommand : UndoableCommand {
    private Light _light;
    private int _newBrightness;
    private int _oldBrightness; // For undo
}
```

### 2. Undo Implementation
Store previous state for undo:
```d
protected override void doExecute() {
    _oldBrightness = _light.brightness();
    _light.setBrightness(_newBrightness);
}

protected override void doUndo() {
    _light.setBrightness(_oldBrightness);
}
```

### 3. Command Queue
Batch execution of commands:
```d
class CommandQueue : ICommandQueue {
    private ICommand[] _commands;
    
    void executeAll() {
        foreach (command; _commands) {
            command.execute();
        }
        _commands = [];
    }
}
```

### 4. History Management
Track executed commands with undo/redo stacks:
```d
class CommandHistory : ICommandHistory {
    private IUndoableCommand[] _history;
    private IUndoableCommand[] _redoStack;
    
    bool undo() {
        auto command = _history[$-1];
        _history = _history[0..$-1];
        command.undo();
        _redoStack ~= command;
        return true;
    }
}
```

## Advanced Features

### 1. Macro Commands
Composite commands that execute multiple commands:
```d
auto macro = new MacroCommand("AllLightsOn");
macro.addCommand(new LightOnCommand(light1));
macro.addCommand(new LightOnCommand(light2));
macro.addCommand(new LightOnCommand(light3));
macro.execute(); // All lights turn on
```

### 2. Parameterized Commands
Commands that accept runtime parameters:
```d
interface IParameterizedCommand(TParam) : ICommand {
    void setParameters(TParam params);
    TParam getParameters() const;
}
```

### 3. Transactional Commands
Commands with transaction support:
```d
interface ITransactionalCommand : ICommand {
    void begin();
    void commit();
    void rollback();
    bool inTransaction() const;
}
```

## Comparison with Other Patterns

### Command vs Strategy
- **Command**: Encapsulates a request as an object with undo support
- **Strategy**: Encapsulates an algorithm, typically without undo

### Command vs Memento
- **Command**: Encapsulates operations for undo/redo
- **Memento**: Stores state snapshots for restoration

### Command vs Chain of Responsibility
- **Command**: Single receiver handles the request
- **Chain**: Multiple potential receivers, request passed along chain

## Best Practices

1. **Keep Commands Focused**: Each command should represent a single operation
2. **Store Undo State**: Always capture the previous state before executing
3. **Clear Redo on New Command**: When a new command is executed after undo, clear the redo stack
4. **Validate Before Execute**: Check if the command can be executed
5. **Use Macro Commands**: Compose complex operations from simpler commands
6. **Implement Cloning**: For commands that need to be copied or duplicated
7. **Consider Memory**: Limit history size for memory-intensive applications
8. **Thread Safety**: Make commands thread-safe if used in concurrent environments

## Common Pitfalls

1. **Memory Leaks**: Not clearing old commands from history
2. **State Inconsistency**: Not properly capturing state for undo
3. **Over-Engineering**: Creating commands for trivial operations
4. **Missing Validation**: Not checking if undo/redo is possible
5. **Incomplete Undo**: Not fully restoring previous state

## Testing Strategy

1. **Command Execution**: Verify commands execute correctly
2. **Undo/Redo**: Test undo reverses execution and redo re-applies it
3. **History Management**: Test history size, clear, and state
4. **Queue Operations**: Verify batch execution and clearing
5. **Macro Commands**: Test composite command execution
6. **Edge Cases**: Empty queues, multiple undo/redo cycles, state boundaries

## Related Patterns

- **Memento**: Often used with Command for implementing undo
- **Composite**: Macro commands use composite structure
- **Prototype**: Commands can be cloned for reuse
- **Observer**: Command execution can trigger notifications
- **Strategy**: Similar structure but different intent

## See Also
- [Observer Pattern](../observers/README.md)
- [Strategy Pattern](../strategies/README.md)
- [Composite Pattern](../composites/README.md)
- [Memento Pattern](../mementos/README.md) (when implemented)
