/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.containers.sequential.arrays;

public {
  import uim.core.containers.sequential.arrays.array_;
  import uim.core.containers.sequential.arrays.aggregate;
  import uim.core.containers.sequential.arrays.check;
  import uim.core.containers.sequential.arrays.chunks;
  import uim.core.containers.sequential.arrays.compact;
  import uim.core.containers.sequential.arrays.concat;
  import uim.core.containers.sequential.arrays.contains;
  import uim.core.containers.sequential.arrays.cross;
  import uim.core.containers.sequential.arrays.deduplicate;
  import uim.core.containers.sequential.arrays.differences;
  import uim.core.containers.sequential.arrays.distribute;
  import uim.core.containers.sequential.arrays.drop;
  import uim.core.containers.sequential.arrays.duplicates;
  import uim.core.containers.sequential.arrays.every;
  import uim.core.containers.sequential.arrays.filter;
  import uim.core.containers.sequential.arrays.find;
  import uim.core.containers.sequential.arrays.first;
  import uim.core.containers.sequential.arrays.flattenmap;
  import uim.core.containers.sequential.arrays.fold;
  import uim.core.containers.sequential.arrays.has;
  import uim.core.containers.sequential.arrays.get;
  import uim.core.containers.sequential.arrays.group;
  import uim.core.containers.sequential.arrays.indexof;
  import uim.core.containers.sequential.arrays.insert;
  import uim.core.containers.sequential.arrays.intersect;
  import uim.core.containers.sequential.arrays.last;
  import uim.core.containers.sequential.arrays.merge;
  import uim.core.containers.sequential.arrays.minmax;
  import uim.core.containers.sequential.arrays.move;
  import uim.core.containers.sequential.arrays.nat;// ive;
  import uim.core.containers.sequential.arrays.partition;
  import uim.core.containers.sequential.arrays.pick;
  import uim.core.containers.sequential.arrays.positions;
  import uim.core.containers.sequential.arrays.remove;
  import uim.core.containers.sequential.arrays.replace;
  import uim.core.containers.sequential.arrays.reverse;
  import uim.core.containers.sequential.arrays.rotate;
  import uim.core.containers.sequential.arrays.sample;
  import uim.core.containers.sequential.arrays.shuffle;
  import uim.core.containers.sequential.arrays.sorting;
  import uim.core.containers.sequential.arrays.split;
  import uim.core.containers.sequential.arrays.sub;
  /* import uim.core.containers.sequential.arrays.splice;
  import uim.core.containers.sequential.arrays.sum;
  import uim.core.containers.sequential.arrays.swap;
  import uim.core.containers.sequential.arrays.take;
  import uim.core.containers.sequential.arrays.transpose;
  import uim.core.containers.sequential.arrays.transform;
  import uim.core.containers.sequential.arrays.unique;
  import uim.core.containers.sequential.arrays.unzipmap;
  import uim.core.containers.sequential.arrays.zipmap;
  import uim.core.containers.sequential.arrays.zipwith;
  import uim.core.containers.sequential.arrays.zipwithindex;
  import uim.core.containers.sequential.arrays.zipwithindexes;
  import uim.core.containers.sequential.arrays.zipwithmap; */ 

  import uim.core.containers.sequential.arrays.filter;
  import uim.core.containers.sequential.arrays.flatten;
  import uim.core.containers.sequential.arrays.pairs;
  import uim.core.containers.sequential.arrays.rest;
  import uim.core.containers.sequential.arrays.shift;
  import uim.core.containers.sequential.arrays.without;
  import uim.core.containers.sequential.arrays.unzip;
  import uim.core.containers.sequential.arrays.unique;
  import uim.core.containers.sequential.arrays.zip;
}
