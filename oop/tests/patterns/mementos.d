/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module oop.tests.patterns.mementos;

import uim.oop;
import std.datetime;

// Test 1: Create basic memento
@safe unittest {
    auto memento = new Memento("Test");
    assert(memento.name() == "Test");
    assert(memento.timestamp() <= Clock.currTime());
}

// Test 2: Memento timestamp is immutable
@safe unittest {
    auto memento = new Memento("Time");
    auto t1 = memento.timestamp();
    auto t2 = memento.timestamp();
    assert(t1 == t2);
}

// Test 3: Generic memento with int
@safe unittest {
    auto memento = new GenericMemento!int("Number", 42);
    assert(memento.name() == "Number");
    assert(memento.getState() == 42);
}

// Test 4: Generic memento with string
@safe unittest {
    auto memento = new GenericMemento!string("Text", "Hello");
    assert(memento.getState() == "Hello");
}

// Test 5: Caretaker basic operations
@safe unittest {
    auto caretaker = new Caretaker();
    assert(caretaker.count() == 0);
    
    caretaker.addMemento(new Memento("M1"));
    assert(caretaker.count() == 1);
    
    caretaker.addMemento(new Memento("M2"));
    caretaker.addMemento(new Memento("M3"));
    assert(caretaker.count() == 3);
}

// Test 6: Caretaker get memento
@safe unittest {
    auto caretaker = new Caretaker();
    
    caretaker.addMemento(new Memento("First"));
    caretaker.addMemento(new Memento("Second"));
    
    auto m1 = caretaker.getMemento(0);
    assert(m1 !is null);
    assert(m1.name() == "First");
    
    auto m2 = caretaker.getMemento(1);
    assert(m2 !is null);
    assert(m2.name() == "Second");
}

// Test 7: Caretaker get invalid index
@safe unittest {
    auto caretaker = new Caretaker();
    caretaker.addMemento(new Memento("M1"));
    
    auto m = caretaker.getMemento(10);
    assert(m is null);
}

// Test 8: Caretaker clear
@safe unittest {
    auto caretaker = new Caretaker();
    caretaker.addMemento(new Memento("M1"));
    caretaker.addMemento(new Memento("M2"));
    
    assert(caretaker.count() == 2);
    
    caretaker.clear();
    assert(caretaker.count() == 0);
}

// Test 9: Text editor basic save/restore
@safe unittest {
    auto editor = new TextEditor();
    editor.setText("Hello World");
    
    auto memento = editor.save();
    
    editor.setText("Different Text");
    assert(editor.content() == "Different Text");
    
    editor.restore(memento);
    assert(editor.content() == "Hello World");
}

// Test 10: Text editor cursor position
@safe unittest {
    auto editor = new TextEditor();
    editor.setText("Test");
    editor.setCursor(2);
    
    assert(editor.cursorPosition() == 2);
    
    auto memento = editor.save();
    
    editor.setCursor(4);
    assert(editor.cursorPosition() == 4);
    
    editor.restore(memento);
    assert(editor.cursorPosition() == 2);
}

// Test 11: Text editor append text
@safe unittest {
    auto editor = new TextEditor();
    editor.setText("Hello");
    editor.appendText(" World");
    
    assert(editor.content() == "Hello World");
    assert(editor.cursorPosition() == 11);
}

// Test 12: Editor history basic undo
@safe unittest {
    auto editor = new TextEditor();
    auto history = new EditorHistory(editor);
    
    editor.setText("First");
    history.backup();
    
    editor.setText("Second");
    
    assert(editor.content() == "Second");
    assert(history.canUndo());
    
    history.undo();
    assert(editor.content() == "First");
}

// Test 13: Editor history multiple undo
@safe unittest {
    auto editor = new TextEditor();
    auto history = new EditorHistory(editor);
    
    editor.setText("V1");
    history.backup();
    
    editor.setText("V2");
    history.backup();
    
    editor.setText("V3");
    history.backup();
    
    editor.setText("V4");
    
    assert(history.undoCount() == 3);
    
    history.undo();
    assert(editor.content() == "V3");
    
    history.undo();
    assert(editor.content() == "V2");
    
    history.undo();
    assert(editor.content() == "V1");
    
    assert(!history.canUndo());
}

// Test 14: Editor history cannot undo when empty
@safe unittest {
    auto editor = new TextEditor();
    auto history = new EditorHistory(editor);
    
    assert(!history.canUndo());
    
    bool result = history.undo();
    assert(!result);
}

// Test 15: Game character basic save/restore
@safe unittest {
    auto character = new GameCharacter("Hero");
    
    assert(character.name() == "Hero");
    assert(character.health() == 100);
    assert(character.mana() == 50);
    assert(character.level() == 1);
}

// Test 16: Game character take damage
@safe unittest {
    auto character = new GameCharacter("Hero");
    
    character.takeDamage(30);
    assert(character.health() == 70);
    
    character.takeDamage(80);
    assert(character.health() == 0);
}

// Test 17: Game character use mana
@safe unittest {
    auto character = new GameCharacter("Hero");
    
    character.useMana(20);
    assert(character.mana() == 30);
    
    character.useMana(40);
    assert(character.mana() == 0);
}

// Test 18: Game character level up
@safe unittest {
    auto character = new GameCharacter("Hero");
    
    character.levelUp();
    assert(character.level() == 2);
    assert(character.health() == 110);
    assert(character.mana() == 55);
}

// Test 19: Game character inventory
@safe unittest {
    auto character = new GameCharacter("Hero");
    
    character.addItem("Sword");
    assert(character.getItemCount("Sword") == 1);
    
    character.addItem("Potion", 5);
    assert(character.getItemCount("Potion") == 5);
    
    character.addItem("Potion", 3);
    assert(character.getItemCount("Potion") == 8);
}

// Test 20: Game character save/restore state
@safe unittest {
    auto character = new GameCharacter("Hero");
    
    character.takeDamage(20);
    character.levelUp();
    character.addItem("Sword");
    
    auto memento = character.save();
    
    character.takeDamage(50);
    character.levelUp();
    character.addItem("Shield");
    
    assert(character.health() == 40);
    assert(character.level() == 3);
    assert(character.getItemCount("Shield") == 1);
    
    character.restore(memento);
    
    assert(character.health() == 90);
    assert(character.level() == 2);
    assert(character.getItemCount("Sword") == 1);
    assert(character.getItemCount("Shield") == 0);
}

// Test 21: Game save manager create snapshot
@safe unittest {
    auto character = new GameCharacter("Hero");
    auto saveManager = new GameSaveManager(character);
    
    saveManager.createSnapshot("save1");
    assert(saveManager.hasSnapshot("save1"));
    assert(!saveManager.hasSnapshot("save2"));
}

// Test 22: Game save manager restore snapshot
@safe unittest {
    auto character = new GameCharacter("Hero");
    auto saveManager = new GameSaveManager(character);
    
    character.levelUp();
    saveManager.createSnapshot("level2");
    
    character.levelUp();
    character.levelUp();
    assert(character.level() == 4);
    
    bool restored = saveManager.restoreSnapshot("level2");
    assert(restored);
    assert(character.level() == 2);
}

// Test 23: Game save manager restore non-existent
@safe unittest {
    auto character = new GameCharacter("Hero");
    auto saveManager = new GameSaveManager(character);
    
    bool restored = saveManager.restoreSnapshot("nonexistent");
    assert(!restored);
}

// Test 24: Game save manager snapshot names
@safe unittest {
    auto character = new GameCharacter("Hero");
    auto saveManager = new GameSaveManager(character);
    
    saveManager.createSnapshot("save1");
    saveManager.createSnapshot("save2");
    saveManager.createSnapshot("save3");
    
    auto names = saveManager.snapshotNames();
    assert(names.length == 3);
}

// Test 25: Game save manager delete snapshot
@safe unittest {
    auto character = new GameCharacter("Hero");
    auto saveManager = new GameSaveManager(character);
    
    saveManager.createSnapshot("temp");
    assert(saveManager.hasSnapshot("temp"));
    
    bool deleted = saveManager.deleteSnapshot("temp");
    assert(deleted);
    assert(!saveManager.hasSnapshot("temp"));
}

// Test 26: Configuration basic operations
@safe unittest {
    auto config = new Configuration();
    
    config.set("key1", "value1");
    assert(config.get("key1") == "value1");
    assert(config.has("key1"));
    assert(!config.has("key2"));
}

// Test 27: Configuration default value
@safe unittest {
    auto config = new Configuration();
    
    assert(config.get("nonexistent") == "");
    assert(config.get("nonexistent", "default") == "default");
}

// Test 28: Configuration save/restore
@safe unittest {
    auto config = new Configuration();
    
    config.set("theme", "dark");
    config.set("language", "en");
    
    auto memento = config.save();
    
    config.set("theme", "light");
    config.set("font", "Arial");
    config.set("size", "12");
    
    assert(config.settingCount() == 4);
    
    config.restore(memento);
    
    assert(config.settingCount() == 2);
    assert(config.get("theme") == "dark");
    assert(!config.has("font"));
}

// Test 29: Multi-level undo manager basic
@safe unittest {
    auto config = new Configuration();
    auto undoManager = new MultiLevelUndoManager(config);
    
    config.set("key1", "value1");
    undoManager.save("Set key1");
    
    assert(undoManager.canUndo());
    assert(!undoManager.canRedo());
}

// Test 30: Multi-level undo manager undo
@safe unittest {
    auto config = new Configuration();
    auto undoManager = new MultiLevelUndoManager(config);
    
    config.set("key1", "v1");
    undoManager.save("Change 1");
    
    config.set("key1", "v2");
    undoManager.save("Change 2");
    
    config.set("key1", "v3");
    undoManager.save("Change 3");
    
    assert(config.get("key1") == "v3");
    
    undoManager.undo();
    assert(config.get("key1") == "v2");
    
    undoManager.undo();
    assert(config.get("key1") == "v1");
}

// Test 31: Multi-level undo manager redo
@safe unittest {
    auto config = new Configuration();
    auto undoManager = new MultiLevelUndoManager(config);
    
    config.set("key", "v1");
    undoManager.save();
    
    config.set("key", "v2");
    undoManager.save();
    
    undoManager.undo();
    assert(config.get("key") == "v1");
    assert(undoManager.canRedo());
    
    undoManager.redo();
    assert(config.get("key") == "v2");
}

// Test 32: Multi-level undo manager clear redo on save
@safe unittest {
    auto config = new Configuration();
    auto undoManager = new MultiLevelUndoManager(config);
    
    config.set("key", "v1");
    undoManager.save();
    
    config.set("key", "v2");
    undoManager.save();
    
    undoManager.undo();
    assert(undoManager.canRedo());
    
    // New change clears redo
    config.set("key", "v3");
    undoManager.save();
    
    assert(!undoManager.canRedo());
}

// Test 33: Multi-level undo manager history
@safe unittest {
    auto config = new Configuration();
    auto undoManager = new MultiLevelUndoManager(config);
    
    config.set("key", "v1");
    undoManager.save("Change 1");
    
    config.set("key", "v2");
    undoManager.save("Change 2");
    
    auto history = undoManager.undoHistory();
    assert(history.length == 2);
    assert(history[0] == "Change 1");
    assert(history[1] == "Change 2");
}

// Test 34: Multi-level undo manager redo history
@safe unittest {
    auto config = new Configuration();
    auto undoManager = new MultiLevelUndoManager(config);
    
    config.set("key", "v1");
    undoManager.save("C1");
    
    config.set("key", "v2");
    undoManager.save("C2");
    
    undoManager.undo();
    undoManager.undo();
    
    auto redoHist = undoManager.redoHistory();
    assert(redoHist.length == 2);
}

// Test 35: Versioned memento
@safe unittest {
    auto memento = new VersionedMemento("V1", 1, "Initial version");
    
    assert(memento.name() == "V1");
    assert(memento.version_() == 1);
    assert(memento.description() == "Initial version");
}

// Test 36: Multiple originators with same caretaker
@safe unittest {
    auto editor1 = new TextEditor();
    auto editor2 = new TextEditor();
    auto caretaker = new Caretaker();
    
    editor1.setText("Editor 1");
    caretaker.addMemento(editor1.save());
    
    editor2.setText("Editor 2");
    caretaker.addMemento(editor2.save());
    
    assert(caretaker.count() == 2);
}

// Test 37: Restore wrong memento type (graceful handling)
@safe unittest {
    auto editor = new TextEditor();
    auto config = new Configuration();
    
    editor.setText("Test");
    auto editorMemento = editor.save();
    
    config.set("key", "value");
    
    // Restoring editor memento to config should not crash
    config.restore(editorMemento);
    
    // Config should be unchanged
    assert(config.get("key") == "value");
}

// Test 38: Text editor empty content
@safe unittest {
    auto editor = new TextEditor();
    
    assert(editor.content() == "");
    assert(editor.cursorPosition() == 0);
    
    auto memento = editor.save();
    
    editor.setText("Something");
    editor.restore(memento);
    
    assert(editor.content() == "");
}

// Test 39: Game character multiple saves
@safe unittest {
    auto character = new GameCharacter("Hero");
    
    auto save1 = character.save();
    
    character.levelUp();
    auto save2 = character.save();
    
    character.levelUp();
    auto save3 = character.save();
    
    character.restore(save1);
    assert(character.level() == 1);
    
    character.restore(save3);
    assert(character.level() == 3);
    
    character.restore(save2);
    assert(character.level() == 2);
}

// Test 40: Configuration overwrite existing key
@safe unittest {
    auto config = new Configuration();
    
    config.set("key", "old");
    assert(config.get("key") == "old");
    
    config.set("key", "new");
    assert(config.get("key") == "new");
}
