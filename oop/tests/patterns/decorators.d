/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module oop.tests.patterns.decorators;

import uim.oop;
import std.stdio;

@safe:

// Test basic decorator pattern
unittest {
  class TextComponent : IComponent {
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

  auto text = new TextComponent("Hello");
  assert(text.execute() == "Hello", "Base component should return text");

  auto bold = new BoldDecorator(text);
  assert(bold.execute() == "<b>Hello</b>", "Decorator should wrap text");
}

// Test multiple decorators
unittest {
  class MessageComponent : IComponent {
    string execute() {
      return "Message";
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

  class UnderlineDecorator : Decorator {
    this(IComponent component) {
      super(component);
    }
    
    override string execute() {
      return "<u>" ~ super.execute() ~ "</u>";
    }
  }

  auto message = new MessageComponent();
  auto italic = new ItalicDecorator(message);
  auto underlined = new UnderlineDecorator(italic);
  
  assert(message.execute() == "Message", "Base should be unchanged");
  assert(italic.execute() == "<i>Message</i>", "First decorator should work");
  assert(underlined.execute() == "<u><i>Message</i></u>", "Decorators should stack");
}

// Test decorator with parameters
unittest {
  class PriceComponent : IComponent {
    private double _price;
    
    this(double price) { _price = price; }
    
    string execute() {
      import std.conv : to;
      import std.format : format;
      return format("%.2f", _price);
    }
  }

  class CurrencyDecorator : Decorator {
    private string _currency;
    
    this(IComponent component, string currency) {
      super(component);
      _currency = currency;
    }
    
    override string execute() {
      return _currency ~ super.execute();
    }
  }

  class TaxDecorator : Decorator {
    private double _taxRate;
    
    this(IComponent component, double taxRate) {
      super(component);
      _taxRate = taxRate;
    }
    
    override string execute() {
      import std.conv : to;
      import std.format : format;
      auto basePrice = super.execute();
      auto price = basePrice.to!double;
      auto withTax = price * (1 + _taxRate);
      return format("%.2f", withTax);
    }
  }

  auto price = new PriceComponent(100.0);
  auto withTax = new TaxDecorator(price, 0.20); // 20% tax
  auto withCurrency = new CurrencyDecorator(withTax, "$");
  
  assert(withCurrency.execute() == "$120.00", "Should apply tax and currency");
}

// Test functional decorator
unittest {
  class CounterComponent : IComponent {
    private int _count;
    
    this(int count) { _count = count; }
    
    string execute() {
      import std.conv : to;
      return _count.to!string;
    }
  }

  auto counter = new CounterComponent(5);
  
  auto decorated = createFunctionalDecorator(
    counter,
    () => "Count: ",
    () => " items"
  );

  assert(decorated.execute() == "Count: 5 items", "Functional decorator should work");
}

// Test generic decorator
unittest {
  class Product {
    string name;
    double price;
    
    this(string n, double p) {
      name = n;
      price = p;
    }
  }

  auto product = new Product("Laptop", 999.99);
  
  auto decorator = createGenericDecorator(product, (Product p) {
    import std.format : format;
    return format("%s: $%.2f", p.name, p.price);
  });

  assert(decorator.execute() == "Laptop: $999.99", "Generic decorator should work");
  assert(decorator.wrappedObject().name == "Laptop", "Should access wrapped object");
}

// Test chainable decorator
unittest {
  class BaseComponent : IComponent {
    string execute() {
      return "Base";
    }
  }

  class PrefixDecorator : Decorator {
    private string _prefix;
    
    this(IComponent component, string prefix) {
      super(component);
      _prefix = prefix;
    }
    
    override string execute() {
      return _prefix ~ super.execute();
    }
  }

  class SuffixDecorator : Decorator {
    private string _suffix;
    
    this(IComponent component, string suffix) {
      super(component);
      _suffix = suffix;
    }
    
    override string execute() {
      return super.execute() ~ _suffix;
    }
  }

  auto base = new BaseComponent();
  auto chain = new ChainableDecorator(base);
  
  chain.addDecorator(new PrefixDecorator(base, "Start-"));
  chain.addDecorator(new SuffixDecorator(base, "-End"));
  
  assert(chain.chainLength() == 2, "Should have two decorators in chain");
}

// Test decorator replacement
unittest {
  class DataComponent : IComponent {
    private string _data;
    
    this(string data) { _data = data; }
    
    string execute() {
      return _data;
    }
  }

  class WrapperDecorator : Decorator {
    this(IComponent component) {
      super(component);
    }
    
    override string execute() {
      return "(" ~ super.execute() ~ ")";
    }
  }

  auto data1 = new DataComponent("First");
  auto data2 = new DataComponent("Second");
  
  auto decorator = new WrapperDecorator(data1);
  assert(decorator.execute() == "(First)", "Should wrap first data");
  
  decorator.component(data2);
  assert(decorator.execute() == "(Second)", "Should wrap second data after replacement");
}

// Test null component handling
unittest {
  class SafeDecorator : Decorator {
    this(IComponent component) {
      super(component);
    }
    
    override string execute() {
      if (_component is null) {
        return "No component";
      }
      return super.execute();
    }
  }

  class TestComponent : IComponent {
    string execute() {
      return "Test";
    }
  }

  auto decorator = new SafeDecorator(null);
  assert(decorator.execute() == "No component", "Should handle null component");
  
  decorator.component(new TestComponent());
  assert(decorator.execute() == "Test", "Should work with valid component");
}
