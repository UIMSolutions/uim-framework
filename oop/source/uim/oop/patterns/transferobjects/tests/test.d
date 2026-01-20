/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.transferobjects.tests.test;

import uim.oop;

mixin(ShowModule!());

@safe:

// Test Domain Objects

class Customer {
  int id;
  string firstName;
  string lastName;
  string email;
  string phone;
  
  this(int id, string firstName, string lastName, string email, string phone) {
    this.id = id;
    this.firstName = firstName;
    this.lastName = lastName;
    this.email = email;
    this.phone = phone;
  }
}

class Order {
  int id;
  int customerId;
  string orderDate;
  double totalAmount;
  
  this(int id, int customerId, string orderDate, double totalAmount) {
    this.id = id;
    this.customerId = customerId;
    this.orderDate = orderDate;
    this.totalAmount = totalAmount;
  }
}

class Product {
  int id;
  string name;
  string description;
  double price;
  int stock;
  
  this(int id, string name, string description, double price, int stock) {
    this.id = id;
    this.name = name;
    this.description = description;
    this.price = price;
    this.stock = stock;
  }
}

// Test Transfer Objects

class CustomerTO : SerializableTransferObject {
  string firstName;
  string lastName;
  string email;
  
  override string[string] toMap() {
    string[string] map;
    map["firstName"] = firstName;
    map["lastName"] = lastName;
    map["email"] = email;
    return map;
  }
  
  override void fromMap(string[string] data) {
    firstName = data.get("firstName", "");
    lastName = data.get("lastName", "");
    email = data.get("email", "");
  }
  
  override bool validate() {
    import std.algorithm : canFind;
    return firstName.length > 0 && 
           lastName.length > 0 && 
           email.length > 0 && 
           email.canFind("@");
  }
}

class OrderTO : TransferObject {
  string customerId;
  string orderDate;
  string totalAmount;
  
  override string[string] toMap() {
    string[string] map;
    map["customerId"] = customerId;
    map["orderDate"] = orderDate;
    map["totalAmount"] = totalAmount;
    return map;
  }
  
  override void fromMap(string[string] data) {
    customerId = data.get("customerId", "");
    orderDate = data.get("orderDate", "");
    totalAmount = data.get("totalAmount", "0");
  }
  
  override bool validate() {
    import std.conv : to;
    try {
      customerId.to!int;
      totalAmount.to!double;
      return true;
    } catch (Exception e) {
      return false;
    }
  }
}

class ProductTO : TransferObject {
  string name;
  string price;
  string stock;
  
  override string[string] toMap() {
    string[string] map;
    map["name"] = name;
    map["price"] = price;
    map["stock"] = stock;
    return map;
  }
  
  override void fromMap(string[string] data) {
    name = data.get("name", "");
    price = data.get("price", "0");
    stock = data.get("stock", "0");
  }
}

class OrderItemTO : TransferObject {
  string productName;
  string quantity;
  string unitPrice;
  
  override string[string] toMap() {
    string[string] map;
    map["productName"] = productName;
    map["quantity"] = quantity;
    map["unitPrice"] = unitPrice;
    return map;
  }
  
  override void fromMap(string[string] data) {
    productName = data.get("productName", "");
    quantity = data.get("quantity", "0");
    unitPrice = data.get("unitPrice", "0");
  }
}

class OrderWithItemsTO : CompositeTransferObject {
  string orderId;
  string customerName;
  string totalAmount;
  
  override string[string] toMap() {
    string[string] map;
    map["orderId"] = orderId;
    map["customerName"] = customerName;
    map["totalAmount"] = totalAmount;
    return map;
  }
  
  override void fromMap(string[string] data) {
    orderId = data.get("orderId", "");
    customerName = data.get("customerName", "");
    totalAmount = data.get("totalAmount", "0");
  }
}

// Test Assemblers

class CustomerAssembler : TransferObjectAssembler!(Customer, CustomerTO) {
  override CustomerTO toTransferObject(Customer domain) {
    auto to = new CustomerTO();
    to.firstName = domain.firstName;
    to.lastName = domain.lastName;
    to.email = domain.email;
    return to;
  }
  
  override Customer toDomainObject(CustomerTO transfer) {
    return new Customer(0, transfer.firstName, transfer.lastName, 
                       transfer.email, "");
  }
}

class OrderAssembler : TransferObjectAssembler!(Order, OrderTO) {
  override OrderTO toTransferObject(Order domain) {
    import std.conv : to;
    auto orderTO = new OrderTO();
    orderTO.customerId = domain.customerId.to!string;
    orderTO.orderDate = domain.orderDate;
    orderTO.totalAmount = domain.totalAmount.to!string;
    return orderTO;
  }
  
  override Order toDomainObject(OrderTO transfer) {
    import std.conv : to;
    return new Order(0, transfer.customerId.to!int, transfer.orderDate,
                    transfer.totalAmount.to!double);
  }
}

// Comprehensive Tests

@safe unittest {
  mixin(ShowTest!("Basic CustomerTO validation"));
  
  auto customer = new CustomerTO();
  customer.firstName = "John";
  customer.lastName = "Doe";
  customer.email = "john.doe@example.com";
  
  assert(customer.validate(), "Valid customer should pass validation");
  
  auto invalidCustomer = new CustomerTO();
  invalidCustomer.firstName = "Jane";
  invalidCustomer.lastName = "Smith";
  invalidCustomer.email = "invalid-email";
  
  assert(!invalidCustomer.validate(), "Invalid email should fail validation");
}

@safe unittest {
  mixin(ShowTest!("CustomerTO serialization"));
  
  auto customer = new CustomerTO();
  customer.firstName = "Alice";
  customer.lastName = "Johnson";
  customer.email = "alice@example.com";
  
  string json = customer.toJson();
  assert(json.length > 0, "JSON should not be empty");
  
  auto customer2 = new CustomerTO();
  customer2.fromJson(json);
  
  assert(customer2.firstName == "Alice", "First name should match");
  assert(customer2.lastName == "Johnson", "Last name should match");
  assert(customer2.email == "alice@example.com", "Email should match");
}

@safe unittest {
  mixin(ShowTest!("CustomerTO map conversion"));
  
  auto customer = new CustomerTO();
  customer.firstName = "Bob";
  customer.lastName = "Wilson";
  customer.email = "bob@example.com";
  
  auto map = customer.toMap();
  assert(map["firstName"] == "Bob");
  assert(map["lastName"] == "Wilson");
  assert(map["email"] == "bob@example.com");
  
  auto customer2 = new CustomerTO();
  customer2.fromMap(map);
  assert(customer2.firstName == "Bob");
  assert(customer2.email == "bob@example.com");
}

@safe unittest {
  mixin(ShowTest!("OrderTO validation"));
  
  auto order = new OrderTO();
  order.customerId = "123";
  order.orderDate = "2026-01-17";
  order.totalAmount = "99.99";
  
  assert(order.validate(), "Valid order should pass validation");
  
  auto invalidOrder = new OrderTO();
  invalidOrder.customerId = "abc";  // Invalid integer
  invalidOrder.totalAmount = "99.99";
  
  assert(!invalidOrder.validate(), "Invalid customer ID should fail validation");
}

@safe unittest {
  mixin(ShowTest!("OrderWithItemsTO composite structure"));
  
  auto order = new OrderWithItemsTO();
  order.orderId = "ORD-001";
  order.customerName = "John Doe";
  order.totalAmount = "299.97";
  
  auto item1 = new OrderItemTO();
  item1.productName = "Laptop";
  item1.quantity = "1";
  item1.unitPrice = "199.99";
  
  auto item2 = new OrderItemTO();
  item2.productName = "Mouse";
  item2.quantity = "2";
  item2.unitPrice = "49.99";
  
  order.addChild(item1);
  order.addChild(item2);
  
  assert(order.getChildren().length == 2, "Order should have 2 items");
  assert(order.validate(), "Order with items should be valid");
}

@safe unittest {
  mixin(ShowTest!("CustomerAssembler domain to TO"));
  
  auto assembler = new CustomerAssembler();
  auto customer = new Customer(1, "Charlie", "Brown", "charlie@example.com", "555-1234");
  
  auto customerTO = assembler.toTransferObject(customer);
  
  assert(customerTO.firstName == "Charlie");
  assert(customerTO.lastName == "Brown");
  assert(customerTO.email == "charlie@example.com");
}

@safe unittest {
  mixin(ShowTest!("CustomerAssembler TO to domain"));
  
  auto assembler = new CustomerAssembler();
  
  auto customerTO = new CustomerTO();
  customerTO.firstName = "Diana";
  customerTO.lastName = "Prince";
  customerTO.email = "diana@example.com";
  
  auto customer = assembler.toDomainObject(customerTO);
  
  assert(customer.firstName == "Diana");
  assert(customer.lastName == "Prince");
  assert(customer.email == "diana@example.com");
}

@safe unittest {
  mixin(ShowTest!("CustomerAssembler batch conversion"));
  
  auto assembler = new CustomerAssembler();
  
  Customer[] customers = [
    new Customer(1, "Eve", "Adams", "eve@example.com", "555-0001"),
    new Customer(2, "Frank", "Baker", "frank@example.com", "555-0002"),
    new Customer(3, "Grace", "Clark", "grace@example.com", "555-0003")
  ];
  
  auto transferObjects = assembler.toTransferObjects(customers);
  
  assert(transferObjects.length == 3, "Should convert all 3 customers");
  assert(transferObjects[0].firstName == "Eve");
  assert(transferObjects[1].firstName == "Frank");
  assert(transferObjects[2].firstName == "Grace");
  
  auto backToCustomers = assembler.toDomainObjects(transferObjects);
  assert(backToCustomers.length == 3);
  assert(backToCustomers[0].email == "eve@example.com");
}

@safe unittest {
  mixin(ShowTest!("OrderAssembler with numeric conversions"));
  
  auto assembler = new OrderAssembler();
  auto order = new Order(1, 123, "2026-01-17", 499.99);
  
  auto orderTO = assembler.toTransferObject(order);
  
  assert(orderTO.customerId == "123");
  assert(orderTO.orderDate == "2026-01-17");
  assert(orderTO.totalAmount == "499.99");
  
  auto backToOrder = assembler.toDomainObject(orderTO);
  assert(backToOrder.customerId == 123);
  assert(backToOrder.totalAmount == 499.99);
}

@safe unittest {
  mixin(ShowTest!("ProductTO data encapsulation"));
  
  auto product = new ProductTO();
  product.name = "Keyboard";
  product.price = "79.99";
  product.stock = "50";
  
  auto map = product.toMap();
  assert(map["name"] == "Keyboard");
  assert(map["price"] == "79.99");
  assert(map["stock"] == "50");
}

@safe unittest {
  mixin(ShowTest!("Nested composite TO structure"));
  
  auto mainOrder = new OrderWithItemsTO();
  mainOrder.orderId = "ORD-MAIN";
  mainOrder.customerName = "Main Customer";
  mainOrder.totalAmount = "1000.00";
  
  auto subOrder1 = new OrderWithItemsTO();
  subOrder1.orderId = "ORD-SUB1";
  subOrder1.customerName = "Sub Customer 1";
  subOrder1.totalAmount = "500.00";
  
  auto subOrder2 = new OrderWithItemsTO();
  subOrder2.orderId = "ORD-SUB2";
  subOrder2.customerName = "Sub Customer 2";
  subOrder2.totalAmount = "500.00";
  
  mainOrder.addChild(subOrder1);
  mainOrder.addChild(subOrder2);
  
  assert(mainOrder.getChildren().length == 2);
  assert(mainOrder.validate());
}

@safe unittest {
  mixin(ShowTest!("Real-world e-commerce scenario"));
  
  // Create customer
  auto customerTO = new CustomerTO();
  customerTO.firstName = "Sarah";
  customerTO.lastName = "Miller";
  customerTO.email = "sarah.miller@example.com";
  
  assert(customerTO.validate());
  
  // Create order with items
  auto orderWithItems = new OrderWithItemsTO();
  orderWithItems.orderId = "ORD-2026-001";
  orderWithItems.customerName = customerTO.firstName ~ " " ~ customerTO.lastName;
  orderWithItems.totalAmount = "849.97";
  
  // Add order items
  auto item1 = new OrderItemTO();
  item1.productName = "Gaming Laptop";
  item1.quantity = "1";
  item1.unitPrice = "799.99";
  
  auto item2 = new OrderItemTO();
  item2.productName = "Gaming Mouse";
  item2.quantity = "1";
  item2.unitPrice = "49.98";
  
  orderWithItems.addChild(item1);
  orderWithItems.addChild(item2);
  
  assert(orderWithItems.getChildren().length == 2);
  assert(orderWithItems.validate());
  
  // Serialize to JSON for API transfer
  string customerJson = customerTO.toJson();
  assert(customerJson.length > 0);
  
  // Transfer complete order
  auto orderMap = orderWithItems.toMap();
  assert(orderMap["orderId"] == "ORD-2026-001");
  assert(orderMap["customerName"] == "Sarah Miller");
}

@safe unittest {
  mixin(ShowTest!("TO data isolation - modifications don't affect original"));
  
  auto customer = new Customer(1, "Original", "Name", "original@example.com", "555-0000");
  auto assembler = new CustomerAssembler();
  
  auto customerTO = assembler.toTransferObject(customer);
  
  // Modify TO
  customerTO.firstName = "Modified";
  customerTO.email = "modified@example.com";
  
  // Original should be unchanged
  assert(customer.firstName == "Original");
  assert(customer.email == "original@example.com");
}
