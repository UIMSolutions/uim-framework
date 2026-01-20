/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.mementos.interfaces;

import std.datetime;

/**
 * Memento interface that stores the internal state of an object.
 * The memento is opaque to other objects except the originator.
 */
interface IMemento {
    /**
     * Gets the memento name or identifier.
     * Returns: The memento identifier
     */
    @safe string name() const;
    
    /**
     * Gets the timestamp when the memento was created.
     * Returns: The creation timestamp
     */
    @safe SysTime timestamp() const;
}

/**
 * Originator interface for objects that can create and restore mementos.
 * The originator creates a memento containing a snapshot of its current state
 * and uses it to restore its state later.
 */
interface IOriginator {
    /**
     * Creates a memento containing the current state.
     * Returns: A new memento with the current state
     */
    @safe IMemento save();
    
    /**
     * Restores the originator's state from a memento.
     * Params:
     *   memento = The memento to restore from
     */
    @safe void restore(IMemento memento);
}

/**
 * Caretaker interface that maintains a collection of mementos.
 * The caretaker never examines or modifies the contents of a memento.
 */
interface ICaretaker {
    /**
     * Saves a memento.
     * Params:
     *   memento = The memento to save
     */
    @safe void addMemento(IMemento memento);
    
    /**
     * Gets a memento by index.
     * Params:
     *   index = The index of the memento
     * Returns: The memento at the specified index
     */
    @safe IMemento getMemento(size_t index);
    
    /**
     * Gets the number of stored mementos.
     * Returns: The count of mementos
     */
    @safe size_t count() const;
    
    /**
     * Clears all stored mementos.
     */
    @safe void clear();
}

/**
 * Generic memento interface with typed state.
 */
interface IGenericMemento(TState) : IMemento {
    /**
     * Gets the stored state.
     * Returns: The state value
     */
    @safe TState getState() const;
}

/**
 * Generic originator interface with typed state.
 */
interface IGenericOriginator(TState) : IOriginator {
    /**
     * Gets the current state.
     * Returns: The current state
     */
    @safe TState getState() const;
    
    /**
     * Sets the current state.
     * Params:
     *   state = The new state
     */
    @safe void setState(TState state);
}

/**
 * History manager interface for managing undo/redo with mementos.
 */
interface IHistoryManager {
    /**
     * Saves the current state.
     */
    @safe void backup();
    
    /**
     * Undoes the last change.
     * Returns: true if undo was successful
     */
    @safe bool undo();
    
    /**
     * Checks if undo is available.
     * Returns: true if undo is possible
     */
    @safe bool canUndo() const;
    
    /**
     * Gets the number of available undo steps.
     * Returns: The undo count
     */
    @safe size_t undoCount() const;
}

/**
 * Snapshot manager interface for creating named snapshots.
 */
interface ISnapshotManager {
    /**
     * Creates a snapshot with a name.
     * Params:
     *   name = The snapshot name
     */
    @safe void createSnapshot(string name);
    
    /**
     * Restores a snapshot by name.
     * Params:
     *   name = The snapshot name
     * Returns: true if restore was successful
     */
    @safe bool restoreSnapshot(string name);
    
    /**
     * Checks if a snapshot exists.
     * Params:
     *   name = The snapshot name
     * Returns: true if the snapshot exists
     */
    @safe bool hasSnapshot(string name) const;
    
    /**
     * Gets all snapshot names.
     * Returns: Array of snapshot names
     */
    @safe string[] snapshotNames() const;
    
    /**
     * Deletes a snapshot.
     * Params:
     *   name = The snapshot name
     * Returns: true if deletion was successful
     */
    @safe bool deleteSnapshot(string name);
}

/**
 * Versioned memento interface with version tracking.
 */
interface IVersionedMemento : IMemento {
    /**
     * Gets the version number.
     * Returns: The version number
     */
    @safe int version_() const;
    
    /**
     * Gets the description of changes.
     * Returns: The change description
     */
    @safe string description() const;
}

/**
 * Multi-level undo manager interface.
 */
interface IMultiLevelUndoManager {
    /**
     * Saves the current state.
     * Params:
     *   description = Optional description of the change
     */
    @safe void save(string description = "");
    
    /**
     * Undoes the last change.
     * Returns: true if undo was successful
     */
    @safe bool undo();
    
    /**
     * Redoes the last undone change.
     * Returns: true if redo was successful
     */
    @safe bool redo();
    
    /**
     * Checks if undo is available.
     * Returns: true if undo is possible
     */
    @safe bool canUndo() const;
    
    /**
     * Checks if redo is available.
     * Returns: true if redo is possible
     */
    @safe bool canRedo() const;
    
    /**
     * Gets the undo history.
     * Returns: Array of change descriptions
     */
    @safe string[] undoHistory() const;
    
    /**
     * Gets the redo history.
     * Returns: Array of change descriptions
     */
    @safe string[] redoHistory() const;
}

/**
 * Compressed memento interface for memory-efficient storage.
 */
interface ICompressedMemento : IMemento {
    /**
     * Gets the compressed size in bytes.
     * Returns: The compressed size
     */
    @safe size_t compressedSize() const;
    
    /**
     * Gets the original size in bytes.
     * Returns: The original size
     */
    @safe size_t originalSize() const;
}
