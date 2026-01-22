module uim.oop.patterns.commands.interfaces.transactional;

import uim.oop;

mixin(ShowModule!());

@safe:
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