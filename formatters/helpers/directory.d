/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.formatters.helpers.directory;

import uim.oop;

mixin(Version!"test_uim_oop");

@safe:

class DFormatterDirectory : DDirectory!IFormatter {
  mixin(DirectoryThis!("Formatter"));
}
mixin(DirectoryCalls!("Formatter"));

unittest {
  auto directory = FormatterDirectory;
  assert(testDirectory(directory, "Formatter"), "Test FormatterDirectory failed");
}