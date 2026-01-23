module css.examples.example;

/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
import std.stdio;
import uim.css;

void main() {
    writeln("=== CSS Library Example ===\n");
    
    // Example 1: Building CSS using the fluent builder
    writeln("1. Building CSS with fluent API:");
    auto builder = css()
        .rule("body")
            .margin("0")
            .padding("0")
            .property("font-family", "Segoe UI, sans-serif")
            .fontSize("16px")
            .color("#333")
        .endRule()
        .rule(".container")
            .width("1200px")
            .margin("0 auto")
            .padding("20px")
        .endRule()
        .rule(".button")
            .addSelector(".btn")
            .display("inline-block")
            .padding("10px 20px")
            .backgroundColor("#007bff")
            .color("#fff")
            .border("none")
            .borderRadius("4px")
            .property("cursor", "pointer")
        .endRule()
        .rule(".button:hover")
            .backgroundColor("#0056b3")
        .endRule()
        .media("screen", ["max-width: 768px"])
            .rule(".container")
                .width("100%")
                .padding("10px")
            .endRule()
        .endMedia();
    
    writeln(builder.toString());
    writeln();
    
    // Example 2: Parsing existing CSS
    writeln("2. Parsing existing CSS:");
    string cssCode = `
        /* Main styles */
        h1, h2 {
            color: #2c3e50;
            font-family: Arial, sans-serif;
        }
        
        .card {
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 15px;
            margin: 10px;
            background-color: white;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .card-title {
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 10px;
        }
        
        @media (max-width: 600px) {
            .card {
                padding: 10px;
                margin: 5px;
            }
        }
    `;
    
    auto stylesheet = parseCSS(cssCode);
    writeln("Parsed stylesheet:");
    writeln(stylesheet.toString());
    writeln();
    
    // Example 3: Manipulating parsed CSS
    writeln("3. Manipulating parsed CSS:");
    auto sheet = parseCSS(".box { width: 100px; height: 100px; }");
    
    // Find and modify a rule
    auto rules = sheet.findRules(".box");
    if (rules.length > 0) {
        auto rule = cast(CSSRule)rules[0];
        writeln("Original rule:");
        writeln(rule.toString());
        writeln();
        
        // Add new properties
        rule.setProperty("background-color", "#f0f0f0");
        rule.setProperty("border", "1px solid #ccc");
        
        writeln("Modified rule:");
        writeln(rule.toString());
    }
    writeln();
    
    // Example 4: CSS Variables
    writeln("4. CSS Variables:");
    auto varSheet = css()
        .variable("primary-color", "#007bff")
        .variable("secondary-color", "#6c757d")
        .variable("spacing", "1rem")
        .rule(".theme-element")
            .property("color", "var(--primary-color)")
            .property("margin", "var(--spacing)")
        .endRule();
    
    writeln(varSheet.toString());
    writeln();
    
    // Example 5: Complex responsive design
    writeln("5. Complex responsive design:");
    auto responsive = css()
        .rule(".grid")
            .display("grid")
            .property("grid-template-columns", "repeat(4, 1fr)")
            .property("gap", "20px")
        .endRule()
        .media("screen", ["max-width: 1200px"])
            .rule(".grid")
                .property("grid-template-columns", "repeat(3, 1fr)")
            .endRule()
        .endMedia()
        .media("screen", ["max-width: 768px"])
            .rule(".grid")
                .property("grid-template-columns", "repeat(2, 1fr)")
                .property("gap", "10px")
            .endRule()
        .endMedia()
        .media("screen", ["max-width: 480px"])
            .rule(".grid")
                .property("grid-template-columns", "1fr")
            .endRule()
        .endMedia();
    
    writeln(responsive.toString());
    writeln();
    
    writeln("=== Example Complete ===");
}
