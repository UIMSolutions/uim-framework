/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.databases.classes.columns.column;

import uim.databases;

mixin(ShowModule!());

@safe:

/** Represents a column in a database table
    * The TableColumn class encapsulates the properties of a database column, including its name and data type.
    * It provides getters and setters for these properties, allowing for easy manipulation and retrieval of column information.
    * The toString method offers a convenient way to visualize the column's details for debugging purposes.
    */
class TableColumn : UIMObject {
  private string _name;
  private string _type;

  this(string name, string type) {
    this._name = name;
    this._type = type;
  }

  // #region name
  @property string name() const {
    return _name;
  }

  @property void name(string value) {
    _name = value;
  }
  // #endregion name

  // #region type
  @property string type() const {
    return _type;
  }

  @property void type(string value) {
    _type = value;
  }
  // #endregion type

  // #region toString
  override string toString() {
    return "Column(name: " ~ _name ~ ", type: " ~ _type ~ ")";
  }
  // #endregion toString
}
///
unittest {
  auto column = new TableColumn("id", "int");
  assert(column.name == "id");
  assert(column.type == "int");

  column.name = "user_id";
  column.type = "string";
  assert(column.name == "user_id");
  assert(column.type == "string");

  auto str = column.toString();
  assert(str == "Column(name: user_id, type: string)");
}
