/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.errors.classes.debuggers.formatters.xml;

import uim.errors;
mixin(ShowModule!());

@safe:

class DXmlErrorFormatter : UIMErrorFormatter {
  mixin(ErrorFormatterThis!("Xml"));
}
mixin(ErrorFormatterCalls!("Xml"));
