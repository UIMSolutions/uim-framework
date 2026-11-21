/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.interfaces.entity;

import uim.service;

mixin(ShowModule!());

@safe:

interface IUIMEntity {
  UUID id(); // Unique identifier for the entity
  void id(UUID id);

  string name(); // Name of the entity
  void name(string name);

  string description(); // Description of the entity
  void description(string description);

  Json toJson(); // Method to serialize the entity to JSON

  string toString(); // Method to get a string representation of the entity 
}
