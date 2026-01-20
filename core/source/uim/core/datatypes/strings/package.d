/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.datatypes.strings;

public {
  import uim.core.datatypes.strings.bind;
  import uim.core.datatypes.strings.camelize;
  import uim.core.datatypes.strings.capitalize;
  import uim.core.datatypes.strings.classify;
  import uim.core.datatypes.strings.convert;
  import uim.core.datatypes.strings.delimit;
  import uim.core.datatypes.strings.doublemustache;
  import uim.core.datatypes.strings.endswith;
  import uim.core.datatypes.strings.humanize;
  import uim.core.datatypes.strings.lower;
  import uim.core.datatypes.strings.md5;
  import uim.core.datatypes.strings.mustache;
  import uim.core.datatypes.strings.pascalize;
  import uim.core.datatypes.strings.pluralize;
  import uim.core.datatypes.strings.singularize;
  import uim.core.datatypes.strings.striptext;
  import uim.core.datatypes.strings.startswith;
  import uim.core.datatypes.strings.tableize;
  import uim.core.datatypes.strings.underscore;
  import uim.core.datatypes.strings.upper;
}

static immutable string[string] singularIrregulars;
static immutable string[string] pluralIrregulars;
shared static this() {
  singularIrregulars = [
    "people": "person",
    "men": "man",
    "women": "woman",
    "children": "child",
    "teeth": "tooth",
    "feet": "foot",
    "mice": "mouse",
    "oxen": "ox",
    "geese": "goose"
  ];

  pluralIrregulars = [
    "person": "people",
    "man": "men",
    "woman": "women",
    "child": "children",
    "tooth": "teeth",
    "foot": "feet",
    "mouse": "mice",
    "ox": "oxen",
    "goose": "geese"
  ];
}