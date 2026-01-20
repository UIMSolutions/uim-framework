/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module oop.examples.command;

import uim.oop;
import std.stdio;

void main() {
    writeln("\n=== Command Pattern Examples ===\n");
    
    example1_BasicCommand();
    example2_TextEditor();
    example3_SmartHome();
    example4_RemoteControl();
    example5_MacroCommands();
    example6_CommandQueue();
    example7_ComplexUndo();
    example8_TransactionLike();
}

/// Example 1: Basic Command Execution
void example1_BasicCommand() {
    writeln("--- Example 1: Basic Command ---");
    
    class PrintCommand : BaseCommand {
        string message;
        
        this(string msg) @safe {
            super("Print");
            message = msg;
        }
        
        override void execute() {
            writeln("Command executed: ", message);
        }
    }
    
    auto invoker = new Invoker();
    auto cmd = new PrintCommand("Hello, Command Pattern!");
    
    invoker.setCommand(cmd);
    invoker.executeCommand();
    
    writeln();
}

/// Example 2: Text Editor with Undo/Redo
void example2_TextEditor() {
    writeln("--- Example 2: Text Editor with Undo/Redo ---");
    
    auto editor = new TextEditor();
    auto history = new CommandHistory();
    
    // Type some text
    auto cmd1 = new InsertTextCommand(editor, "Hello");
    cmd1.execute();
    history.record(cmd1);
    writeln("After Insert 'Hello': ", editor.text());
    
    auto cmd2 = new InsertTextCommand(editor, " World");
    cmd2.execute();
    history.record(cmd2);
    writeln("After Insert ' World': ", editor.text());
    
    auto cmd3 = new InsertTextCommand(editor, "!");
    cmd3.execute();
    history.record(cmd3);
    writeln("After Insert '!': ", editor.text());
    
    // Undo twice
    writeln("\nUndoing...");
    history.undo();
    writeln("After Undo: ", editor.text());
    
    history.undo();
    writeln("After Undo: ", editor.text());
    
    // Redo once
    writeln("\nRedoing...");
    history.redo();
    writeln("After Redo: ", editor.text());
    
    writeln();
}

/// Example 3: Smart Home Light Control
void example3_SmartHome() {
    writeln("--- Example 3: Smart Home Light Control ---");
    
    auto livingRoom = new Light("Living Room");
    auto bedroom = new Light("Bedroom");
    auto history = new CommandHistory();
    
    // Turn on living room light
    auto cmd1 = new LightOnCommand(livingRoom);
    cmd1.execute();
    history.record(cmd1);
    writeln("Living Room Light: ", livingRoom.isOn() ? "ON" : "OFF", 
            " (Brightness: ", livingRoom.brightness(), "%)");
    
    // Set brightness
    auto cmd2 = new SetBrightnessCommand(livingRoom, 50);
    cmd2.execute();
    history.record(cmd2);
    writeln("Living Room Brightness: ", livingRoom.brightness(), "%");
    
    // Turn on bedroom light
    auto cmd3 = new LightOnCommand(bedroom);
    cmd3.execute();
    history.record(cmd3);
    writeln("Bedroom Light: ", bedroom.isOn() ? "ON" : "OFF");
    
    // Undo last command
    writeln("\nUndoing last command...");
    history.undo();
    writeln("Bedroom Light: ", bedroom.isOn() ? "ON" : "OFF");
    
    writeln();
}

/// Example 4: Remote Control
void example4_RemoteControl() {
    writeln("--- Example 4: Remote Control ---");
    
    auto remote = new RemoteControl();
    auto light = new Light("Main Light");
    
    // Program the remote
    remote.setCommand("on", new LightOnCommand(light));
    remote.setCommand("off", new LightOffCommand(light));
    remote.setCommand("dim", new SetBrightnessCommand(light, 30));
    
    // Use the remote
    writeln("Pressing 'on' button...");
    remote.pressButton("on");
    writeln("Light is ", light.isOn() ? "ON" : "OFF", 
            " (Brightness: ", light.brightness(), "%)");
    
    writeln("\nPressing 'dim' button...");
    remote.pressButton("dim");
    writeln("Light brightness: ", light.brightness(), "%");
    
    writeln("\nPressing 'off' button...");
    remote.pressButton("off");
    writeln("Light is ", light.isOn() ? "ON" : "OFF");
    
    writeln();
}

/// Example 5: Macro Commands (Scene Control)
void example5_MacroCommands() {
    writeln("--- Example 5: Macro Commands (Scene Control) ---");
    
    auto light1 = new Light("Living Room");
    auto light2 = new Light("Kitchen");
    auto light3 = new Light("Hallway");
    
    // Create "Movie Night" scene
    auto movieScene = new MacroCommand("Movie Night");
    movieScene.addCommand(new LightOffCommand(light1));
    movieScene.addCommand(new LightOffCommand(light2));
    movieScene.addCommand(new LightOnCommand(light3));
    movieScene.addCommand(new SetBrightnessCommand(light3, 20));
    
    // Create "All On" scene
    auto allOnScene = new MacroCommand("All On");
    allOnScene.addCommand(new LightOnCommand(light1));
    allOnScene.addCommand(new LightOnCommand(light2));
    allOnScene.addCommand(new LightOnCommand(light3));
    
    // Activate movie scene
    writeln("Activating 'Movie Night' scene...");
    movieScene.execute();
    writeln("Living Room: ", light1.isOn() ? "ON" : "OFF");
    writeln("Kitchen: ", light2.isOn() ? "ON" : "OFF");
    writeln("Hallway: ", light3.isOn() ? "ON" : "OFF", 
            " (", light3.brightness(), "%)");
    
    writeln("\nActivating 'All On' scene...");
    allOnScene.execute();
    writeln("Living Room: ", light1.isOn() ? "ON" : "OFF");
    writeln("Kitchen: ", light2.isOn() ? "ON" : "OFF");
    writeln("Hallway: ", light3.isOn() ? "ON" : "OFF");
    
    writeln();
}

/// Example 6: Command Queue (Task Scheduler)
void example6_CommandQueue() {
    writeln("--- Example 6: Command Queue (Task Scheduler) ---");
    
    class TaskCommand : BaseCommand {
        string taskName;
        
        this(string name) @safe {
            super("Task");
            taskName = name;
        }
        
        override void execute() {
            writeln("Executing task: ", taskName);
        }
    }
    
    auto scheduler = new CommandQueue();
    
    // Schedule multiple tasks
    scheduler.enqueue(new TaskCommand("Backup Database"));
    scheduler.enqueue(new TaskCommand("Send Email Reports"));
    scheduler.enqueue(new TaskCommand("Clean Temp Files"));
    scheduler.enqueue(new TaskCommand("Update Statistics"));
    
    writeln("Scheduled ", scheduler.size(), " tasks");
    writeln("\nExecuting all scheduled tasks:");
    scheduler.executeAll();
    writeln("Tasks remaining: ", scheduler.size());
    
    writeln();
}

/// Example 7: Complex Undo/Redo Scenario
void example7_ComplexUndo() {
    writeln("--- Example 7: Complex Undo/Redo Scenario ---");
    
    auto editor = new TextEditor();
    auto history = new CommandHistory();
    
    void executeAndRecord(IUndoableCommand cmd) {
        cmd.execute();
        history.record(cmd);
    }
    
    // Build a document
    executeAndRecord(new InsertTextCommand(editor, "Chapter 1: Introduction\n"));
    executeAndRecord(new InsertTextCommand(editor, "This is the first chapter.\n"));
    executeAndRecord(new InsertTextCommand(editor, "It explains the basics.\n"));
    
    writeln("Document state:");
    writeln(editor.text());
    
    // User makes a mistake, undoes last two operations
    writeln("Undoing last 2 operations...");
    history.undo();
    history.undo();
    writeln("\nDocument state after undo:");
    writeln(editor.text());
    
    // User decides to redo one operation
    writeln("Redoing one operation...");
    history.redo();
    writeln("\nDocument state after redo:");
    writeln(editor.text());
    
    // User continues editing (this clears redo history)
    executeAndRecord(new InsertTextCommand(editor, "Updated content.\n"));
    writeln("\nFinal document state:");
    writeln(editor.text());
    writeln("Can redo: ", history.canRedo() ? "Yes" : "No");
    
    writeln();
}

/// Example 8: Transaction-like Behavior
void example8_TransactionLike() {
    writeln("--- Example 8: Transaction-like Behavior ---");
    
    class AccountCommand : UndoableCommand {
        int* balance;
        int amount;
        string operation;
        
        this(int* bal, int amt, string op) @safe {
            super(op);
            balance = bal;
            amount = amt;
            operation = op;
        }
        
        protected override void doExecute() {
            *balance += amount;
            writeln(operation, ": ", amount > 0 ? "+" : "", amount, 
                    " (Balance: ", *balance, ")");
        }
        
        protected override void doUndo() {
            *balance -= amount;
            writeln("Undo ", operation, ": ", amount < 0 ? "+" : "", -amount, 
                    " (Balance: ", *balance, ")");
        }
    }
    
    int balance = 1000;
    auto history = new CommandHistory();
    
    writeln("Starting balance: ", balance);
    
    // Execute a series of transactions
    auto cmd1 = new AccountCommand(&balance, 500, "Deposit");
    cmd1.execute();
    history.record(cmd1);
    
    auto cmd2 = new AccountCommand(&balance, -200, "Withdrawal");
    cmd2.execute();
    history.record(cmd2);
    
    auto cmd3 = new AccountCommand(&balance, -100, "Payment");
    cmd3.execute();
    history.record(cmd3);
    
    writeln("\nCurrent balance: ", balance);
    
    // Rollback last transaction
    writeln("\nRolling back last transaction...");
    history.undo();
    
    writeln("Balance after rollback: ", balance);
    
    writeln();
}
