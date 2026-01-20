module example;

/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/

import std.stdio;
import uim.htmls;

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
    auto div = Div("Hello World");
    writeln(div);
    
    // Div with attributes
    auto styledDiv = Div("Styled content")
        .id("main")
        .addClass("container")
        .addClass("responsive")
        .style("color: blue; padding: 10px;");
    writeln(styledDiv);
    
    // Nested elements
    auto nested = Div()
        .id("wrapper")
        .addChild(H1("Welcome"))
        .addChild(P("This is a paragraph"))
        .addChild(Span("with a span inside"));
    writeln(nested);
    
    // Links and images
    auto link = A("https://dlang.org", "D Programming Language").targetBlank();
    writeln(link);
    
    auto img = Img("logo.png", "Logo").width("100").height("50");
    writeln(img);
    
    writeln();
}

void formExample() {
    writeln("--- Form Example ---");
    
    auto form = Form()
        .action("/login")
        .post()
        .addChild(
            Div().addClass("form-group")
                .addChild(Label("username", "Username:"))
                .addChild(
                    InputText("username")
                        .placeholder("Enter username")
                        .required()
                )
        )
        .addChild(
            Div().addClass("form-group")
                .addChild(Label("password", "Password:"))
                .addChild(
                    InputPassword("password")
                        .placeholder("Enter password")
                        .required()
                )
        )
        .addChild(
            Div().addClass("form-group")
                .addChild(
                    InputCheckbox("remember")
                        .id("remember")
                )
                .addChild(Label("remember", "Remember me"))
        )
        .addChild(
            Div().addClass("form-actions")
                .addChild(ButtonSubmit("Login"))
                .addChild(Button("Cancel").type("button"))
        );
    
    writeln(form);
    writeln();
}

void tableExample() {
    writeln("--- Table Example ---");
    
    auto table = Table()
        .addClass("data-table")
        .attribute("border", "1");
    
    // Header
    auto thead = Thead();
    auto headerRow = Tr()
        .addChild(Th("ID"))
        .addChild(Th("Name"))
        .addChild(Th("Email"))
        .addChild(Th("Status"));
    thead.addChild(headerRow);
    
    // Body
    auto tbody = Tbody();
    
    auto row1 = Tr()
        .addChild(Td("1"))
        .addChild(Td("John Doe"))
        .addChild(Td("john@example.com"))
        .addChild(Td("Active"));
    
    auto row2 = Tr()
        .addChild(Td("2"))
        .addChild(Td("Jane Smith"))
        .addChild(Td("jane@example.com"))
        .addChild(Td("Active"));
    
    auto row3 = Tr()
        .addChild(Td("3"))
        .addChild(Td("Bob Johnson"))
        .addChild(Td("bob@example.com"))
        .addChild(Td("Inactive"));
    
    tbody.addChild(row1).addChild(row2).addChild(row3);
    
    // Footer
    auto tfoot = Tfoot();
    auto footerRow = Tr()
        .addChild(Td("Total:").colspan("3"))
        .addChild(Td("3 users"));
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
        .addChild(Li("Easy to use"))
        .addChild(Li("Type safe"))
        .addChild(Li("Flexible"));
    writeln("Unordered list:");
    writeln(ul);
    
    // Ordered list
    auto ol = Ol()
        .addClass("steps")
        .addChild(Li("Import the library"))
        .addChild(Li("Create elements"))
        .addChild(Li("Generate HTML"));
    writeln("\nOrdered list:");
    writeln(ol);
    
    // Definition list
    auto dl = Dl()
        .addClass("glossary")
        .addChild(Dt("HTML"))
        .addChild(Dd("HyperText Markup Language"))
        .addChild(Dt("CSS"))
        .addChild(Dd("Cascading Style Sheets"))
        .addChild(Dt("JavaScript"))
        .addChild(Dd("Programming language for web interactivity"));
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
           Div().addClass("container")
               .addChild(H1("Welcome to UIM HTML Library"))
               .addChild(P("This is a complete HTML document example."))
               .addChild(
                   Div().addClass("section")
                       .addChild(H2("Features"))
                       .addChild(
                           Ul()
                               .addChild(Li("Object-oriented API"))
                               .addChild(Li("Type-safe HTML generation"))
                               .addChild(Li("Chainable method calls"))
                               .addChild(Li("Full HTML5 support"))
                       )
               )
               .addChild(
                   Div().addClass("section")
                       .addChild(H2("Get Started"))
                       .addChild(P("Check out the examples to learn more."))
                       .addChild(
                           A("https://github.com/UIManufaktur/uim-html", "View on GitHub")
                               .targetBlank()
                               .addClass("btn")
                       )
               )
       );
    
    // Add scripts
    doc.addScript("https://cdn.example.com/jquery.js");
    doc.addInlineScript(`
        console.log('UIM HTML Library loaded');
        document.addEventListener('DOMContentLoaded', function() {
            console.log('Page ready');
        });
    `);
    
    writeln(doc);
    writeln();
}
