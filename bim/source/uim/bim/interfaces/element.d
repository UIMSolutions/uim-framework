/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.bim.interfaces.element;

import uim.bim;

mixin(ShowModule!());

@safe:

/**
 * IBimElement - Base interface for all BIM elements.
 * Represents any physical or logical entity in a building model, following
 * the IFC (Industry Foundation Classes) conceptual model.
 */
interface IBimElement {
  // #region identity
  string globalId();
  IBimElement globalId(string value);

  string name();
  IBimElement name(string value);

  string description();
  IBimElement description(string value);

  string objectType();
  IBimElement objectType(string value);

  string tag();
  IBimElement tag(string value);
  // #endregion identity

  // #region classification
  string ifcClass();
  string[] classifications();
  IBimElement addClassification(string code);
  IBimElement removeClassification(string code);
  // #endregion classification

  // #region properties
  Json[string] properties();
  IBimElement properties(Json[string] value);
  IBimElement setProperty(string key, Json value);
  Json getProperty(string key, Json defaultValue = Json.undefined);
  bool hasProperty(string key);
  // #endregion properties

  // #region relationships
  string parentId();
  IBimElement parentId(string value);

  string[] childIds();
  IBimElement addChildId(string id);
  IBimElement removeChildId(string id);
  // #endregion relationships

  // #region serialization
  Json toJson();
  IBimElement fromJson(Json data);
  // #endregion serialization
}
