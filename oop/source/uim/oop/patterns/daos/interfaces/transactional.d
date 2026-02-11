/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.patterns.daos.interfaces.transactional;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Transaction support for DAO operations.
 */
interface ITransactionalDAO(T, ID) : IDAO!(T, ID) {
  /**
   * Begin a transaction.
   */
  void beginTransaction();

  /**
   * Commit the current transaction.
   */
  void commit();

  /**
   * Rollback the current transaction.
   */
  void rollback();

  /**
   * Check if a transaction is active.
   * Returns: true if transaction is active
   */
  bool isTransactionActive();
}