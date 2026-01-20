/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.containers.sequential.arrays.nat;

auto natArray(T)(T[] arr) if (is(T == ubyte) || is(T == ushort) || is(T == uint) || is(T == ulong) || is(T == byte) || is(T == short) || is(T == int) || is(T == long)) {
  import std.array : array;
  import std.algorithm : map;
  return arr.map!(x => cast(nat)x).array;
}