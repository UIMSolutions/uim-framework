/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.datasources.cache.cache;

import uim.datasources;

mixin(ShowModule!());

@safe:

/**
 * Cache entry
 */
class CacheEntry {
  string key;
  Json value;
  SysTime createdAt;
  size_t ttl; // Time to live in seconds
  long hitCount;

  this(string k, Json v, size_t timeToLive = 3600) {
    key = k;
    value = v;
    ttl = timeToLive;
    createdAt = Clock.currTime();
    hitCount = 0;
  }

  bool isExpired() {
    if (ttl == 0) return false; // No expiration
    auto elapsed = (Clock.currTime() - createdAt).total!"seconds";
    return elapsed > ttl;
  }

  void touch() {
    hitCount++;
  }
}




