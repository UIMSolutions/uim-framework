/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.transferobjects.transferobject;

import uim.oop.patterns.transferobjects.interfaces;

/**
 * Base class for Transfer Objects.
 * Provides common functionality for data transfer between layers.
 */
abstract class TransferObject : ITransferObject {
  /**
   * Validate the transfer object data.
   * Override in derived classes for custom validation.
   */
  bool validate() @safe {
    return true;
  }

  /**
   * Convert to associative array representation.
   * Override in derived classes to provide actual implementation.
   */
  abstract string[string] toMap() @safe;

  /**
   * Populate from associative array.
   * Override in derived classes to provide actual implementation.
   */
  abstract void fromMap(string[string] data) @safe;
}

/**
 * Serializable Transfer Object with JSON support.
 */
abstract class SerializableTransferObject : TransferObject, ISerializableTransferObject {
  /**
   * Serialize to JSON string.
   */
  string toJson() @safe {
    import std.json : JSONValue;
    auto map = toMap();
    JSONValue json = map;
    return json.toString();
  }

  /**
   * Deserialize from JSON string.
   */
  void fromJson(string jsonStr) @trusted {
    import std.json : parseJSON;
    auto json = parseJSON(jsonStr);
    string[string] map;
    foreach (key, value; json.object) {
      map[key] = value.str;
    }
    fromMap(map);
  }
}

/**
 * Base class for Transfer Object Assemblers.
 * Converts between domain objects and transfer objects.
 */
abstract class TransferObjectAssembler(TDomain, TTransfer) : ITransferObjectAssembler!(TDomain, TTransfer) {
  /**
   * Convert domain object to transfer object.
   */
  abstract TTransfer toTransferObject(TDomain domain) @safe;

  /**
   * Convert transfer object to domain object.
   */
  abstract TDomain toDomainObject(TTransfer transfer) @safe;

  /**
   * Convert array of domain objects to transfer objects.
   */
  TTransfer[] toTransferObjects(TDomain[] domains) @safe {
    TTransfer[] result;
    foreach (domain; domains) {
      result ~= toTransferObject(domain);
    }
    return result;
  }

  /**
   * Convert array of transfer objects to domain objects.
   */
  TDomain[] toDomainObjects(TTransfer[] transfers) @safe {
    TDomain[] result;
    foreach (transfer; transfers) {
      result ~= toDomainObject(transfer);
    }
    return result;
  }
}

/**
 * Composite Transfer Object that can contain nested transfer objects.
 */
abstract class CompositeTransferObject : TransferObject, ICompositeTransferObject {
  private ITransferObject[] _children;

  /**
   * Constructor.
   */
  this() @safe {
    _children = [];
  }

  /**
   * Get nested transfer objects.
   */
  ITransferObject[] getChildren() @safe {
    return _children;
  }

  /**
   * Add a child transfer object.
   */
  void addChild(ITransferObject child) @safe {
    _children ~= child;
  }

  /**
   * Validate all children.
   */
  override bool validate() @safe {
    foreach (child; _children) {
      if (!child.validate()) {
        return false;
      }
    }
    return true;
  }
}

/**
 * Immutable Transfer Object for read-only data transfer.
 */
abstract class ImmutableTransferObject : TransferObject {
  private bool _initialized = false;

  /**
   * Populate from associative array (only once).
   */
  override void fromMap(string[string] data) @safe {
    if (!_initialized) {
      fromMapImpl(data);
      _initialized = true;
    }
  }

  /**
   * Implementation of fromMap.
   * Override in derived classes.
   */
  protected abstract void fromMapImpl(string[string] data) @safe;

  /**
   * Check if initialized.
   */
  bool isInitialized() @safe {
    return _initialized;
  }
}

// Unit Tests

@safe unittest {
  // Test simple transfer object
  class UserTO : TransferObject {
    string username;
    string email;
    int age;

    override string[string] toMap() {
      import std.conv : to;
      string[string] map;
      map["username"] = username;
      map["email"] = email;
      map["age"] = age.to!string;
      return map;
    }

    override void fromMap(string[string] data) {
      import std.conv : to;
      username = data.get("username", "");
      email = data.get("email", "");
      age = data.get("age", "0").to!int;
    }

    override bool validate() {
      return username.length > 0 && email.length > 0 && age >= 0;
    }
  }

  auto user = new UserTO();
  user.username = "john_doe";
  user.email = "john@example.com";
  user.age = 30;

  assert(user.validate());

  auto map = user.toMap();
  assert(map["username"] == "john_doe");
  assert(map["email"] == "john@example.com");

  auto user2 = new UserTO();
  user2.fromMap(map);
  assert(user2.username == "john_doe");
  assert(user2.age == 30);
}

@safe unittest {
  // Test serializable transfer object
  class ProductTO : SerializableTransferObject {
    string name;
    string price;

    override string[string] toMap() {
      string[string] map;
      map["name"] = name;
      map["price"] = price;
      return map;
    }

    override void fromMap(string[string] data) {
      name = data.get("name", "");
      price = data.get("price", "0");
    }
  }

  auto product = new ProductTO();
  product.name = "Laptop";
  product.price = "999.99";

  string json = product.toJson();
  assert(json.length > 0);

  auto product2 = new ProductTO();
  product2.fromJson(json);
  assert(product2.name == "Laptop");
}

@safe unittest {
  // Test composite transfer object
  class OrderItemTO : TransferObject {
    string productName;
    int quantity;

    override string[string] toMap() {
      import std.conv : to;
      string[string] map;
      map["productName"] = productName;
      map["quantity"] = quantity.to!string;
      return map;
    }

    override void fromMap(string[string] data) {
      import std.conv : to;
      productName = data.get("productName", "");
      quantity = data.get("quantity", "0").to!int;
    }
  }

  class OrderTO : CompositeTransferObject {
    string orderId;

    override string[string] toMap() {
      string[string] map;
      map["orderId"] = orderId;
      return map;
    }

    override void fromMap(string[string] data) {
      orderId = data.get("orderId", "");
    }
  }

  auto order = new OrderTO();
  order.orderId = "ORD-123";

  auto item1 = new OrderItemTO();
  item1.productName = "Laptop";
  item1.quantity = 1;

  auto item2 = new OrderItemTO();
  item2.productName = "Mouse";
  item2.quantity = 2;

  order.addChild(item1);
  order.addChild(item2);

  assert(order.getChildren().length == 2);
  assert(order.validate());
}

@safe unittest {
  // Test immutable transfer object
  class ConfigTO : ImmutableTransferObject {
    string apiKey;
    string endpoint;

    override string[string] toMap() {
      string[string] map;
      map["apiKey"] = apiKey;
      map["endpoint"] = endpoint;
      return map;
    }

    protected override void fromMapImpl(string[string] data) {
      apiKey = data.get("apiKey", "");
      endpoint = data.get("endpoint", "");
    }
  }

  auto config = new ConfigTO();
  assert(!config.isInitialized());

  string[string] data;
  data["apiKey"] = "secret123";
  data["endpoint"] = "https://api.example.com";

  config.fromMap(data);
  assert(config.isInitialized());
  assert(config.apiKey == "secret123");

  // Try to modify - should be ignored
  data["apiKey"] = "newsecret";
  config.fromMap(data);
  assert(config.apiKey == "secret123"); // Should still be old value
}

@safe unittest {
  // Test transfer object assembler
  class User {
    int id;
    string name;
    string email;

    this(int id, string name, string email) {
      this.id = id;
      this.name = name;
      this.email = email;
    }
  }

  class UserTO : TransferObject {
    string name;
    string email;

    override string[string] toMap() {
      string[string] map;
      map["name"] = name;
      map["email"] = email;
      return map;
    }

    override void fromMap(string[string] data) {
      name = data.get("name", "");
      email = data.get("email", "");
    }
  }

  class UserAssembler : TransferObjectAssembler!(User, UserTO) {
    override UserTO toTransferObject(User domain) {
      auto to = new UserTO();
      to.name = domain.name;
      to.email = domain.email;
      return to;
    }

    override User toDomainObject(UserTO transfer) {
      return new User(0, transfer.name, transfer.email);
    }
  }

  auto assembler = new UserAssembler();
  auto user = new User(1, "Alice", "alice@example.com");

  auto userTO = assembler.toTransferObject(user);
  assert(userTO.name == "Alice");
  assert(userTO.email == "alice@example.com");

  auto user2 = assembler.toDomainObject(userTO);
  assert(user2.name == "Alice");
  assert(user2.email == "alice@example.com");
}
