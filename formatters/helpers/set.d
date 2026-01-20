/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.formatters.helpers.set;

import uim.oop;

mixin(Version!"test_uim_oop");

@safe:

class DFormatterSet : UIMSet!IFormatter {
  mixin(SetThis!("Formatter"));
}
mixin(SetCalls!("Formatter"));

unittest {
  auto set = FormatterSet;
  assert(testSet(set, "Formatter"), "Test FormatterSet failed");
}