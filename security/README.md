# Library 📚 uim-security

[![uim-security](https://github.com/UIMSolutions/uim-framework/actions/workflows/uim-security.yml/badge.svg)](https://github.com/UIMSolutions/uim-framework/actions/workflows/uim-security.yml) [![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

Small security helpers for D applications using vibe.d. Includes password hashing, JWT utilities, API-key and CSRF helpers, rate limiting, and HTTP guard helpers you can drop into route handlers.

## Features

- PBKDF2-HMAC-SHA256 password hashing and verification
- JWT signing and verification (HS256) with expiry support
- API key validation and CSRF token helpers
- Token-bucket rate limiter for per-client throttling
- vibe.d helpers to guard routes (API key headers, Bearer JWTs, rate limit responses)

## Quick Start

### Hash and verify passwords

```d
import uim.security.crypto;

auto hashed = hashPassword("s3cret");
auto ok = verifyPassword("s3cret", hashed);
```

### Sign and verify JWTs

```d
import std.json : Json;
import std.datetime : seconds;
import uim.security.jwt;

Json payload = Json(["sub": Json("user-123"), "role": Json("admin")]);
auto token = signJWT(payload, "super-secret", 3600.seconds);
auto claims = verifyJWT(token, "super-secret");
```

### Guard a vibe.d route

```d
import uim.security.middleware;
import uim.security.jwt;
import vibe.http.router : URLRouter;

URLRouter router;
string secret = "super-secret";

router.get("/secure", (req, res) {
    Json claims;
    if (!authenticateBearerJWT(req, res, secret, claims)) return;
    res.writeBody("hello " ~ claims["sub"].str);
});
```

### Apply rate limiting per client

```d
import uim.security.rate_limit;
import std.datetime : seconds;

TokenBucketRateLimiter limiter(10, 5, 1.seconds); // capacity=10, refill 5 tokens/sec
if (!limiter.allow("client-id")) {
    // reject request
}
```

## Notes

- Intended for lightweight services; keys are kept in-memory. Persist if you need durability.
- PBKDF2 uses HMAC-SHA256 with a random salt and configurable iterations. Default is 20,000 iterations.
- JWTs use HS256; keep your secret safe and rotate it as needed.
