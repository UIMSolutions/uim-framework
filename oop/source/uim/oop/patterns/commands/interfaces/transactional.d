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
  void begin();

  /**
     * Commits the transaction.
     */
  void commit();

  /**
     * Rolls back the transaction.
     */
  void rollback();

  /**
     * Checks if the command is in a transaction.
     * Returns: true if in transaction
     */
  bool inTransaction() const;
}
