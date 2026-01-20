/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.formatters.helpers.list;

import uim.oop;

mixin(Version!"test_uim_oop");

@safe:

class DFormatterList : UIMList!IFormatter {
  mixin(ListThis!("Formatter"));
}
mixin(ListCalls!("Formatter"));

unittest {
  auto list = FormatterList;
  assert(testList(list, "Formatter"), "Test FormatterList failed");
}