/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module oop.tests.patterns.commands;

import uim.oop;

// Test 1: Create and execute basic command
@safe unittest {
    class SimpleCommand : BaseCommand {
        bool wasExecuted = false;
        
        this() @safe {
            super("SimpleCommand");
        }
        
        override void execute() {
            wasExecuted = true;
        }
    }
    
    auto cmd = new SimpleCommand();
    assert(cmd.name == "SimpleCommand");
    assert(!cmd.wasExecuted);
    
    cmd.execute();
    assert(cmd.wasExecuted);
}

// Test 2: Command with invoker
@safe unittest {
    class IncrementCommand : BaseCommand {
        int* counter;
        
        this(int* cnt) @safe {
            super("Increment");
            counter = cnt;
        }
        
        override void execute() {
            (*counter)++;
        }
    }
    
    int counter = 0;
    auto cmd = new IncrementCommand(&counter);
    auto invoker = new Invoker();
    
    invoker.setCommand(cmd);
    invoker.executeCommand();
    
    assert(counter == 1);
}

// Test 3: Multiple commands with invoker
@safe unittest {
    class AddCommand : BaseCommand {
        int* value;
        int amount;
        
        this(int* val, int amt) @safe {
            super("Add");
            value = val;
            amount = amt;
        }
        
        override void execute() {
            *value += amount;
        }
    }
    
    int result = 0;
    auto invoker = new Invoker();
    
    invoker.setCommand(new AddCommand(&result, 5));
    invoker.executeCommand();
    assert(result == 5);
    
    invoker.setCommand(new AddCommand(&result, 3));
    invoker.executeCommand();
    assert(result == 8);
}

// Test 4: Command queue basic operations
@safe unittest {
    auto queue = new CommandQueue();
    
    assert(queue.size() == 0);
    
    class DummyCommand : BaseCommand {
        this() @safe { super("Dummy"); }
        override void execute() {}
    }
    
    queue.enqueue(new DummyCommand());
    assert(queue.size() == 1);
    
    queue.enqueue(new DummyCommand());
    queue.enqueue(new DummyCommand());
    assert(queue.size() == 3);
    
    queue.clear();
    assert(queue.size() == 0);
}

// Test 5: Command queue execution
@safe unittest {
    class CountCommand : BaseCommand {
        static int execCount = 0;
        
        this() @safe {
            super("Count");
        }
        
        override void execute() {
            execCount++;
        }
    }
    
    CountCommand.execCount = 0;
    
    auto queue = new CommandQueue();
    queue.enqueue(new CountCommand());
    queue.enqueue(new CountCommand());
    queue.enqueue(new CountCommand());
    
    assert(CountCommand.execCount == 0);
    
    queue.executeAll();
    assert(CountCommand.execCount == 3);
    assert(queue.size() == 0); // Queue is cleared after execution
}

// Test 6: Undoable command basic
@safe unittest {
    class IncrementCommand : UndoableCommand {
        int* counter;
        
        this(int* cnt) @safe {
            super("Increment");
            counter = cnt;
        }
        
        protected override void doExecute() {
            (*counter)++;
        }
        
        protected override void doUndo() {
            (*counter)--;
        }
    }
    
    int value = 10;
    auto cmd = new IncrementCommand(&value);
    
    assert(!cmd.canUndo());
    
    cmd.execute();
    assert(value == 11);
    assert(cmd.canUndo());
    
    cmd.undo();
    assert(value == 10);
    assert(!cmd.canUndo());
}

// Test 7: Command history basic operations
@safe unittest {
    auto history = new CommandHistory();
    
    assert(!history.canUndo());
    assert(!history.canRedo());
    
    class DummyUndoCommand : UndoableCommand {
        this() @safe { super("Dummy"); }
        protected override void doExecute() {}
        protected override void doUndo() {}
    }
    
    auto cmd = new DummyUndoCommand();
    cmd.execute();
    history.record(cmd);
    
    assert(history.canUndo());
    assert(!history.canRedo());
}

// Test 8: Command history undo/redo
@safe unittest {
    class SetValueCommand : UndoableCommand {
        int* target;
        int newValue;
        int oldValue;
        
        this(int* tgt, int val) @safe {
            super("SetValue");
            target = tgt;
            newValue = val;
        }
        
        protected override void doExecute() {
            oldValue = *target;
            *target = newValue;
        }
        
        protected override void doUndo() {
            *target = oldValue;
        }
    }
    
    int value = 0;
    auto history = new CommandHistory();
    
    auto cmd1 = new SetValueCommand(&value, 10);
    cmd1.execute();
    history.record(cmd1);
    assert(value == 10);
    
    auto cmd2 = new SetValueCommand(&value, 20);
    cmd2.execute();
    history.record(cmd2);
    assert(value == 20);
    
    history.undo();
    assert(value == 10);
    
    history.undo();
    assert(value == 0);
    
    history.redo();
    assert(value == 10);
    
    history.redo();
    assert(value == 20);
}

// Test 9: Command history clears redo on new command
@safe unittest {
    class SimpleUndoCommand : UndoableCommand {
        int id;
        this(int i) @safe { super("Simple"); id = i; }
        protected override void doExecute() {}
        protected override void doUndo() {}
    }
    
    auto history = new CommandHistory();
    
    auto cmd1 = new SimpleUndoCommand(1);
    cmd1.execute();
    history.record(cmd1);
    
    auto cmd2 = new SimpleUndoCommand(2);
    cmd2.execute();
    history.record(cmd2);
    
    history.undo();
    assert(history.canRedo());
    
    // Recording new command should clear redo stack
    auto cmd3 = new SimpleUndoCommand(3);
    cmd3.execute();
    history.record(cmd3);
    
    assert(!history.canRedo());
}

// Test 10: Text editor insert command
@safe unittest {
    auto editor = new TextEditor();
    assert(editor.text() == "");
    
    auto cmd = new InsertTextCommand(editor, "Hello");
    cmd.execute();
    
    assert(editor.text() == "Hello");
}

// Test 11: Text editor delete command
@safe unittest {
    auto editor = new TextEditor();
    editor.insertText("Hello World");
    
    auto cmd = new DeleteTextCommand(editor, 6);
    cmd.execute();
    
    assert(editor.text() == "Hello");
}

// Test 12: Text editor undo insert
@safe unittest {
    auto editor = new TextEditor();
    auto cmd = new InsertTextCommand(editor, "Test");
    
    cmd.execute();
    assert(editor.text() == "Test");
    
    cmd.undo();
    assert(editor.text() == "");
}

// Test 13: Text editor undo delete
@safe unittest {
    auto editor = new TextEditor();
    editor.insertText("Hello");
    
    auto cmd = new DeleteTextCommand(editor, 2);
    cmd.execute();
    assert(editor.text() == "Hel");
    
    cmd.undo();
    assert(editor.text() == "Hello");
}

// Test 14: Text editor complex scenario
@safe unittest {
    auto editor = new TextEditor();
    auto history = new CommandHistory();
    
    auto cmd1 = new InsertTextCommand(editor, "Hello");
    cmd1.execute();
    history.record(cmd1);
    
    auto cmd2 = new InsertTextCommand(editor, " World");
    cmd2.execute();
    history.record(cmd2);
    
    auto cmd3 = new DeleteTextCommand(editor, 6);
    cmd3.execute();
    history.record(cmd3);
    
    assert(editor.text() == "Hello");
    
    history.undo();
    assert(editor.text() == "Hello World");
    
    history.undo();
    assert(editor.text() == "Hello");
    
    history.redo();
    assert(editor.text() == "Hello World");
}

// Test 15: Light on command
@safe unittest {
    auto light = new Light("Test Light");
    assert(!light.isOn());
    assert(light.brightness() == 0);
    
    auto cmd = new LightOnCommand(light);
    cmd.execute();
    
    assert(light.isOn());
    assert(light.brightness() == 100);
}

// Test 16: Light off command
@safe unittest {
    auto light = new Light("Test Light");
    light.turnOn();
    
    auto cmd = new LightOffCommand(light);
    cmd.execute();
    
    assert(!light.isOn());
    assert(light.brightness() == 0);
}

// Test 17: Light undo on
@safe unittest {
    auto light = new Light("Test Light");
    auto cmd = new LightOnCommand(light);
    
    cmd.execute();
    assert(light.isOn());
    
    cmd.undo();
    assert(!light.isOn());
}

// Test 18: Light undo off
@safe unittest {
    auto light = new Light("Test Light");
    light.turnOn();
    
    auto cmd = new LightOffCommand(light);
    cmd.execute();
    assert(!light.isOn());
    
    cmd.undo();
    assert(light.isOn());
}

// Test 19: Set brightness command
@safe unittest {
    auto light = new Light("Test Light");
    light.turnOn();
    
    auto cmd = new SetBrightnessCommand(light, 50);
    cmd.execute();
    
    assert(light.brightness() == 50);
}

// Test 20: Set brightness undo
@safe unittest {
    auto light = new Light("Test Light");
    light.turnOn();
    light.setBrightness(100);
    
    auto cmd = new SetBrightnessCommand(light, 30);
    cmd.execute();
    assert(light.brightness() == 30);
    
    cmd.undo();
    assert(light.brightness() == 100);
}

// Test 21: Macro command creation
@safe unittest {
    auto macro = new MacroCommand("TestMacro");
    
    assert(macro.name() == "TestMacro");
    assert(macro.commandCount() == 0);
    
    class DummyCommand : BaseCommand {
        this() @safe { super("Dummy"); }
        override void execute() {}
    }
    
    macro.addCommand(new DummyCommand());
    macro.addCommand(new DummyCommand());
    
    assert(macro.commandCount() == 2);
}

// Test 22: Macro command execution
@safe unittest {
    class CountCommand : BaseCommand {
        static int count = 0;
        
        this() @safe {
            super("Count");
        }
        
        override void execute() {
            count++;
        }
    }
    
    CountCommand.count = 0;
    
    auto macro = new MacroCommand("CountMacro");
    macro.addCommand(new CountCommand());
    macro.addCommand(new CountCommand());
    macro.addCommand(new CountCommand());
    
    macro.execute();
    assert(CountCommand.count == 3);
}

// Test 23: Macro command with multiple lights
@safe unittest {
    auto light1 = new Light("Light1");
    auto light2 = new Light("Light2");
    auto light3 = new Light("Light3");
    
    auto macro = new MacroCommand("AllOn");
    macro.addCommand(new LightOnCommand(light1));
    macro.addCommand(new LightOnCommand(light2));
    macro.addCommand(new LightOnCommand(light3));
    
    macro.execute();
    
    assert(light1.isOn());
    assert(light2.isOn());
    assert(light3.isOn());
}

// Test 24: Remote control basic
@safe unittest {
    auto remote = new RemoteControl();
    auto light = new Light("Living Room");
    
    remote.setCommand("power", new LightOnCommand(light));
    
    assert(remote.hasCommand("power"));
    assert(!remote.hasCommand("volume"));
}

// Test 25: Remote control execution
@safe unittest {
    auto remote = new RemoteControl();
    auto light = new Light("Bedroom");
    
    remote.setCommand("on", new LightOnCommand(light));
    remote.setCommand("off", new LightOffCommand(light));
    
    remote.pressButton("on");
    assert(light.isOn());
    
    remote.pressButton("off");
    assert(!light.isOn());
}

// Test 26: Remote control with multiple devices
@safe unittest {
    auto remote = new RemoteControl();
    auto light1 = new Light("Living Room");
    auto light2 = new Light("Kitchen");
    
    remote.setCommand("living_on", new LightOnCommand(light1));
    remote.setCommand("kitchen_on", new LightOnCommand(light2));
    
    remote.pressButton("living_on");
    assert(light1.isOn());
    assert(!light2.isOn());
    
    remote.pressButton("kitchen_on");
    assert(light1.isOn());
    assert(light2.isOn());
}

// Test 27: Remote control with macro
@safe unittest {
    auto remote = new RemoteControl();
    auto light1 = new Light("Light1");
    auto light2 = new Light("Light2");
    
    auto allOn = new MacroCommand("AllOn");
    allOn.addCommand(new LightOnCommand(light1));
    allOn.addCommand(new LightOnCommand(light2));
    
    remote.setCommand("all_on", allOn);
    remote.pressButton("all_on");
    
    assert(light1.isOn());
    assert(light2.isOn());
}

// Test 28: Command history size tracking
@safe unittest {
    class SimpleUndoCommand : UndoableCommand {
        this() @safe { super("Simple"); }
        protected override void doExecute() {}
        protected override void doUndo() {}
    }
    
    auto history = new CommandHistory();
    
    assert(history.historySize() == 0);
    
    auto cmd1 = new SimpleUndoCommand();
    cmd1.execute();
    history.record(cmd1);
    assert(history.historySize() == 1);
    
    auto cmd2 = new SimpleUndoCommand();
    cmd2.execute();
    history.record(cmd2);
    assert(history.historySize() == 2);
    
    history.undo();
    assert(history.historySize() == 1);
}

// Test 29: Command history clear
@safe unittest {
    class SimpleUndoCommand : UndoableCommand {
        this() @safe { super("Simple"); }
        protected override void doExecute() {}
        protected override void doUndo() {}
    }
    
    auto history = new CommandHistory();
    
    auto cmd1 = new SimpleUndoCommand();
    cmd1.execute();
    history.record(cmd1);
    
    auto cmd2 = new SimpleUndoCommand();
    cmd2.execute();
    history.record(cmd2);
    
    history.undo();
    
    assert(history.canUndo());
    assert(history.canRedo());
    
    history.clear();
    
    assert(!history.canUndo());
    assert(!history.canRedo());
}

// Test 30: Text editor action log
@safe unittest {
    auto editor = new TextEditor();
    
    editor.insertText("Hello");
    editor.insertText(" World");
    editor.deleteText(6);
    
    auto log = editor.actionLog();
    assert(log.length == 3);
}

// Test 31: Command queue with different command types
@safe unittest {
    auto light = new Light("Test");
    auto queue = new CommandQueue();
    
    queue.enqueue(new LightOnCommand(light));
    queue.enqueue(new SetBrightnessCommand(light, 50));
    queue.enqueue(new LightOffCommand(light));
    
    assert(queue.size() == 3);
    
    queue.executeAll();
    
    assert(!light.isOn()); // Last command turned it off
    assert(queue.size() == 0);
}

// Test 32: Multiple undo/redo cycles
@safe unittest {
    class ValueCommand : UndoableCommand {
        int* value;
        int delta;
        
        this(int* val, int d) @safe {
            super("Value");
            value = val;
            delta = d;
        }
        
        protected override void doExecute() {
            *value += delta;
        }
        
        protected override void doUndo() {
            *value -= delta;
        }
    }
    
    int value = 0;
    auto history = new CommandHistory();
    
    auto cmd1 = new ValueCommand(&value, 10);
    cmd1.execute();
    history.record(cmd1);
    
    auto cmd2 = new ValueCommand(&value, 5);
    cmd2.execute();
    history.record(cmd2);
    
    assert(value == 15);
    
    history.undo();
    assert(value == 10);
    
    history.redo();
    assert(value == 15);
    
    history.undo();
    history.undo();
    assert(value == 0);
    
    history.redo();
    history.redo();
    assert(value == 15);
}

// Test 33: Nested macro commands
@safe unittest {
    class CountCommand : BaseCommand {
        static int count = 0;
        
        this() @safe {
            super("Count");
        }
        
        override void execute() {
            count++;
        }
    }
    
    CountCommand.count = 0;
    
    auto innerMacro = new MacroCommand("Inner");
    innerMacro.addCommand(new CountCommand());
    innerMacro.addCommand(new CountCommand());
    
    auto outerMacro = new MacroCommand("Outer");
    outerMacro.addCommand(new CountCommand());
    outerMacro.addCommand(innerMacro);
    outerMacro.addCommand(new CountCommand());
    
    outerMacro.execute();
    assert(CountCommand.count == 4);
}

// Test 34: Command cannot undo before execution
@safe unittest {
    class TestCommand : UndoableCommand {
        bool undoCalled = false;
        
        this() @safe {
            super("Test");
        }
        
        protected override void doExecute() {}
        
        protected override void doUndo() {
            undoCalled = true;
        }
    }
    
    auto cmd = new TestCommand();
    
    cmd.undo(); // Should not execute doUndo
    assert(!cmd.undoCalled);
    
    cmd.execute();
    cmd.undo(); // Should execute doUndo
    assert(cmd.undoCalled);
}

// Test 35: Empty command queue execution
@safe unittest {
    auto queue = new CommandQueue();
    
    // Should not throw
    queue.executeAll();
    assert(queue.size() == 0);
}
