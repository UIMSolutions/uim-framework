/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module oop.examples.strategy;

import uim.oop;
import std.stdio;

/**
 * Example demonstrating the Strategy pattern.
 * 
 * The Strategy pattern defines a family of algorithms, encapsulates each one,
 * and makes them interchangeable. Strategy lets the algorithm vary independently
 * from clients that use it.
 */

void main() @safe {
  writeln("\n=== Strategy Pattern Examples ===\n");
  
  // Example 1: Sorting Strategies
  sortingExample();
  
  // Example 2: Payment Processing
  paymentExample();
  
  // Example 3: Text Formatting
  textFormattingExample();
  
  // Example 4: Data Validation
  validationExample();
}

void sortingExample() @safe {
  writeln("1. Sorting Strategy Example:");
  writeln("----------------------------");
  
  auto data = [5, 2, 8, 1, 9, 3, 7, 4, 6];
  writeln("Original data: ", data);
  
  // Use bubble sort
  auto sorter = new Sorter!int(new BubbleSortStrategy!int());
  auto sorted = sorter.sort(data);
  writeln("Bubble sorted: ", sorted);
  
  // Switch to quick sort
  sorter.strategy(new QuickSortStrategy!int());
  sorted = sorter.sort(data);
  writeln("Quick sorted:  ", sorted);
  
  writeln();
}

void paymentExample() @safe {
  writeln("2. Payment Strategy Example:");
  writeln("----------------------------");
  
  class CreditCardStrategy : IPaymentStrategy {
    private string _cardNumber;
    
    this(string cardNumber) {
      _cardNumber = cardNumber;
    }
    
    bool pay(double amount) {
      import std.format : format;
      writeln(format("Paid $%.2f using Credit Card ****%s", 
                     amount, _cardNumber[$-4..$]));
      return true;
    }
    
    string paymentMethod() {
      return "Credit Card";
    }
  }
  
  class PayPalStrategy : IPaymentStrategy {
    private string _email;
    
    this(string email) {
      _email = email;
    }
    
    bool pay(double amount) {
      import std.format : format;
      writeln(format("Paid $%.2f using PayPal account %s", amount, _email));
      return true;
    }
    
    string paymentMethod() {
      return "PayPal";
    }
  }
  
  class CryptoStrategy : IPaymentStrategy {
    private string _wallet;
    
    this(string wallet) {
      _wallet = wallet;
    }
    
    bool pay(double amount) {
      import std.format : format;
      writeln(format("Paid $%.2f using Crypto wallet %s...", 
                     amount, _wallet[0..8]));
      return true;
    }
    
    string paymentMethod() {
      return "Cryptocurrency";
    }
  }
  
  class ShoppingCart {
    private IPaymentStrategy _paymentStrategy;
    private double _total;
    
    this(double total) {
      _total = total;
    }
    
    void setPaymentStrategy(IPaymentStrategy strategy) {
      _paymentStrategy = strategy;
    }
    
    void checkout() {
      writeln("Processing payment...");
      _paymentStrategy.pay(_total);
    }
  }
  
  auto cart = new ShoppingCart(99.99);
  
  writeln("Paying with credit card:");
  cart.setPaymentStrategy(new CreditCardStrategy("1234567890123456"));
  cart.checkout();
  
  writeln("\nPaying with PayPal:");
  cart.setPaymentStrategy(new PayPalStrategy("user@example.com"));
  cart.checkout();
  
  writeln("\nPaying with crypto:");
  cart.setPaymentStrategy(new CryptoStrategy("1A2B3C4D5E6F7G8H9I0J"));
  cart.checkout();
  
  writeln();
}

void textFormattingExample() @safe {
  writeln("3. Text Formatting Strategy Example:");
  writeln("------------------------------------");
  
  auto uppercase = createGenericStrategy!string((string text) {
    import std.string : toUpper;
    return text.toUpper();
  });
  
  auto lowercase = createGenericStrategy!string((string text) {
    import std.string : toLower;
    return text.toLower();
  });
  
  auto titleCase = createGenericStrategy!string((string text) {
    import std.string : split, capitalize;
    import std.array : join;
    import std.algorithm : map;
    return text.split(" ").map!capitalize.join(" ");
  });
  
  string text = "hello world from D language";
  writeln("Original: ", text);
  writeln("Uppercase: ", uppercase.execute(text));
  writeln("Lowercase: ", lowercase.execute(text));
  writeln("Title Case: ", titleCase.execute(text));
  
  writeln();
}

void validationExample() @safe {
  writeln("4. Validation Strategy Example:");
  writeln("--------------------------------");
  
  // Password validation
  auto passwordValidator = new Validator!string(
    new LengthValidationStrategy(8, 20)
  );
  
  string[] passwords = ["short", "goodpassword123", "this_password_is_way_too_long_to_be_valid"];
  
  writeln("Password validation (8-20 characters):");
  foreach (password; passwords) {
    if (passwordValidator.validate(password)) {
      writeln("  ✓ '", password, "' is valid");
    } else {
      writeln("  ✗ '", password, "' is invalid: ", passwordValidator.errorMessage());
    }
  }
  
  // Age validation
  auto ageValidator = new Validator!int(
    new RangeValidationStrategy!int(18, 120)
  );
  
  int[] ages = [15, 25, 65, 150];
  
  writeln("\nAge validation (18-120):");
  foreach (age; ages) {
    if (ageValidator.validate(age)) {
      import std.conv : to;
      writeln("  ✓ Age ", age, " is valid");
    } else {
      import std.conv : to;
      writeln("  ✗ Age ", age, " is invalid: ", ageValidator.errorMessage());
    }
  }
  
  writeln();
}
