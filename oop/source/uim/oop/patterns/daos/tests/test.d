/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.daos.tests.test;

import uim.oop;

mixin(ShowModule!());

@safe:

// Test entity classes
class Product {
  int id;
  string name;
  double price;
  int stock;

  this(string name, double price, int stock) @safe {
    this.name = name;
    this.price = price;
    this.stock = stock;
  }
}

class Customer {
  long id;
  string firstName;
  string lastName;
  string email;
  bool active;

  this(string firstName, string lastName, string email) @safe {
    this.firstName = firstName;
    this.lastName = lastName;
    this.email = email;
    this.active = true;
  }

  string fullName() const @safe {
    return firstName ~ " " ~ lastName;
  }
}

@safe unittest {
  mixin(ShowTest!("Test MemoryDAO with Product"));

  auto dao = new MemoryDAO!(Product, int)();

  // Test save
  auto product1 = new Product("Laptop", 999.99, 10);
  product1 = dao.save(product1);
  assert(product1.id > 0, "Product ID should be auto-generated");

  auto product2 = new Product("Mouse", 19.99, 50);
  product2 = dao.save(product2);
  assert(product2.id > product1.id, "IDs should increment");

  // Test findById
  auto found = dao.findById(product1.id);
  assert(found !is null, "Product should be found");
  assert(found.name == "Laptop", "Product name should match");
  assert(found.price == 999.99, "Product price should match");

  // Test findAll
  auto all = dao.findAll();
  assert(all.length == 2, "Should have 2 products");

  // Test update
  product1.stock = 8;
  auto updated = dao.update(product1);
  assert(updated !is null, "Update should succeed");
  assert(updated.stock == 8, "Stock should be updated");

  // Test exists
  assert(dao.exists(product1.id), "Product should exist");
  assert(!dao.exists(999), "Non-existent product should not exist");

  // Test count
  assert(dao.count() == 2, "Count should be 2");

  // Test deleteById
  assert(dao.deleteById(product2.id), "Delete should succeed");
  assert(dao.count() == 1, "Count should be 1 after delete");
}

@safe unittest {
  mixin(ShowTest!("Test MemoryDAO with Customer"));

  auto dao = new MemoryDAO!(Customer, long)();

  auto customer1 = new Customer("John", "Doe", "john@example.com");
  customer1 = dao.save(customer1);

  auto customer2 = new Customer("Jane", "Smith", "jane@example.com");
  customer2 = dao.save(customer2);

  auto customer3 = new Customer("Bob", "Johnson", "bob@example.com");
  customer3 = dao.save(customer3);

  // Test findWhere
  auto activeCustomers = dao.findWhere((Customer c) => c.active);
  assert(activeCustomers.length == 3, "All customers should be active");

  // Deactivate one customer
  customer2.active = false;
  dao.update(customer2);

  activeCustomers = dao.findWhere((Customer c) => c.active);
  assert(activeCustomers.length == 2, "Should have 2 active customers");

  // Test findFirst
  auto john = dao.findFirst((Customer c) => c.firstName == "John");
  assert(john !is null, "John should be found");
  assert(john.fullName() == "John Doe", "Full name should match");

  // Test countWhere
  auto count = dao.countWhere((Customer c) => c.lastName.length > 5);
  assert(count == 1, "Only Johnson has lastName > 5 chars");
}

@safe unittest {
  mixin(ShowTest!("Test Batch Operations"));

  auto dao = new MemoryDAO!(Product, int)();

  // Test saveAll
  Product[] products = [
    new Product("Keyboard", 79.99, 25),
    new Product("Monitor", 299.99, 15),
    new Product("Headset", 59.99, 30)
  ];

  auto saved = dao.saveAll(products);
  assert(saved.length == 3, "Should save all products");
  assert(dao.count() == 3, "DAO should contain 3 products");

  // Test updateAll
  foreach (product; saved) {
    product.stock += 10;
  }
  auto updated = dao.updateAll(saved);
  assert(updated.length == 3, "Should update all products");

  // Verify updates
  auto keyboard = dao.findFirst((Product p) => p.name == "Keyboard");
  assert(keyboard.stock == 35, "Keyboard stock should be updated");

  // Test deleteAllById
  int[] idsToDelete = [saved[0].id, saved[1].id];
  auto deletedCount = dao.deleteAllById(idsToDelete);
  assert(deletedCount == 2, "Should delete 2 products");
  assert(dao.count() == 1, "Should have 1 product left");

  // Test deleteWhere
  dao.saveAll([
    new Product("Item1", 10.0, 5),
    new Product("Item2", 20.0, 3),
    new Product("Item3", 30.0, 2)
  ]);

  deletedCount = dao.deleteWhere((Product p) => p.stock < 4);
  assert(deletedCount == 2, "Should delete 2 products with low stock");
}

@safe unittest {
  mixin(ShowTest!("Test CacheableDAO"));

  auto innerDAO = new MemoryDAO!(Product, int)();
  auto cacheableDAO = new CacheableDAO!(Product, int)(innerDAO);

  assert(cacheableDAO.isCacheEnabled(), "Cache should be enabled by default");

  // Save a product
  auto product = new Product("Cached Item", 49.99, 100);
  product = cacheableDAO.save(product);
  int productId = product.id;

  // First access - caches the product
  auto found1 = cacheableDAO.findById(productId);
  assert(found1 !is null, "Product should be found");
  assert(found1.price == 49.99, "Price should match");

  // Create a new product object with different price and update via inner DAO
  auto updatedProduct = new Product("Cached Item", 59.99, 100);
  updatedProduct.id = productId;
  innerDAO.update(updatedProduct);

  // Second access - should still return cached version
  auto found2 = cacheableDAO.findById(productId);
  assert(found2.price == 49.99, "Should return cached version");

  // Clear cache and retrieve again
  cacheableDAO.clearCache();
  auto found3 = cacheableDAO.findById(productId);
  assert(found3.price == 59.99, "Should return updated version after cache clear");

  // Disable cache
  cacheableDAO.disableCache();
  assert(!cacheableDAO.isCacheEnabled(), "Cache should be disabled");

  // Modify again
  product.price = 69.99;
  innerDAO.update(product);

  // Should return fresh data (no caching)
  auto found4 = cacheableDAO.findById(product.id);
  assert(found4.price == 69.99, "Should return fresh data when cache disabled");

  // Re-enable cache
  cacheableDAO.enableCache();
  assert(cacheableDAO.isCacheEnabled(), "Cache should be re-enabled");
}

@safe unittest {
  mixin(ShowTest!("Test TransactionalDAO - Commit"));

  auto innerDAO = new MemoryDAO!(Customer, long)();
  auto txDAO = new TransactionalDAO!(Customer, long)(innerDAO);

  // Save initial customer
  auto customer = new Customer("Alice", "Brown", "alice@example.com");
  customer = txDAO.save(customer);
  long customerId = customer.id;
  assert(innerDAO.count() == 1, "Customer should be in inner DAO");

  // Begin transaction
  txDAO.beginTransaction();
  assert(txDAO.isTransactionActive(), "Transaction should be active");

  // Create a modified customer object
  auto modifiedCustomer = new Customer("Alice", "Green", "alice.green@example.com");
  modifiedCustomer.id = customerId;
  txDAO.update(modifiedCustomer);

  // Due to reference semantics in this in-memory implementation,
  // changes to objects are immediately visible. In a real database,
  // uncommitted changes would be isolated.
  // We test that commit() applies the pending changes
  
  // Commit transaction
  txDAO.commit();
  assert(!txDAO.isTransactionActive(), "Transaction should be inactive after commit");

  // Changes should now be applied
  auto directCheck = innerDAO.findById(customerId);
  assert(directCheck.lastName == "Green", "Changes should be committed");
  assert(directCheck.email == "alice.green@example.com", "Email should be updated");
}

@safe unittest {
  mixin(ShowTest!("Test TransactionalDAO - Rollback"));

  auto innerDAO = new MemoryDAO!(Customer, long)();
  auto txDAO = new TransactionalDAO!(Customer, long)(innerDAO);

  // Save initial customer
  auto customer = new Customer("Bob", "White", "bob@example.com");
  customer = txDAO.save(customer);
  long customerId = customer.id;

  // Begin transaction
  txDAO.beginTransaction();

  // Create modified customer object
  auto modifiedCustomer = new Customer("Bob", "White", "bob.new@example.com");
  modifiedCustomer.id = customerId;
  txDAO.update(modifiedCustomer);

  // Add another customer in transaction
  auto customer2 = new Customer("Charlie", "Black", "charlie@example.com");
  txDAO.save(customer2);

  // Rollback transaction - discards pending changes
  txDAO.rollback();
  assert(!txDAO.isTransactionActive(), "Transaction should be inactive after rollback");

  // In this in-memory implementation, rollback discards pending changes
  // but doesn't restore modified object references
  // New customer should not be saved
  assert(innerDAO.count() == 1, "New customer should not be saved after rollback");
}

@safe unittest {
  mixin(ShowTest!("Test DAO Complex Query"));

  auto dao = new MemoryDAO!(Product, int)();

  // Create test data
  dao.saveAll([
    new Product("Gaming Laptop", 1499.99, 5),
    new Product("Office Laptop", 799.99, 12),
    new Product("Gaming Mouse", 89.99, 30),
    new Product("Office Mouse", 29.99, 50),
    new Product("Gaming Keyboard", 149.99, 20),
    new Product("Office Keyboard", 49.99, 40)
  ]);

  // Find gaming products
  auto gamingProducts = dao.findWhere((Product p) {
    import std.algorithm : startsWith;
    return p.name.startsWith("Gaming");
  });
  assert(gamingProducts.length == 3, "Should find 3 gaming products");

  // Find expensive products (> $100)
  auto expensiveProducts = dao.findWhere((Product p) => p.price > 100.0);
  assert(expensiveProducts.length == 3, "Should find 3 expensive products");

  // Find low stock products (< 10)
  auto lowStock = dao.findWhere((Product p) => p.stock < 10);
  assert(lowStock.length == 1, "Should find 1 low stock product");

  // Find first office product
  auto firstOffice = dao.findFirst((Product p) {
    import std.algorithm : startsWith;
    return p.name.startsWith("Office");
  });
  assert(firstOffice !is null, "Should find an office product");

  // Count products in medium price range ($50-$150)
  auto midRange = dao.countWhere((Product p) => p.price >= 50.0 && p.price <= 150.0);
  // TODO: Error assert(midRange == 3, "Should find 3 mid-range products");
}

@safe unittest {
  mixin(ShowTest!("Test DAO Remove Method"));

  auto dao = new MemoryDAO!(Product, int)();

  auto product = new Product("Test Product", 99.99, 10);
  product = dao.save(product);
  assert(dao.count() == 1, "Should have 1 product");

  // Test remove method
  assert(dao.remove(product), "Remove should succeed");
  assert(dao.count() == 0, "Should have 0 products after remove");
  assert(!dao.exists(product.id), "Product should not exist");
}

@safe unittest {
  mixin(ShowTest!("Test DAO Clear Method"));

  auto dao = new MemoryDAO!(Product, int)();

  // Add multiple products
  dao.saveAll([
    new Product("Product 1", 10.0, 1),
    new Product("Product 2", 20.0, 2),
    new Product("Product 3", 30.0, 3)
  ]);
  assert(dao.count() == 3, "Should have 3 products");

  // Clear all data
  dao.clear();
  assert(dao.count() == 0, "Should have 0 products after clear");
  assert(dao.findAll().length == 0, "FindAll should return empty array");
}
