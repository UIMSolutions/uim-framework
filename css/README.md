# UIM CSS Library

A comprehensive CSS parsing, manipulation, and generation library for D.

## Features

- **Parse CSS**: Parse CSS strings into structured objects
- **Build CSS**: Fluent API for building CSS stylesheets
- **Manipulate CSS**: Query and modify CSS rules and properties
- **Media Queries**: Full support for responsive design with media queries
- **CSS Variables**: Support for CSS custom properties (variables)
- **Selectors**: Multiple selectors per rule
- **Important Flag**: Support for `!important` declarations
- **Comments**: Automatic handling of CSS comments during parsing

## Installation

Add the dependency in your `dub.sdl`:

```sdl
dependency "uim-base:css" version="~>1.0.0"
```

Or in `dub.json`:

```json
{
    "dependencies": {
        "uim-base:css": "~>1.0.0"
    }
}
```

## Quick Start

```d
import uim.css;

// Build CSS using fluent API
auto stylesheet = css()
    .rule(".button")
        .backgroundColor("#007bff")
        .color("#fff")
        .padding("10px 20px")
        .borderRadius("4px")
    .endRule()
    .build();

writeln(stylesheet.toString());
```

Output:
```css
.button {
  background-color: #007bff;
  color: #fff;
  padding: 10px 20px;
  border-radius: 4px;
}
```

## Usage Examples

### Parsing CSS

```d
import uim.css;

string cssCode = `
    .container {
        width: 1200px;
        margin: 0 auto;
    }
    
    .button {
        background-color: #007bff;
        color: white;
    }
`;

auto stylesheet = parseCSS(cssCode);
writeln(stylesheet.toString());
```

### Building CSS with Fluent API

```d
auto builder = css()
    .rule("body")
        .margin("0")
        .padding("0")
        .fontSize("16px")
    .endRule()
    .rule(".container")
        .width("1200px")
        .margin("0 auto")
    .endRule();

writeln(builder.toString());
```

### Multiple Selectors

```d
auto builder = css()
    .rule(".button")
        .addSelector(".btn")
        .display("inline-block")
        .padding("10px 20px")
    .endRule();

// Outputs:
// .button, .btn {
//   display: inline-block;
//   padding: 10px 20px;
// }
```

### Media Queries

```d
auto builder = css()
    .rule(".container")
        .width("1200px")
    .endRule()
    .media("screen", ["max-width: 768px"])
        .rule(".container")
            .width("100%")
        .endRule()
    .endMedia();
```

### CSS Variables

```d
auto builder = css()
    .variable("primary-color", "#007bff")
    .variable("spacing", "1rem")
    .rule(".element")
        .property("color", "var(--primary-color)")
        .property("margin", "var(--spacing)")
    .endRule();

// Outputs:
// :root {
//   --primary-color: #007bff;
//   --spacing: 1rem;
// }
// 
// .element {
//   color: var(--primary-color);
//   margin: var(--spacing);
// }
```

### Manipulating CSS

```d
auto stylesheet = parseCSS(".box { width: 100px; }");

// Find rules by selector
auto rules = stylesheet.findRules(".box");
if (rules.length > 0) {
    auto rule = rules[0];
    
    // Add or update properties
    rule.setProperty("height", "100px");
    rule.setProperty("background-color", "#f0f0f0");
    
    // Check if property exists
    if (rule.hasProperty("width")) {
        writeln("Width: ", rule.getProperty("width"));
    }
    
    // Remove property
    rule.removeProperty("width");
}

writeln(stylesheet.toString());
```

### Important Declarations

```d
auto builder = css()
    .rule(".override")
        .property("color", "red", true) // !important
    .endRule();

// Or when creating properties directly
auto rule = new CSSRule(".override");
rule.addProperty("color", "red", true);
```

## API Reference

### CSSStyleSheet

The main container for CSS rules and media queries.

- `addRule(CSSRule)` - Add a rule to the stylesheet
- `addMediaQuery(CSSMediaQuery)` - Add a media query
- `setVariable(name, value)` - Set a CSS variable
- `getVariable(name)` - Get a CSS variable value
- `findRules(selector)` - Find rules by selector
- `toString()` - Generate CSS string

### CSSRule

Represents a CSS rule with selectors and properties.

- `addSelector(selector)` - Add a selector
- `addProperty(name, value, important)` - Add a property
- `setProperty(name, value, important)` - Set or update a property
- `getProperty(name)` - Get property value
- `hasProperty(name)` - Check if property exists
- `removeProperty(name)` - Remove a property
- `toString()` - Generate CSS string

### CSSBuilder

Fluent API for building stylesheets.

- `rule(selector)` - Start a new rule
- `property(name, value, important)` - Add property
- `endRule()` - Finish current rule
- `media(type, conditions)` - Start media query
- `endMedia()` - Finish media query
- `variable(name, value)` - Add CSS variable
- `build()` - Get the stylesheet

Convenience methods:
- `color(value)`, `backgroundColor(value)`
- `fontSize(value)`, `fontWeight(value)`
- `margin(value)`, `padding(value)`
- `width(value)`, `height(value)`
- `display(value)`, `position(value)`
- `border(value)`, `borderRadius(value)`
- `textAlign(value)`
- `flexDirection(value)`, `justifyContent(value)`, `alignItems(value)`

### CSSParser

Parse CSS strings into structured objects.

- `parse()` - Parse the CSS and return a CSSStyleSheet
- `parseCSS(css)` - Convenience function for parsing

## Examples

See the [examples](examples/) directory for complete working examples:

- `example.d` - Comprehensive examples of all features

Run the example:
```bash
cd examples
dub run
```

## Building and Testing

Build the library:
```bash
dub build
```

Run tests:
```bash
dub test
```

Build documentation:
```bash
dub build --build=docs
```

## License

This library is licensed under the Apache License 2.0. See LICENSE.txt for details.

## Author

Ozan Nurettin Süel (UIManufaktur)
