/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.security.rate_limit;

import std.algorithm : min;
import std.datetime : Clock, Duration, SysTime, seconds;
import std.exception : enforce;

@safe:

/// Simple token bucket limiter keyed by client identifier.
class TokenBucketRateLimiter {
public:
  this(double capacity, double refillPerSecond, Duration maxIdle = 5.seconds) {
    enforce(capacity > 0 && refillPerSecond > 0, "Token bucket parameters must be positive");
    this.capacity = capacity;
    this.refillPerSecond = refillPerSecond;
    this.maxIdle = maxIdle;
  }

  /// Attempts to consume one token for `clientId`. Returns true if allowed.
  bool allow(string clientId) {
    auto bucket = clientId in buckets;
    auto now = Clock.currTime();

    if (bucket is null) {
      buckets[clientId] = TokenBucket(capacity - 1, now);
      return true;
    }

    refill(*bucket, now);
    if (bucket.tokens < 1.0) {
      return false;
    }

    bucket.tokens -= 1.0;
    return true;
  }

  void setCapacity(double capacity) {
    enforce(capacity > 0, "Capacity must be positive");
    this.capacity = capacity;
  }

  void setRefillRate(double refillPerSecond) {
    enforce(refillPerSecond > 0, "Refill rate must be positive");
    this.refillPerSecond = refillPerSecond;
  }

private:
  struct TokenBucket {
    double tokens;
    SysTime lastUpdated;
  }

  void refill(ref TokenBucket bucket, SysTime now) {
    auto elapsed = now - bucket.lastUpdated;
    bucket.lastUpdated = now;

    if (elapsed > maxIdle) {
      bucket.tokens = capacity;
      return;
    }

    double elapsedSeconds = cast(double) elapsed.total!"msecs" / 1000.0;
    bucket.tokens = min(capacity, bucket.tokens + refillPerSecond * elapsedSeconds);
  }

  double capacity;
  double refillPerSecond;
  Duration maxIdle;
  TokenBucket[string] buckets;
}
