/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module oop.tests.patterns.factories;

import uim.oop;
import std.stdio;

@safe:

// Test basic factory interface
unittest {
  interface IProduct {
    string getName();
  }

  class ConcreteProduct : IProduct {
    string getName() {
      return "ConcreteProduct";
    }
  }

  class ProductFactory : Factory!IProduct {
    this(T delegate() @safe creator) {
      super(creator);
    }

    override IProduct create() {
      return new ConcreteProduct();
    }
  }

  auto factory = new ProductFactory();
  auto product = factory.create();
  assert(product !is null, "Factory should create instance");
  assert(product.getName() == "ConcreteProduct", "Created instance should be correct type");
}

// Test factory with parameters
unittest {
  class ParameterizedProduct {
    private string _name;
    private int _id;

    this(string name, int id) {
      _name = name;
      _id = id;
    }

    string name() {
      return _name;
    }

    int id() {
      return _id;
    }
  }

  auto product = new ParameterizedProduct("Test", 42);
  assert(product.name == "Test", "Product should store name");
  assert(product.id == 42, "Product should store id");
}

// Test factory registry
unittest {
  interface IService {
  }

  class ServiceA : IService {
  }

  class ServiceB : IService {
  }

  // Test that we can create different services
  auto serviceA = new ServiceA();
  auto serviceB = new ServiceB();

  assert(serviceA !is null, "ServiceA should be created");
  assert(serviceB !is null, "ServiceB should be created");
  assert(classname(serviceA) == "ServiceA", "ServiceA type should be correct");
  assert(classname(serviceB) == "ServiceB", "ServiceB type should be correct");
}

// Test singleton factory pattern
unittest {
  class Singleton {
    private static Singleton _instance;

    private this() {
    }

    static Singleton instance() {
      if (_instance is null) {
        _instance = new Singleton();
      }
      return _instance;
    }
  }

  auto s1 = Singleton.instance();
  auto s2 = Singleton.instance();

  assert(s1 is s2, "Singleton instances should be the same");
}

// Test factory builder pattern
unittest {
  class Product {
    private string _name;
    private int _value;

    this() {
    }

    Product setName(string name) {
      _name = name;
      return this;
    }

    Product setValue(int value) {
      _value = value;
      return this;
    }

    string name() {
      return _name;
    }

    int value() {
      return _value;
    }
  }

  auto product = new Product()
    .setName("TestProduct")
    .setValue(100);

  assert(product.name == "TestProduct", "Builder should set name");
  assert(product.value == 100, "Builder should set value");
}
