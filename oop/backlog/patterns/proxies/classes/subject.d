/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.patterns.proxies.classes.subject;

import uim.oop;

mixin(ShowModule!());

@safe:


/**
 * Base abstract class for subjects.
 */
abstract class ProxySubject : IProxySubject {
  /**
   * Execute the subject's main operation.
   */
  abstract string execute() @safe;
}