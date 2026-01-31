/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.jsons.schema.schematype;

import uim.jsons;

mixin(ShowModule!());

@safe:
/**
 * Json Schema type definitions.
 */
enum JsonSchemaType : string {
  String = "string",
  Number = "number",
  Integer = "integer",
  Boolean = "boolean",
  Object = "object",
  Array = "array",
  Null = "null"
}