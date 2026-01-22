module uim.oop.patterns.commands.interfaces.queue;

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