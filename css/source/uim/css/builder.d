/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.css.builder;

import std.string;
import std.array;
import std.algorithm;
import std.conv;
import uim.css.types;

@safe:

/**
 * Fluent builder for CSS stylesheets
 */
class CSSBuilder {
    private CSSStyleSheet sheet;
    private CSSRule currentRule;
    private CSSMediaQuery currentMediaQuery;
    
    this() pure nothrow {
        sheet = new CSSStyleSheet();
    }
    
    /**
     * Starts a new rule with the given selector
     */
    CSSBuilder rule(string selector) return {
        currentRule = new CSSRule(selector);
        currentMediaQuery = null;
        return this;
    }
    
    /**
     * Adds another selector to the current rule
     */
    CSSBuilder addSelector(string selector) return {
        if (currentRule is null) {
            currentRule = new CSSRule();
        }
        currentRule.addSelector(selector);
        return this;
    }
    
    /**
     * Adds a property to the current rule
     */
    CSSBuilder property(string name, string value, bool important = false) return {
        if (currentRule is null) {
            currentRule = new CSSRule();
        }
        currentRule.addProperty(name, value, important);
        return this;
    }
    
    /**
     * Convenience methods for common CSS properties
     */
    CSSBuilder color(string value) return {
        return property("color", value);
    }
    
    CSSBuilder backgroundColor(string value) return {
        return property("background-color", value);
    }
    
    CSSBuilder fontSize(string value) return {
        return property("font-size", value);
    }
    
    CSSBuilder fontWeight(string value) return {
        return property("font-weight", value);
    }
    
    CSSBuilder margin(string value) return {
        return property("margin", value);
    }
    
    CSSBuilder padding(string value) return {
        return property("padding", value);
    }
    
    CSSBuilder width(string value) return {
        return property("width", value);
    }
    
    CSSBuilder height(string value) return {
        return property("height", value);
    }
    
    CSSBuilder display(string value) return {
        return property("display", value);
    }
    
    CSSBuilder position(string value) return {
        return property("position", value);
    }
    
    CSSBuilder border(string value) return {
        return property("border", value);
    }
    
    CSSBuilder borderRadius(string value) return {
        return property("border-radius", value);
    }
    
    CSSBuilder textAlign(string value) return {
        return property("text-align", value);
    }
    
    CSSBuilder flexDirection(string value) return {
        return property("flex-direction", value);
    }
    
    CSSBuilder justifyContent(string value) return {
        return property("justify-content", value);
    }
    
    CSSBuilder alignItems(string value) return {
        return property("align-items", value);
    }
    
    /**
     * Finishes the current rule and adds it to the stylesheet
     */
    CSSBuilder endRule() return {
        if (currentRule !is null) {
            if (currentMediaQuery !is null) {
                currentMediaQuery.addRule(currentRule);
            } else {
                sheet.addRule(currentRule);
            }
            currentRule = null;
        }
        return this;
    }
    
    /**
     * Starts a media query
     */
    CSSBuilder media(string mediaType, string[] conditions = null) return {
        endRule(); // End any current rule
        currentMediaQuery = new CSSMediaQuery(mediaType, conditions);
        return this;
    }
    
    /**
     * Ends the current media query
     */
    CSSBuilder endMedia() return {
        endRule(); // End any current rule
        if (currentMediaQuery !is null) {
            sheet.addMediaQuery(currentMediaQuery);
            currentMediaQuery = null;
        }
        return this;
    }
    
    /**
     * Sets a CSS variable
     */
    CSSBuilder variable(string name, string value) return {
        sheet.setVariable(name, value);
        return this;
    }
    
    /**
     * Returns the built stylesheet
     */
    CSSStyleSheet build() return {
        endRule(); // Ensure current rule is added
        endMedia(); // Ensure current media query is added
        return sheet;
    }
    
    /**
     * Returns the CSS string
     */
    override string toString() {
        return build().toString();
    }
}

/**
 * Creates a new CSS builder
 */
CSSBuilder css() {
    return new CSSBuilder();
}

// Convenience functions for creating stylesheets

/**
 * Creates a simple rule
 */
CSSRule createRule(string selector) {
    return new CSSRule(selector);
}

/**
 * Creates a stylesheet with a single rule
 */
CSSStyleSheet createSimpleStylesheet(string selector, CSSProperty[] properties...) {
    auto sheet = new CSSStyleSheet();
    auto rule = new CSSRule(selector);
    foreach (prop; properties) {
        rule.addProperty(prop.name, prop.value, prop.important);
    }
    sheet.addRule(rule);
    return sheet;
}
