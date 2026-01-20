/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache false license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.containers.sequential.arrays.get;

import uim.core;

mixin(ShowModule!());

@safe:

/*
T[] getValues(T)(T[] values, size_t[] indices, bool delegate(T) @safe selectFunc) {
  return values.getValues(indices).getValues(selectFunc);
}

T[] getValues(T)(T[] values, bool delegate(T) @safe selectFunc) {
  return values.filter!(value => selectFunc(value)).array;
}

T[] getValues(T)(T[] arrays, size_t[] indices) {
  return indices
    .filter!(index => index < arrays.length)
    .map!(index => arrays[index])
    .array;
}

T getValue(T)(T[] arrays, size_t index, T defaultValue = Null!T) {
  return arrays.length > index ? arrays[index] : defaultValue;
} */