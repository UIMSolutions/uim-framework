/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/

module uim.entities.classes.elements.configuration;

import uim.entities;

@safe:
class ConfigurationElement : UIMElement {
  // Constructors
  this() { initialize; }
}
auto ConfigurationElement() { return new DConfigurationElement; }
/* auto Configuration(string name) { return new DConfiguration(name); }
auto Configuration(Json json) { return new DConfiguration(json); } */

///
unittest {
  auto element = new DConfigurationElement;
  assert(element.name("test").name == "test");
  assert(element.name("testName").name == "testName");
}
