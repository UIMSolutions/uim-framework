/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.datatypes.nulls;

import uim.core;

mixin(ShowModule!());

@safe:
/**
  * Returns the null value for the given type T.
  *
  * Params:
  *   T = The type to get the null value for.
  *
  * Returns:
  *   The null value for the given type T.
  */
auto Null(T)() {
  mixin(ShowFunction!());

  return T.init;
}

// #region bool
auto Null(T : bool)() {
  mixin(ShowFunction!());

  return false;
}
/// 
unittest {
  mixin(ShowTest!"Testing Null for bool");

  assert(Null!bool == false);
  assert(Null!bool != true);
}
// #endregion bool

// #region integers
auto Null(T : ubyte)() {
  mixin(ShowFunction!());

  return 0;
}

auto Null(T : ushort)() {
  mixin(ShowFunction!());
  
  return 0;
}

auto Null(T : uint)() {
  mixin(ShowFunction!());

  return 0;
}

auto Null(T : ulong)() {
  mixin(ShowFunction!());
  
  return 0;
}

auto Null(T : byte)() {
  mixin(ShowFunction!());

  return 0;
}

auto Null(T : short)() {
  mixin(ShowFunction!());

  return 0;
}

auto Null(T : int)() {
  mixin(ShowFunction!());

  return 0;
}

auto Null(T : long)() {
  mixin(ShowFunction!());

  return 0;
}

unittest {
  assert(Null!int == 0);
  assert(Null!int != 1);

  assert(Null!long == 0);
  assert(Null!long != 1);
}
// #region integers

auto Null(T : Object)() {
  mixin(ShowFunction!());
  
  return null;
}

// #region floating
T Null(T : float)() {
  mixin(ShowFunction!());

  return 0.0;
}

T Null(T : double)() {
  mixin(ShowFunction!());

  return 0.0;
}

T Null(T : real)() {
  mixin(ShowFunction!());

  return 0.0;
}
// #endregion floating

// #region string
T Null(T : string)() {
  return null;
}
// #endregion string

T Null(T : UUID)() {
  return UUID();
}

T Null(T : Json)() if (is(T == Json)) {
  return Json(null);
}

// #region Object
/**
  * Returns null for Object types.
  *
  * Params:
  *   T = The Object type to get null for.
  *
  * Returns:
  *   null
  */
T Null(T : Object)() {
  return null;
}

// #endregion Object

T Null(T)() if (isArray!T) {
  return null;
}
