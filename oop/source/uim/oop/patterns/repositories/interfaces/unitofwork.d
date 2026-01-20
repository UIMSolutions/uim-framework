module uim.oop.patterns.repositories.interfaces.unitofwork;


import uim.oop;

mixin(ShowModule!());

@safe:



/**
 * Unit of Work interface for transactional operations.
 */
interface IUnitOfWork {
  /**
     * Commit all pending changes.
     */
  void commit();

  /**
     * Rollback all pending changes.
     */
  void rollback();

  /**
     * Check if there are pending changes.
     */
  bool hasChanges();
}
