/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module oop.examples.decorator;

import uim.oop;
import std.stdio;

/**
 * Example demonstrating the Decorator pattern.
 * 
 * The Decorator pattern allows behavior to be added to individual objects,
 * either statically or dynamically, without affecting the behavior of other
 * objects from the same class.
 */

void main() @safe {
  writeln("\n=== Decorator Pattern Examples ===\n");
  
  // Example 1: Text Formatting
  textFormattingExample();
  
  // Example 2: Coffee Shop
  coffeeShopExample();
  
  // Example 3: Logging Decorator
  loggingDecoratorExample();
}

void textFormattingExample() @safe {
  writeln("1. Text Formatting Example:");
  writeln("---------------------------");
  
  class PlainText : IComponent {
    private string _text;
    
    this(string text) { _text = text; }
    
    string execute() {
      return _text;
    }
  }
  
  class BoldDecorator : Decorator {
    this(IComponent component) {
      super(component);
    }
    
    override string execute() {
      return "<b>" ~ super.execute() ~ "</b>";
    }
  }
  
  class ItalicDecorator : Decorator {
    this(IComponent component) {
      super(component);
    }
    
    override string execute() {
      return "<i>" ~ super.execute() ~ "</i>";
    }
  }
  
  auto text = new PlainText("Hello World");
  writeln("Plain text: ", text.execute());
  
  auto bold = new BoldDecorator(text);
  writeln("Bold text: ", bold.execute());
  
  auto boldItalic = new ItalicDecorator(bold);
  writeln("Bold + Italic: ", boldItalic.execute());
  
  writeln();
}

void coffeeShopExample() @safe {
  writeln("2. Coffee Shop Example:");
  writeln("-----------------------");
  
  class Coffee : IComponent {
    string execute() {
      return "Coffee";
    }
    
    double cost() {
      return 2.0;
    }
  }
  
  class MilkDecorator : Decorator {
    this(IComponent component) {
      super(component);
    }
    
    override string execute() {
      return super.execute() ~ " + Milk";
    }
    
    double cost() {
      return 0.5;
    }
  }
  
  class SugarDecorator : Decorator {
    this(IComponent component) {
      super(component);
    }
    
    override string execute() {
      return super.execute() ~ " + Sugar";
    }
    
    double cost() {
      return 0.2;
    }
  }
  
  auto coffee = new Coffee();
  writeln("Order: ", coffee.execute());
  writeln("Cost: $", coffee.cost());
  writeln();
  
  auto coffeeWithMilk = new MilkDecorator(coffee);
  writeln("Order: ", coffeeWithMilk.execute());
  writeln("Cost: $", coffee.cost() + coffeeWithMilk.cost());
  writeln();
  
  auto coffeeWithMilkAndSugar = new SugarDecorator(coffeeWithMilk);
  writeln("Order: ", coffeeWithMilkAndSugar.execute());
  writeln("Cost: $", coffee.cost() + coffeeWithMilk.cost() + coffeeWithMilkAndSugar.cost());
  writeln();
}

void loggingDecoratorExample() @safe {
  writeln("3. Logging Decorator Example:");
  writeln("-----------------------------");
  
  class DataProcessor : IComponent {
    string execute() {
      return "Processing data";
    }
  }
  
  auto processor = new DataProcessor();
  
  auto withLogging = createFunctionalDecorator(
    processor,
    () {
      writeln("[LOG] Starting process...");
      return "";
    },
    () {
      writeln("[LOG] Process completed!");
      return "";
    }
  );
  
  writeln("Result: ", withLogging.execute());
  writeln();
}
