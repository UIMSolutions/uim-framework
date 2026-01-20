/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.commands.command;

import uim.oop.patterns.commands.interfaces;
import std.format;
import std.algorithm : remove;

/**
 * Abstract base command with common functionality.
 */
abstract class BaseCommand : ICommand {
    protected string _name;
    
    this(string commandName) @safe {
        _name = commandName;
    }
    
    @safe string name() const {
        return _name;
    }
    
    abstract void execute();
}

/**
 * Abstract undoable command with undo support.
 */
abstract class UndoableCommand : BaseCommand, IUndoableCommand {
    protected bool _executed;
    
    this(string commandName) @safe {
        super(commandName);
        _executed = false;
    }
    
    override @safe void execute() {
        doExecute();
        _executed = true;
    }
    
    @safe void undo() {
        if (canUndo()) {
            doUndo();
            _executed = false;
        }
    }
    
    @safe bool canUndo() const {
        return _executed;
    }
    
    protected abstract @safe void doExecute();
    protected abstract @safe void doUndo();
}

/**
 * Simple invoker that executes a command.
 */
class Invoker : IInvoker {
    private ICommand _command;
    
    @safe void setCommand(ICommand command) {
        _command = command;
    }
    
    @safe void executeCommand() {
        if (_command !is null) {
            _command.execute();
        }
    }
}

/**
 * Command queue for batch execution.
 */
class CommandQueue : ICommandQueue {
    private ICommand[] _commands;
    
    @safe void enqueue(ICommand command) {
        _commands ~= command;
    }
    
    @safe void executeAll() {
        foreach (command; _commands) {
            command.execute();
        }
        _commands = [];
    }
    
    @safe void clear() {
        _commands = [];
    }
    
    @safe size_t size() const {
        return _commands.length;
    }
}

/**
 * Command history with undo/redo support.
 */
class CommandHistory : ICommandHistory {
    private IUndoableCommand[] _history;
    private IUndoableCommand[] _redoStack;
    
    @safe void record(IUndoableCommand command) {
        _history ~= command;
        _redoStack = []; // Clear redo stack when new command is recorded
    }
    
    @safe bool undo() {
        if (!canUndo()) {
            return false;
        }
        
        auto command = _history[$-1];
        _history = _history[0..$-1];
        
        command.undo();
        _redoStack ~= command;
        
        return true;
    }
    
    @safe bool redo() {
        if (!canRedo()) {
            return false;
        }
        
        auto command = _redoStack[$-1];
        _redoStack = _redoStack[0..$-1];
        
        command.execute();
        _history ~= command;
        
        return true;
    }
    
    @safe bool canUndo() const {
        return _history.length > 0;
    }
    
    @safe bool canRedo() const {
        return _redoStack.length > 0;
    }
    
    @safe void clear() {
        _history = [];
        _redoStack = [];
    }
    
    @safe size_t historySize() const {
        return _history.length;
    }
}

/**
 * Macro command that executes multiple commands.
 */
class MacroCommand : BaseCommand, IMacroCommand {
    private ICommand[] _commands;
    
    this(string name) @safe {
        super(name);
    }
    
    @safe void addCommand(ICommand command) {
        _commands ~= command;
    }
    
    @safe size_t commandCount() const {
        return _commands.length;
    }
    
    override @safe void execute() {
        foreach (command; _commands) {
            command.execute();
        }
    }
}

// Real-world example: Text Editor

/**
 * Text editor receiver.
 */
class TextEditor : IReceiver {
    private string _text;
    private string[] _actionLog;
    
    this() @safe {
        _text = "";
    }
    
    @safe void action(string action) {
        _actionLog ~= action;
    }
    
    @safe void insertText(string text) {
        _text ~= text;
        _actionLog ~= "Insert: " ~ text;
    }
    
    @safe void deleteText(size_t length) {
        if (length <= _text.length) {
            _text = _text[0..$-length];
            _actionLog ~= "Delete: " ~ length.stringof ~ " chars";
        }
    }
    
    @safe string text() const {
        return _text;
    }
    
    @safe string[] actionLog() const {
        return _actionLog.dup;
    }
}

/**
 * Insert text command.
 */
class InsertTextCommand : UndoableCommand {
    private TextEditor _editor;
    private string _textToInsert;
    
    this(TextEditor editor, string text) @safe {
        super("InsertText");
        _editor = editor;
        _textToInsert = text;
    }
    
    protected override @safe void doExecute() {
        _editor.insertText(_textToInsert);
    }
    
    protected override @safe void doUndo() {
        _editor.deleteText(_textToInsert.length);
    }
}

/**
 * Delete text command.
 */
class DeleteTextCommand : UndoableCommand {
    private TextEditor _editor;
    private size_t _length;
    private string _deletedText;
    
    this(TextEditor editor, size_t length) @safe {
        super("DeleteText");
        _editor = editor;
        _length = length;
    }
    
    protected override @safe void doExecute() {
        auto currentText = _editor.text();
        if (_length <= currentText.length) {
            _deletedText = currentText[$-_length..$];
            _editor.deleteText(_length);
        }
    }
    
    protected override @safe void doUndo() {
        _editor.insertText(_deletedText);
    }
}

// Real-world example: Smart Home

/**
 * Light receiver.
 */
class Light {
    private string _name;
    private bool _isOn;
    private int _brightness;
    
    this(string name) @safe {
        _name = name;
        _isOn = false;
        _brightness = 0;
    }
    
    @safe void turnOn() {
        _isOn = true;
        _brightness = 100;
    }
    
    @safe void turnOff() {
        _isOn = false;
        _brightness = 0;
    }
    
    @safe void setBrightness(int level) {
        if (_isOn) {
            _brightness = level;
        }
    }
    
    @safe bool isOn() const {
        return _isOn;
    }
    
    @safe int brightness() const {
        return _brightness;
    }
    
    @safe string name() const {
        return _name;
    }
}

/**
 * Turn light on command.
 */
class LightOnCommand : UndoableCommand {
    private Light _light;
    
    this(Light light) @safe {
        super("LightOn");
        _light = light;
    }
    
    protected override @safe void doExecute() {
        _light.turnOn();
    }
    
    protected override @safe void doUndo() {
        _light.turnOff();
    }
}

/**
 * Turn light off command.
 */
class LightOffCommand : UndoableCommand {
    private Light _light;
    
    this(Light light) @safe {
        super("LightOff");
        _light = light;
    }
    
    protected override @safe void doExecute() {
        _light.turnOff();
    }
    
    protected override @safe void doUndo() {
        _light.turnOn();
    }
}

/**
 * Set brightness command.
 */
class SetBrightnessCommand : UndoableCommand {
    private Light _light;
    private int _newBrightness;
    private int _oldBrightness;
    
    this(Light light, int brightness) @safe {
        super("SetBrightness");
        _light = light;
        _newBrightness = brightness;
    }
    
    protected override @safe void doExecute() {
        _oldBrightness = _light.brightness();
        _light.setBrightness(_newBrightness);
    }
    
    protected override @safe void doUndo() {
        _light.setBrightness(_oldBrightness);
    }
}

// Real-world example: Remote Control

/**
 * Remote control with macro commands.
 */
class RemoteControl {
    private ICommand[string] _commands;
    
    @safe void setCommand(string button, ICommand command) {
        _commands[button] = command;
    }
    
    @safe void pressButton(string button) {
        if (button in _commands) {
            _commands[button].execute();
        }
    }
    
    @safe bool hasCommand(string button) const {
        return (button in _commands) !is null;
    }
}

// Unit tests

@safe unittest {
    // Test base command
    class TestCommand : BaseCommand {
        bool executed = false;
        
        this() @safe { super("Test"); }
        
        override void execute() {
            executed = true;
        }
    }
    
    auto cmd = new TestCommand();
    assert(cmd.name == "Test");
    cmd.execute();
    assert(cmd.executed);
}

@safe unittest {
    // Test invoker
    class SimpleCommand : BaseCommand {
        int executeCount = 0;
        
        this() @safe { super("Simple"); }
        
        override void execute() {
            executeCount++;
        }
    }
    
    auto cmd = new SimpleCommand();
    auto invoker = new Invoker();
    
    invoker.setCommand(cmd);
    invoker.executeCommand();
    
    assert(cmd.executeCount == 1);
}

@safe unittest {
    // Test command queue
    class CountCommand : BaseCommand {
        static int totalExecutions = 0;
        
        this() @safe { super("Count"); }
        
        override void execute() {
            totalExecutions++;
        }
    }
    
    CountCommand.totalExecutions = 0;
    
    auto queue = new CommandQueue();
    queue.enqueue(new CountCommand());
    queue.enqueue(new CountCommand());
    queue.enqueue(new CountCommand());
    
    assert(queue.size() == 3);
    
    queue.executeAll();
    assert(CountCommand.totalExecutions == 3);
    assert(queue.size() == 0);
}

@safe unittest {
    // Test text editor insert command
    auto editor = new TextEditor();
    auto cmd = new InsertTextCommand(editor, "Hello");
    
    cmd.execute();
    assert(editor.text() == "Hello");
    
    cmd.undo();
    assert(editor.text() == "");
}

@safe unittest {
    // Test command history
    auto editor = new TextEditor();
    auto history = new CommandHistory();
    
    auto cmd1 = new InsertTextCommand(editor, "Hello");
    auto cmd2 = new InsertTextCommand(editor, " World");
    
    cmd1.execute();
    history.record(cmd1);
    
    cmd2.execute();
    history.record(cmd2);
    
    assert(editor.text() == "Hello World");
    assert(history.canUndo());
    
    history.undo();
    assert(editor.text() == "Hello");
    
    history.undo();
    assert(editor.text() == "");
}

@safe unittest {
    // Test redo functionality
    auto editor = new TextEditor();
    auto history = new CommandHistory();
    
    auto cmd = new InsertTextCommand(editor, "Test");
    cmd.execute();
    history.record(cmd);
    
    history.undo();
    assert(editor.text() == "");
    assert(history.canRedo());
    
    history.redo();
    assert(editor.text() == "Test");
}

@safe unittest {
    // Test light on/off
    auto light = new Light("Living Room");
    auto onCmd = new LightOnCommand(light);
    
    assert(!light.isOn());
    
    onCmd.execute();
    assert(light.isOn());
    assert(light.brightness() == 100);
    
    onCmd.undo();
    assert(!light.isOn());
}

@safe unittest {
    // Test macro command
    auto light1 = new Light("Light1");
    auto light2 = new Light("Light2");
    
    auto macroCmd = new MacroCommand("AllLightsOn");
    macroCmd.addCommand(new LightOnCommand(light1));
    macroCmd.addCommand(new LightOnCommand(light2));
    
    assert(macroCmd.commandCount() == 2);
    
    macroCmd.execute();
    assert(light1.isOn());
    assert(light2.isOn());
}

@safe unittest {
    // Test remote control
    auto light = new Light("Bedroom");
    auto remote = new RemoteControl();
    
    remote.setCommand("power", new LightOnCommand(light));
    
    assert(remote.hasCommand("power"));
    
    remote.pressButton("power");
    assert(light.isOn());
}

import std.conv : to;
