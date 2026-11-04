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
- **Declarations & Rules**: `CssDeclaration`, `CssRule` with fluent interfaces
- **Properties**: shorthands for box model, borders, backgrounds, shadows, typography, transforms, transitions, flexbox and grid
- **Variables**: CSS custom properties with `var()` support
- **Media queries**: `CssMedia` with conditions like `maxWidth`, `prefersDark`
- **Animations**: `CssKeyframes` builder
- **Stylesheets**: `CssStyleSheet` with pretty and minified rendering

```d
auto sheet = cssStyleSheet();
sheet.rule("body").set("margin", "0");
sheet.media(maxWidth(px(600))).rule(".sidebar").set("display", "none");
```

### 📝 HTML (`uim.web.html`)

Generate HTML programmatically with automatic escaping:

- **Elements**: `HtmlElement` with attributes, classes, data-/aria-attributes, nesting
- **Text**: headings, paragraphs, `strong`, `em`, `code`, `blockquote`, ...
- **Semantic elements**: `header`, `nav`, `mainElement`, `article`, `section`, `aside`, `footer`, `figure`, `details`, `dialog`
- **Lists**: `ul`, `ol`, `dl`, navigation lists
- **Tables**: `HtmlTable` builder with caption, header and rows
- **Forms**: `form`, `input` (all common types), `select`, `textarea`, `button`, `fieldset`, `datalist`, `progress`, `meter`
- **Media**: links, images, `video`, `audio`, `picture`, `iframe`
- **Meta & SEO**: charset, viewport, description, Open Graph, Twitter Cards
- **Documents**: `HtmlDocument` for complete HTML5 pages

```d
auto doc = htmlDocument("My page")
  .stylesheet("style.css")
  .raw(heading(1, "Hello"));
```

### 📜 JavaScript (`uim.web.js`)

Generate JavaScript code safely:

- **Values**: `jsString`, `jsBool`, `jsNumber`, `jsArray`, `jsObject`, `jsValue(Json)` with proper escaping
- **Functions**: declarations, arrow functions, IIFE, control flow (`jsIf`, `jsFor`, `jsTryCatch`)
- **DOM**: selectors, event listeners, classList, styles, storage
- **Fetch**: `JsFetch` builder for HTTP calls with JSON support
- **Scripts**: script tags, event handler attributes, lifecycle wrappers

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
- **Headers**: `HttpHeaders` collection, well-known values, `CspBuilder` for Content-Security-Policy
- **MIME types**: extension lookup, reverse lookup, category checks

```d
auto headers = httpHeaders()
  .set("Content-Type", "application/json")
  .set("Cache-Control", "no-cache");
```

### 🔗 URL (`uim.web.url`)

URL parsing and building:

- **Encoding**: `percentEncode`/`percentDecode`, form encoding
- **Query strings**: `QueryParams` with multi-value support, parsing and rendering
- **URLs**: `Url` parser and builder with scheme, host, port, segments, query, fragment
- **Slugs**: `slugify` with transliteration (incl. German umlauts)

```d
auto api = urlBuilder("https", "api.example.com")
  .addSegment("v1")
  .addSegment("users")
  .param("limit", "10");
// https://api.example.com/v1/users?limit=10
```

## License

Apache-2.0 — see [LICENSE](../LICENSE)
