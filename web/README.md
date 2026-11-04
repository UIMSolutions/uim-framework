# Library 📚 uim-web

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## Overview

**uim-web** is a web development library for D, providing type-safe builders and helpers for common web technologies: CSS generation, HTML generation, JavaScript generation, HTTP utilities and URL handling. Built on top of uim-core and uim-oop.

## Features

### 🎨 CSS (`uim.web.css`)

Generate stylesheets programmatically:

- **Units**: `px`, `em`, `rem`, `percent`, `vh`, `vw`, `deg`, `fr`, `ms`, `s`, ...
- **Colors**: `rgb`, `rgba`, `hsl`, `hsla`, hex normalization and conversion
- **Selectors**: class/id selectors, combinators, pseudo classes, attribute selectors
- **Declarations & Rules**: `CssDeclaration`, `CssRule` with fluent interfaces; `rule.apply(...)` takes the output of the property helpers
- **Properties**: shorthands for box model, borders, backgrounds, shadows, typography, transforms, transitions, flexbox and grid
- **Variables**: CSS custom properties with `var()` support
- **Functions**: `cssCalc`, `cssClamp`, `cssMin`, `cssMax`, `cssUrl`, `cssString`, `cssEscape`
- **Media queries**: `CssMedia` with conditions like `maxWidth`, `prefersDark`
- **At-rules**: `cssSupports`, `cssContainer`, `cssLayer`, `cssFontFace`, `@import` via `sheet.importUrl`
- **Animations**: `CssKeyframes` builder
- **Stylesheets**: `CssStyleSheet` renders entries in insertion order, so the cascade follows your code; `minify` works on the structure and leaves strings intact

```d
auto sheet = cssStyleSheet();
sheet.rule("body").set("margin", "0");
sheet.rule(".box").apply(flexCenter, margin(px(8)));
sheet.media(maxWidth(px(600))).rule(".sidebar").set("display", "none");
string css = sheet.minify;
```

### 📝 HTML (`uim.web.html`)

Generate HTML programmatically with automatic escaping:

- **Elements**: `HtmlElement` with attributes, classes (`addClass`, `removeClass`, `toggleClass`, `hasClass`), data-/aria-attributes, nesting
- **Text**: headings, paragraphs, `strong`, `em`, `code`, `blockquote`, ...
- **Semantic elements**: `header`, `nav`, `mainElement`, `article`, `section`, `aside`, `footer`, `figure`, `details`, `dialog`
- **Lists**: `ul`, `ol`, `dl`, navigation lists (pass pairs to keep your order, associative arrays are sorted)
- **Tables**: `HtmlTable` builder with caption, header and rows
- **Forms**: `form`, `input` (all common types), `select`, `textarea`, `button`, `fieldset`, `datalist`, `progress`, `meter`
- **Media**: links, images, `video`, `audio`, `picture`, `iframe`
- **Meta & SEO**: charset, viewport, description, Open Graph, Twitter Cards
- **Documents**: `HtmlDocument` for complete HTML5 pages; added elements stay live until the document is rendered
- **Rendering**: nodes write into one buffer. Subclass `HtmlNode` and implement `render(sink)` for custom nodes

```d
auto doc = htmlDocument("My page")
  .stylesheet("style.css")
  .raw(heading(1, "Hello"));
```

Text and attribute values are escaped, and tag and attribute names that would break the markup throw. `raw` is not escaped. Escaping does not check where a URL points: pass URLs from users through `isSafeUrl` or `safeUrl`.

### 📜 JavaScript (`uim.web.js`)

Generate JavaScript code safely:

- **Values**: `jsString`, `jsBool`, `jsNumber`, `jsArray`, `jsObject`, `jsValue(Json)` with proper escaping, safe inside inline scripts
- **Functions**: declarations, arrow functions, IIFE, control flow (`jsIf`, `jsFor`, `jsTryCatch`)
- **DOM**: selectors, event listeners, classList, styles, storage
- **Fetch**: `JsFetch` builder for HTTP calls with JSON support, `credentials`, `ensureOk`, `thenText`
- **Scripts**: script tags (with optional CSP nonce), event handler attributes, lifecycle wrappers

```d
auto request = jsFetch("/api/users")
  .method("POST")
  .jsonBody(`{"name":"uim"}`)
  .thenJson("render(data);");
```

### 🌐 HTTP (`uim.web.http`)

HTTP protocol utilities:

- **Methods**: `HttpMethod` enum with safe/idempotent checks
- **Status codes**: `HttpStatus` enum with reason phrases and category checks
- **Headers**: case-insensitive `HttpHeaders` collection, protected against header injection; well-known header lines, `securityHeaders`, `CspBuilder` for Content-Security-Policy
- **Cookies**: `httpCookie` builder for Set-Cookie, `expiredCookie`, `parseCookies`
- **MIME types**: extension lookup, reverse lookup, `contentTypeForFile`, category checks that ignore case and parameters

```d
auto headers = httpHeaders()
  .set("Content-Type", "application/json")
  .set("Cache-Control", "no-cache")
  .add("Set-Cookie", httpCookie("session", id).path("/").secure.httpOnly.sameSite("Lax").toString);
```

### 🔗 URL (`uim.web.url`)

URL parsing and building:

- **Encoding**: `percentEncode`/`percentDecode`, form encoding, `encodePathSegment`, `encodeFragment`
- **Query strings**: `QueryParams` with multi-value support, parsing and rendering
- **URLs**: `Url` parser and builder with scheme, user info, host (incl. IPv6), port, segments, query, fragment, and URLs without authority such as `mailto:`
- **Untrusted URLs**: `isSafeUrl`/`safeUrl` reject `javascript:` and other schemes outside an allowlist
- **Slugs**: `slugify` with transliteration (German umlauts, Turkish, Polish, Czech and more)

```d
auto api = urlBuilder("https", "api.example.com")
  .addSegment("v1")
  .addSegment("users")
  .param("limit", "10");
// https://api.example.com/v1/users?limit=10
```

## License

Apache-2.0 — see [LICENSE](../LICENSE)
