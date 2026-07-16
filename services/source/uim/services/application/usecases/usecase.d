/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.services.application.usecases.usecase;

import uim.services;

mixin(ShowModule!());

@safe:

class UseCase {
  /// Executes the use case with the given input and returns a CommandResult.
  abstract UsecaseResult execute(string input);
}