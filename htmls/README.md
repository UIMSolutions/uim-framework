# UIM HTML Library

A comprehensive D language library for generating HTML programmatically.

## Features

- **Object-Oriented Design**: Clean, chainable API for building HTML
- **Type Safety**: Compile-time type checking for HTML elements
- **Full HTML5 Support**: Common elements, forms, tables, lists, and more
- **Attribute Management**: Easy attribute setting and manipulation
- **Document Generation**: Complete HTML document builder
- **Self-Closing Tags**: Automatic handling of void elements (br, hr, img, etc.)

## Installation

Add to your `dub.sdl`:
```sdl
dependency "uim-htmls" version="~>1.0.0"
```

Or `dub.json`:
```json
{
    "dependencies": {
        "uim-htmls": "~>1.0.0"
    }
}
```

## Quick Start

```d
import uim.htmls;

void main() {
    // Create a simple div
    auto div = Div("Hello World");
    writeln(div); // <div>Hello World</div>
    
    // Add attributes
    div.id("main").addClass("container");
    
    // Create nested elements
    auto container = Div()
        .id("wrapper")
        .addChild(H1("Welcome"))
        .addChild(P("This is a paragraph"));
    
    writeln(container);
}
```

## Basic Elements

### Text Elements
```d
// Headings
auto h1 = H1("Main Title");
auto h2 = H2("Subtitle");
auto h3 = H3("Section");

// Paragraph
auto p = P("This is a paragraph of text");

// Span and Div
auto span = Span("Inline text");
auto div = Div("Block content");
```

### Links and Images
```d
// Link
auto link = A("https://example.com", "Click here");
link.targetBlank(); // Opens in new tab

// Image
auto img = Img("photo.jpg", "Photo description");
img.width("300").height("200");
```

### Line Breaks and Rules
```d
auto br = Br();  // <br />
auto hr = Hr();  // <hr />
```

## Forms

### Basic Form
```d
auto form = Form()
    .action("/submit")
    .post()
    .addChild(
        Label("username", "Username:")
    )
    .addChild(
        InputText("username").placeholder("Enter username")
    )
    .addChild(
        Label("password", "Password:")
    )
    .addChild(
        InputPassword("password")
    )
    .addChild(
        ButtonSubmit("Login")
    );
```

### Input Types
```d
auto textInput = InputText("name");
auto password = InputPassword("password");
auto email = InputEmail("email");
auto number = InputNumber("age");
auto checkbox = InputCheckbox("agree");
auto radio = InputRadio("option");
auto file = InputFile("upload");
auto hidden = InputHidden("token");
auto submit = InputSubmit("Submit");
```

### Other Form Elements
```d
// Textarea
auto textarea = Textarea("comment")
    .rows("5")
    .cols("40")
    .placeholder("Enter your comment");

// Select dropdown
auto select = Select("country")
    .addOption("us", "United States")
    .addOption("uk", "United Kingdom")
    .addOption("ca", "Canada");

// Button
auto button = Button("Click Me");
auto submitBtn = ButtonSubmit("Submit Form");
auto resetBtn = ButtonReset("Reset Form");
```

## Tables

```d
auto table = Table().addClass("data-table");

// Add header
auto thead = Thead();
auto headerRow = Tr()
    .addChild(Th("Name"))
    .addChild(Th("Age"))
    .addChild(Th("Email"));
thead.addChild(headerRow);

// Add body
auto tbody = Tbody();
auto row1 = Tr()
    .addChild(Td("John Doe"))
    .addChild(Td("30"))
    .addChild(Td("john@example.com"));
tbody.addChild(row1);

// Assemble table
table.addChild(thead).addChild(tbody);
```

### Table Attributes
```d
// Cell spanning
auto td = Td("Content").colspan("2").rowspan("3");
auto th = Th("Header").scope("col");
```

## Lists

### Unordered List
```d
auto ul = Ul()
    .addChild(Li("First item"))
    .addChild(Li("Second item"))
    .addChild(Li("Third item"));
```

### Ordered List
```d
auto ol = Ol()
    .start("5")  // Start from 5
    .addChild(Li("Item 5"))
    .addChild(Li("Item 6"));
```

### Definition List
```d
auto dl = Dl()
    .addChild(Dt("HTML"))
    .addChild(Dd("HyperText Markup Language"))
    .addChild(Dt("CSS"))
    .addChild(Dd("Cascading Style Sheets"));
```

## Complete HTML Documents

```d
auto doc = HtmlDocument()
    .title("My Page")
    .lang("en");

// Add meta tags
doc.addMeta("description", "A sample page")
   .addMeta("keywords", "html, d, programming");

// Add stylesheets
doc.addStylesheet("css/main.css")
   .addStylesheet("css/theme.css");

// Add inline style
doc.addInlineStyle("body { margin: 0; padding: 0; }");

// Add scripts
doc.addScript("js/app.js");

// Add inline script
doc.addInlineScript("console.log('Hello');");

// Build content
doc.body()
   .addChild(H1("Welcome to My Page"))
   .addChild(P("This is the content"))
   .addChild(
       Div().id("content").addClass("main")
   );

// Generate HTML
writeln(doc);
```

## Working with Attributes

### Common Attributes
```d
auto element = Div()
    .id("main")                    // Set ID
    .addClass("container")         // Add CSS class
    .addClass("responsive")        // Add another class
    .style("color: red;")          // Set inline style
    .attribute("data-id", "123");  // Custom attribute
```

### Getting Attributes
```d
string id = element.id();  // Get ID
auto classAttr = element.attribute("class");  // Get attribute object
```

## Advanced Usage

### Building Complex Structures
```d
auto page = Div().addClass("page")
    .addChild(
        Div().addClass("header")
            .addChild(H1("Site Title"))
            .addChild(
                Ul().addClass("nav")
                    .addChild(Li().addChild(A("/", "Home")))
                    .addChild(Li().addChild(A("/about", "About")))
                    .addChild(Li().addChild(A("/contact", "Contact")))
            )
    )
    .addChild(
        Div().addClass("content")
            .addChild(H2("Page Content"))
            .addChild(P("Lorem ipsum dolor sit amet..."))
    )
    .addChild(
        Div().addClass("footer")
            .addChild(P("© 2026 My Site"))
    );
```

### Custom Elements
```d
// Extend DHtmlElement for custom elements
class MyCustomElement : DHtmlElement {
    this() {
        super("custom-element");
    }
    
    auto customMethod(string value) {
        return attribute("custom-attr", value);
    }
}
```

## API Reference

### Core Classes

- `DHtmlElement` - Base class for all HTML elements
- `DHtmlAttribute` - Represents an HTML attribute
- `DHtmlDocument` - Complete HTML document builder

### Element Categories

- **Basic**: Div, Span, P, H1-H6, Br, Hr
- **Links**: A, Link
- **Media**: Img
- **Forms**: Form, Input, Button, Textarea, Select, Option, Label
- **Tables**: Table, Tr, Td, Th, Thead, Tbody, Tfoot
- **Lists**: Ul, Ol, Li, Dl, Dt, Dd

## Testing

The library includes comprehensive unit tests. Run tests with:

```bash
dub test
```

## License

Apache 2.0 - Copyright © 2018-2026 Ozan Nurettin Süel

## Contributing

Contributions are welcome! Please submit pull requests or open issues on the project repository.
