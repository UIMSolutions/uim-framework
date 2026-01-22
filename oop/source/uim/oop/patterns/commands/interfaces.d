/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.commands.interfaces;

import uim.oop;

mixin(ShowModule!());

@safe:



/**
 * Command queue interface for managing multiple commands.
 */
interface ICommandQueue {
    /**
     * Adds a command to the queue.
     * Params:
     *   command = The command to add
     */
    @safe void enqueue(ICommand command);
    
    /**
     * Executes all commands in the queue.
     */
    @safe void executeAll();
    
    /**
     * Clears the command queue.
     */
    @safe void clear();
    
    /**
     * Gets the number of commands in the queue.
     * Returns: The queue size
     */
    @safe size_t size() const;
}

/**
 * Command history interface for tracking executed commands.
 */
interface ICommandHistory {
    /**
     * Adds a command to the history.
     * Params:
     *   command = The command to record
     */
    @safe void record(IUndoableCommand command);
    
    /**
     * Undoes the last command.
     * Returns: true if undo was successful
     */
    @safe bool undo();
    
    /**
     * Redoes the last undone command.
     * Returns: true if redo was successful
     */
    @safe bool redo();
    
    /**
     * Checks if undo is available.
     * Returns: true if there are commands to undo
     */
    @safe bool canUndo() const;
    
    /**
     * Checks if redo is available.
     * Returns: true if there are commands to redo
     */
    @safe bool canRedo() const;
    
    /**
     * Clears the command history.
     */
    @safe void clear();
}

/**
 * Macro command interface for composite commands.
 * Executes multiple commands as a single command.
 */
interface IMacroCommand : ICommand {
    /**
     * Adds a command to the macro.
     * Params:
     *   command = The command to add
     */
    @safe void addCommand(ICommand command);
    
    /**
     * Gets the number of commands in the macro.
     * Returns: The command count
     */
    @safe size_t commandCount() const;
}

/**
 * Transactional command interface.
 * Supports rollback if execution fails.
 */
interface ITransactionalCommand : ICommand {
    /**
     * Begins the transaction.
     */
    @safe void begin();
    
    /**
     * Commits the transaction.
     */
    @safe void commit();
    
    /**
     * Rolls back the transaction.
     */
    @safe void rollback();
    
    /**
     * Checks if the command is in a transaction.
     * Returns: true if in transaction
     */
    @safe bool inTransaction() const;
}

/**
 * Parameterized command interface.
 * Commands that accept parameters at runtime.
 */
interface IParameterizedCommand(TParam) : ICommand {
    /**
     * Sets the command parameters.
     * Params:
     *   params = The parameters to set
     */
    @safe void setParameters(TParam params);
    
    /**
     * Gets the command parameters.
     * Returns: The current parameters
     */
    @safe TParam getParameters() const;
}
