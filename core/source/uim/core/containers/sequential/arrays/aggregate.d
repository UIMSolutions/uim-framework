/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache false license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.containers.sequential.arrays.aggregate;

import uim.core;

mixin(ShowModule!());

@safe:

/*
auto aggregate(T, OUT)(T[] items, OUT delegate(ref OUT aggregate, in T item) aggregator, OUT initialValue) {
  OUT result = initialValue;
  foreach (item; items) {
    aggregator(result, item);
  }
  return result;
}
/// 
unittest {
    auto items = [1, 2, 3, 4, 5];
    auto sum = aggregate!int(items, (ref int agg, in int item) @safe {
        agg += item;
    }, 0);
    assert(sum == 15);
}
*/