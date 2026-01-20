/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module oop.examples.memento;

import uim.oop;
import std.stdio;
import std.datetime;

void main() {
    writeln("\n=== Memento Pattern Examples ===\n");
    
    example1_BasicMemento();
    example2_TextEditorUndo();
    example3_GameSaveLoad();
    example4_ConfigurationRollback();
    example5_MultiLevelUndo();
    example6_SnapshotManager();
    example7_VersionControl();
    example8_ComplexState();
}

/// Example 1: Basic Memento Creation
void example1_BasicMemento() {
    writeln("--- Example 1: Basic Memento ---");
    
    auto memento = new Memento("MyMemento");
    
    writeln("Memento name: ", memento.name());
    writeln("Created at: ", memento.timestamp());
    
    // Generic memento with typed state
    auto intMemento = new GenericMemento!int("Counter", 42);
    writeln("Stored value: ", intMemento.getState());
    
    writeln();
}

/// Example 2: Text Editor with Undo
void example2_TextEditorUndo() {
    writeln("--- Example 2: Text Editor with Undo ---");
    
    auto editor = new TextEditor();
    auto history = new EditorHistory(editor);
    
    // Type some text
    editor.setText("Hello");
    writeln("Text: ", editor.content());
    history.backup();
    
    editor.appendText(" World");
    writeln("Text: ", editor.content());
    history.backup();
    
    editor.appendText("!");
    writeln("Text: ", editor.content());
    history.backup();
    
    // Make a mistake
    editor.setText("Oops, deleted everything");
    writeln("Text: ", editor.content());
    
    // Undo the mistake
    writeln("\nUndoing...");
    history.undo();
    writeln("Text: ", editor.content());
    
    writeln();
}

/// Example 3: Game Save/Load System
void example3_GameSaveLoad() {
    writeln("--- Example 3: Game Save/Load ---");
    
    auto character = new GameCharacter("Warrior");
    auto saveManager = new GameSaveManager(character);
    
    writeln("Starting state:");
    writeln("  Level: ", character.level());
    writeln("  Health: ", character.health());
    writeln("  Mana: ", character.mana());
    
    // Progress through the game
    character.levelUp();
    character.addItem("Sword", 1);
    character.addItem("Potion", 5);
    saveManager.createSnapshot("checkpoint1");
    writeln("\nSaved checkpoint1");
    
    character.levelUp();
    character.levelUp();
    character.takeDamage(40);
    character.addItem("Shield", 1);
    saveManager.createSnapshot("checkpoint2");
    writeln("Saved checkpoint2");
    
    writeln("\nCurrent state:");
    writeln("  Level: ", character.level());
    writeln("  Health: ", character.health());
    writeln("  Sword: ", character.getItemCount("Sword"));
    writeln("  Shield: ", character.getItemCount("Shield"));
    
    // Load earlier save
    writeln("\nLoading checkpoint1...");
    saveManager.restoreSnapshot("checkpoint1");
    
    writeln("State after load:");
    writeln("  Level: ", character.level());
    writeln("  Health: ", character.health());
    writeln("  Sword: ", character.getItemCount("Sword"));
    writeln("  Shield: ", character.getItemCount("Shield"));
    
    writeln();
}

/// Example 4: Configuration Rollback
void example4_ConfigurationRollback() {
    writeln("--- Example 4: Configuration Rollback ---");
    
    auto config = new Configuration();
    
    // Initial configuration
    config.set("theme", "dark");
    config.set("language", "en");
    config.set("notifications", "enabled");
    
    writeln("Initial config:");
    writeln("  Theme: ", config.get("theme"));
    writeln("  Language: ", config.get("language"));
    
    // Save before making changes
    auto backup = config.save();
    writeln("\nConfiguration backed up");
    
    // Make experimental changes
    config.set("theme", "light");
    config.set("language", "de");
    config.set("experimental", "true");
    
    writeln("\nExperimental config:");
    writeln("  Theme: ", config.get("theme"));
    writeln("  Language: ", config.get("language"));
    writeln("  Experimental: ", config.get("experimental"));
    
    // Rollback to saved state
    writeln("\nRolling back...");
    config.restore(backup);
    
    writeln("After rollback:");
    writeln("  Theme: ", config.get("theme"));
    writeln("  Language: ", config.get("language"));
    writeln("  Has experimental: ", config.has("experimental"));
    
    writeln();
}

/// Example 5: Multi-Level Undo/Redo
void example5_MultiLevelUndo() {
    writeln("--- Example 5: Multi-Level Undo/Redo ---");
    
    auto config = new Configuration();
    auto undoManager = new MultiLevelUndoManager(config);
    
    // Make a series of changes
    config.set("value", "1");
    undoManager.save("Set to 1");
    writeln("Value: ", config.get("value"));
    
    config.set("value", "2");
    undoManager.save("Set to 2");
    writeln("Value: ", config.get("value"));
    
    config.set("value", "3");
    undoManager.save("Set to 3");
    writeln("Value: ", config.get("value"));
    
    config.set("value", "4");
    undoManager.save("Set to 4");
    writeln("Value: ", config.get("value"));
    
    // Undo twice
    writeln("\nUndoing twice...");
    undoManager.undo();
    writeln("Value: ", config.get("value"));
    undoManager.undo();
    writeln("Value: ", config.get("value"));
    
    // Redo once
    writeln("\nRedoing once...");
    undoManager.redo();
    writeln("Value: ", config.get("value"));
    
    // Show history
    writeln("\nUndo history:");
    foreach (desc; undoManager.undoHistory()) {
        writeln("  - ", desc);
    }
    
    writeln();
}

/// Example 6: Snapshot Manager with Named Saves
void example6_SnapshotManager() {
    writeln("--- Example 6: Snapshot Manager ---");
    
    auto character = new GameCharacter("Mage");
    auto saveManager = new GameSaveManager(character);
    
    // Create multiple save points
    saveManager.createSnapshot("start");
    
    character.levelUp();
    saveManager.createSnapshot("level_2");
    
    character.levelUp();
    character.addItem("Staff", 1);
    saveManager.createSnapshot("got_staff");
    
    character.levelUp();
    character.levelUp();
    saveManager.createSnapshot("level_4");
    
    writeln("Available saves:");
    foreach (name; saveManager.snapshotNames()) {
        writeln("  - ", name);
    }
    
    writeln("\nCurrent level: ", character.level());
    
    // Jump to a specific save
    writeln("\nLoading 'got_staff' save...");
    saveManager.restoreSnapshot("got_staff");
    writeln("Level: ", character.level());
    writeln("Has staff: ", character.getItemCount("Staff") > 0);
    
    // Delete a save
    writeln("\nDeleting 'level_2' save...");
    saveManager.deleteSnapshot("level_2");
    
    writeln("\nRemaining saves:");
    foreach (name; saveManager.snapshotNames()) {
        writeln("  - ", name);
    }
    
    writeln();
}

/// Example 7: Version Control Simulation
void example7_VersionControl() {
    writeln("--- Example 7: Version Control Simulation ---");
    
    auto editor = new TextEditor();
    
    struct Version {
        IMemento memento;
        int number;
        string description;
    }
    
    Version[] versions;
    
    // Version 1
    editor.setText("Initial commit");
    versions ~= Version(editor.save(), 1, "Initial commit");
    writeln("v1: Initial commit");
    
    // Version 2
    editor.appendText("\nAdded feature A");
    versions ~= Version(editor.save(), 2, "Added feature A");
    writeln("v2: Added feature A");
    
    // Version 3
    editor.appendText("\nAdded feature B");
    versions ~= Version(editor.save(), 3, "Added feature B");
    writeln("v3: Added feature B");
    
    // Version 4
    editor.appendText("\nFixed bug in feature A");
    versions ~= Version(editor.save(), 4, "Fixed bug");
    writeln("v4: Fixed bug in feature A");
    
    writeln("\nCurrent content:");
    writeln(editor.content());
    
    // Checkout version 2
    writeln("\nChecking out v2...");
    editor.restore(versions[1].memento);
    writeln("Content at v2:");
    writeln(editor.content());
    
    writeln();
}

/// Example 8: Complex State Management
void example8_ComplexState() {
    writeln("--- Example 8: Complex State Management ---");
    
    auto character = new GameCharacter("Paladin");
    
    // Setup initial state
    character.levelUp();
    character.levelUp();
    character.addItem("Sword", 1);
    character.addItem("Armor", 1);
    character.addItem("Potion", 10);
    
    writeln("Prepared for battle:");
    writeln("  Level: ", character.level());
    writeln("  Health: ", character.health());
    writeln("  Potions: ", character.getItemCount("Potion"));
    
    // Save before battle
    auto beforeBattle = character.save();
    writeln("\nSaved state before battle");
    
    // Simulate battle
    writeln("\nBattle begins!");
    character.takeDamage(60);
    character.useMana(40);
    character.addItem("Potion", -5); // Use 5 potions
    
    writeln("After battle:");
    writeln("  Health: ", character.health());
    writeln("  Mana: ", character.mana());
    writeln("  Potions: ", character.getItemCount("Potion"));
    
    // Character died, restore to before battle
    if (character.health() < 30) {
        writeln("\nBattle was too hard, restoring...");
        character.restore(beforeBattle);
        
        writeln("Restored state:");
        writeln("  Health: ", character.health());
        writeln("  Mana: ", character.mana());
        writeln("  Potions: ", character.getItemCount("Potion"));
    }
    
    writeln();
}
