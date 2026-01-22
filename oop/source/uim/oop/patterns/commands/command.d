/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.commands.command;

import uim.oop;

mixin(ShowModule!());

@safe:


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

        auto command = _history[$ - 1];
        _history = _history[0 .. $ - 1];

        command.undo();
        _redoStack ~= command;

        return true;
    }

    @safe bool redo() {
        if (!canRedo()) {
            return false;
        }

        auto command = _redoStack[$ - 1];
        _redoStack = _redoStack[0 .. $ - 1];

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

// Real-world example: Text Editor

/**
 * Text editor receiver.
 */
class TextEditorReceiver : IReceiver {
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
            _text = _text[0 .. $ - length];
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
 * Delete text command.
 */
class DeleteTextCommand : DUndoableCommand {
    private TextEditorReceiver _editor;
    private size_t _length;
    private string _deletedText;

    this(TextEditorReceiver editor, size_t length) @safe {
        super(); // super("DeleteText");
        _editor = editor;
        _length = length;
    }

    protected override @safe bool doExecute(Json[string] options = null) {
        auto currentText = _editor.text();
        if (_length <= currentText.length) {
            _deletedText = currentText[$ - _length .. $];
            _editor.deleteText(_length);
        }
        return true;
    }

    protected @safe /* override */ bool doUndo(Json[string] options = null) {
        _editor.insertText(_deletedText);
        return true;
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
class LightOnCommand : DUndoableCommand {
    private Light _light;

    this(Light light) @safe {
        super(); // super("LightOn");
        _light = light;
    }

    protected @safe override bool doExecute(Json[string] options = null) {
        _light.turnOn();
        return true;

    }

    protected @safe override bool doUndo() {
        _light.turnOff();
        return true;
    }
}

/**
 * Turn light off command.
 */
class LightOffCommand : DUndoableCommand {
    private Light _light;

    this(Light light) @safe {
        super(); // super("LightOff");
        _light = light;
    }

    protected override @safe bool doExecute(Json[string] options = null) {
        _light.turnOff();
        return true;

    }

    protected /* override */ @safe bool doUndo(Json[string] options = null) {
        _light.turnOn();
        return true;

    }
}

/**
 * Set brightness command.
 */
class SetBrightnessCommand : DUndoableCommand {
    private Light _light;
    private int _newBrightness;
    private int _oldBrightness;

    this(Light light, int brightness) @safe {
        super(); // super("SetBrightness");
        _light = light;
        _newBrightness = brightness;
    }

    protected override  @safe bool doExecute(Json[string] options = null) {
        _oldBrightness = _light.brightness();
        _light.setBrightness(_newBrightness);
        return true;
    }

    protected /* override */ @safe bool doUndo(Json[string] options = null) {
        _light.setBrightness(_oldBrightness);
        return true;
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


/*
 * Abstract base class for commands.
 * Provides common functionality and lifecycle hooks.
 */
abstract class DAbstractCommand : UIMObject, ICommand {
    mixin(CommandThis!());

    protected bool _executed = false;
    protected Json[string] _lastOptions;

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        return true;
    }

    /**
   * Execute command with given options.
   * Template method pattern - calls lifecycle hooks.
   */
    bool execute(Json options) {
        return execute(options.get!(Json[string]));
    }

    bool execute(string[string] options) {
        return execute(options.toJsonMap);
    }

    bool execute(Json[string] options = null) {
        _lastOptions = options;

        if (!canExecute(options)) {
            return false;
        }

        if (!validateParameters(options)) {
            return false;
        }

        if (!beforeExecute(options)) {
            return false;
        }

        bool result = doExecute(options);
        _executed = result;

        afterExecute(options, result);

        return result;
    }

    /**
   * Execute command and return detailed result.
   */
    CommandResult executeWithResult(Json[string] options = null) {
        bool success = execute(options);
        return success
            ? CommandResult.ok("Command executed successfully") : CommandResult.fail(
                "Command execution failed");
    }

    /**
   * Validate command parameters.
   * Override in subclasses for custom validation.
   */
    bool validateParameters(Json[string] options = null) {
        return true; // Default: no validation
    }

    /**
   * Check if command can be executed.
   * Override in subclasses for custom checks.
   */
    bool canExecute(Json[string] options = null) {
        return true; // Default: always executable
    }

    /**
   * Core execution logic - must be implemented by subclasses.
   */
    protected abstract bool doExecute(Json[string] options = null);

    /**
   * Hook called before execution.
   * Override to add pre-execution logic.
   * Returns: true to continue, false to abort
   */
    protected bool beforeExecute(Json[string] options = null) {
        return true;
    }

    /**
   * Hook called after execution.
   * Override to add post-execution logic.
   */
    protected void afterExecute(Json[string] options, bool success) {
        // Default: no-op
    }

    /**
   * Check if command has been executed.
   */
    bool hasExecuted() const {
        return _executed;
    }

    /**
   * Get the last execution options.
   */
    Json[string] lastOptions() const {
        Json[string] result;
        foreach (key, value; _lastOptions) {
            result[key] = value;
        }
        return result;
    }
}

/**
 * Base class for commands with standard implementation.
 * For backwards compatibility.
 */
class DCommand : DAbstractCommand {
    mixin(CommandThis!());

    override bool initialize(Json[string] initData = null) {
        if (!super.initialize(initData)) {
            return false;
        }

        return true;
    }

    protected override bool doExecute(Json[string] options = null) {
        // Default implementation for backwards compatibility
        return true;
    }
}
