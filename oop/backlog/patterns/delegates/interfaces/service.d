/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.patterns.delegates.interfaces.service;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Generic Business Service interface with typed input and output.
 */
interface IGenericBusinessService(TInput, TOutput) {
  /**
   * Execute a business operation with input data.
   * Params:
   *   input = The input data for the operation
   * Returns: Result of the business operation
   */
  TOutput execute(TInput input);

  /**
   * Get the service name.
   * Returns: The name of this service
   */
  string serviceName();
}










