module example;

/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/

import std.stdio;
import uim.html;

void main() {
  writeln("=== UIM HTML Library Examples ===\n");

  // Example 1: Simple Elements
  simpleElementsExample();

  // Example 2: Form Example
  formExample();

  // Example 3: Table Example
  tableExample();

  // Example 4: List Example
  listExample();

  // Example 5: Complete Document
  completeDocumentExample();
}

void simpleElementsExample() {
  writeln("--- Simple Elements ---");

  // Basic div with text
  auto div = H5Div("Hello World");
  writeln(div);

  // Div with attributes
  auto styledDiv = H5Div("Styled content")
    .id("main")
    .addClass("container")
    .addClass("responsive")
    .style("color: blue; padding: 10px;");
  writeln(styledDiv);

  // Nested elements
  auto nested = H5Div()
    .id("wrapper")
    .addChild(H5H1("Welcome"))
    .addChild(H5P("This is a paragraph"))
    .addChild(H5Span("with a span inside"));
  writeln(nested);

  // Links and images
  auto link = H5A("https://dlang.org", "D Programming Language").targetBlank();
  writeln(link);

  auto img = H5Img("logo.png", "Logo").width("100").height("50");
  writeln(img);

  writeln();
}

void formExample() {
  writeln("--- Form Example ---");

  auto form = H5Form()
    .action("/login")
    .post()
    .addChild(
      H5Div().addClass("form-group")
        .addChild(H5Label("username", "Username:"))
        .addChild(
          H5TextInput("username")
          .placeholder("Enter username")
          .required()
        )
    )
    .addChild(
      H5Div().addClass("form-group")
        .addChild(H5Label("password", "Password:"))
        .addChild(
          H5PasswordInput("password")
          .placeholder("Enter password")
          .required()
        )
    )
    .addChild(
      H5Div().addClass("form-group")
        .addChild(
          H5InputCheckbox("remember")
          .id("remember")
        )
        .addChild(H5Label("remember", "Remember me"))
    )
    .addChild(
      H5Div().addClass("form-actions")
        .addChild(H5ButtonSubmit("Login"))
        .addChild(H5Button("Cancel").type("button"))
    );

  writeln(form);
  writeln();
}

void tableExample() {
  writeln("--- Table Example ---");

  auto table = H5Table()
    .addClass("data-table")
    .attribute("border", "1");

  // Header
  auto thead = H5Thead();
  auto headerRow = H5Tr()
    .addChild(H5Th("ID"))
    .addChild(H5Th("Name"))
    .addChild(H5Th("Email"))
    .addChild(H5Th("Status"));
  thead.addChild(headerRow);

  // Body
  auto tbody = H5Tbody();

  auto row1 = H5Tr()
    .addChild(H5Td("1"))
    .addChild(H5Td("John Doe"))
    .addChild(H5Td("john@example.com"))
    .addChild(H5Td("Active"));

  auto row2 = H5Tr()
    .addChild(H5Td("2"))
    .addChild(H5Td("Jane Smith"))
    .addChild(H5Td("jane@example.com"))
    .addChild(H5Td("Active"));

  auto row3 = H5Tr()
    .addChild(H5Td("3"))
    .addChild(H5Td("Bob Johnson"))
    .addChild(H5Td("bob@example.com"))
    .addChild(H5Td("Inactive"));

  tbody.addChild(row1).addChild(row2).addChild(row3);

  // Footer
  auto tfoot = H5Tfoot();
  auto footerRow = H5Tr()
    .addChild(H5Td("Total:").colspan("3"))
    .addChild(H5Td("3 users"));
  tfoot.addChild(footerRow);

  // Assemble table
  table.addChild(thead).addChild(tbody).addChild(tfoot);

  writeln(table);
  writeln();
}

void listExample() {
  writeln("--- List Example ---");

  // Unordered list
  auto ul = Ul()
    .addClass("features")
    .addChild(H5Li("Easy to use"))
    .addChild(H5Li("Type safe"))
    .addChild(H5Li("Flexible"));
  writeln("Unordered list:");
  writeln(ul);

  // Ordered list
  auto ol = H5Ol()
    .addClass("steps")
    .addChild(H5Li("Import the library"))
    .addChild(H5Li("Create elements"))
    .addChild(H5Li("Generate HTML"));
  writeln("\nOrdered list:");
  writeln(ol);

  // Definition list
  auto dl = H5Dl()
    .addClass("glossary")
    .addChild(H5Dt("HTML"))
    .addChild(H5Dd("HyperText Markup Language"))
    .addChild(H5Dt("CSS"))
    .addChild(H5Dd("Cascading Style Sheets"))
    .addChild(H5Dt("JavaScript"))
    .addChild(H5Dd("Programming language for web interactivity"));
  writeln("\nDefinition list:");
  writeln(dl);

  writeln();
}

void completeDocumentExample() {
  writeln("--- Complete HTML Document ---");

  auto doc = HtmlDocument()
    .title("UIM HTML Example")
    .lang("en");

  // Add meta tags
  doc.addMeta("description", "Example page using UIM HTML library")
    .addMeta("keywords", "html, d, programming, uim")
    .addMeta("author", "UIM");

  // Add stylesheets
  doc.addStylesheet("https://cdn.example.com/bootstrap.css");
  doc.addInlineStyle(`
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
    `);

  // Build page content
  doc.body()
    .addChild(
      H5Div().addClass("container")
        .addChild(H5H1("Welcome to UIM HTML Library"))
        .addChild(H5P("This is a complete HTML document example."))
        .addChild(
          H5Div().addClass("section")
          .addChild(H5H2("Features"))
          .addChild(
          H5Ul()
          .addChild(H5Li("Object-oriented API"))
          .addChild(H5Li("Type-safe HTML generation"))
          .addChild(H5Li("Chainable method calls"))
          .addChild(H5Li("Full HTML5 support"))
          )
        )
        .addChild(
          H5Div().addClass("section")
          .addChild(H5H2("Get Started"))
          .addChild(H5P("Check out the examples to learn more."))
          .addChild(
          H5A("https://github.com/UIManufaktur/uim-html", "View on GitHub")
          .targetBlank()
          .addClass("btn")
          )
        )
    );

  // Add scripts
  doc.addScript("https://cdn.example.com/jquery.js");
  doc.addInlineScript(`
        console.log('UIM HTML Library loaded');
        document.adUIMEventListener('DOMContentLoaded', function() {
            console.log('Page ready');
        });
    `);

  writeln(doc);
  writeln();
}
