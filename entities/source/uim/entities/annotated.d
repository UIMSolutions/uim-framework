/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.annotated;

import uim.entities;
import std.conv : to;
import std.string : strip;

mixin(ShowModule!());

@safe:

/**
 * Automatically validate an entity based on field UDAs
 * Returns an array of validation error messages
 */
string[] validateAnnotateUIMEntity(T)(T entity) if (is(T == class) || is(T == struct)) {
  import std.traits : hasUDA, getUDAs, isCallable, isSomeFunction;
  import std.regex : regex, matchFirst;

  string[] errors;

  static foreach (fieldName; __traits(allMembers, T)) {
    {
      // Only process actual fields with UDA attributes
      static if (hasUDA!(__traits(getMember, T, fieldName), EntityAttribute) ||
        hasUDA!(__traits(getMember, T, fieldName), Required) ||
        hasUDA!(__traits(getMember, T, fieldName), MaxLength) ||
        hasUDA!(__traits(getMember, T, fieldName), MinLength) ||
        hasUDA!(__traits(getMember, T, fieldName), Pattern) ||
        hasUDA!(__traits(getMember, T, fieldName), Range)) {
        static if (__traits(compiles, __traits(getMember, entity, fieldName))) {
          // Check Required
          static if (hasUDA!(__traits(getMember, T, fieldName), Required)) {
            {
              auto value = __traits(getMember, entity, fieldName);
              static if (is(typeof(value) == string)) {
                if (value.strip().length == 0) {
                  errors ~= fieldName ~ " is required";
                }
              }
            }
          }

          // Check MaxLength
          static if (hasUDA!(__traits(getMember, T, fieldName), MaxLength)) {
            {
              enum attr = getUDAs!(__traits(getMember, T, fieldName), MaxLength)[0];
              auto value = __traits(getMember, entity, fieldName);
              static if (is(typeof(value) == string)) {
                if (value.length > attr.value) {
                  errors ~= fieldName ~ " exceeds maximum length of " ~ attr.value.to!string;
                }
              }
            }
          }

          // Check MinLength
          static if (hasUDA!(__traits(getMember, T, fieldName), MinLength)) {
            {
              enum attr = getUDAs!(__traits(getMember, T, fieldName), MinLength)[0];
              auto value = __traits(getMember, entity, fieldName);
              static if (is(typeof(value) == string)) {
                if (value.length < attr.value) {
                  errors ~= fieldName ~ " is below minimum length of " ~ attr.value.to!string;
                }
              }
            }
          }

          // Check Pattern
          static if (hasUDA!(__traits(getMember, T, fieldName), Pattern)) {
            {
              enum attr = getUDAs!(__traits(getMember, T, fieldName), Pattern)[0];
              auto value = __traits(getMember, entity, fieldName);
              static if (is(typeof(value) == string)) {
                auto pattern = regex(attr.regex);
                auto match = matchFirst(value, pattern);
                if (match.empty) {
                  errors ~= fieldName ~ " does not match required pattern";
                }
              }
            }
          }

          // Check Range
          static if (hasUDA!(__traits(getMember, T, fieldName), Range)) {
            {
              enum attr = getUDAs!(__traits(getMember, T, fieldName), Range)[0];
              auto value = __traits(getMember, entity, fieldName);
              static if (is(typeof(value) : long)) {
                if (value < attr.min || value > attr.max) {
                  errors ~= fieldName ~ " must be between " ~ attr.min.to!string ~ " and " ~ attr
                    .max.to!string;
                }
              }
            }
          }
        }
      }
    }

    return errors;
  }

  /**
 * Get all field names marked with EntityAttribute UDA
 */
  string[] getAnnotatedFieldNames(T)() if (is(T == class) || is(T == struct)) {
    import std.traits : hasUDA, isCallable;

    string[] fields;

    static foreach (fieldName; __traits(allMembers, T)) {
      {
        static if (__traits(compiles, __traits(getMember, T, fieldName)) &&
          !isCallable!(__traits(getMember, T, fieldName)) &&
          !is(typeof(__traits(getMember, T, fieldName)) == void)) {
          static if (hasUDA!(__traits(getMember, T, fieldName), EntityAttribute)) {
            fields ~= fieldName;
          }
        }
      }
    }

    return fields;
  }

  /**
 * Convert entity to associative array using UDA field names
 */
  string[string] toAnnotatedMap(T)(T entity) if (is(T == class) || is(T == struct)) {
    import std.traits : hasUDA, getUDAs, isCallable;

    string[string] result;

    static foreach (fieldName; __traits(allMembers, T)) {
      {
        static if (__traits(compiles, __traits(getMember, entity, fieldName)) &&
          !isCallable!(__traits(getMember, T, fieldName)) &&
          !is(typeof(__traits(getMember, T, fieldName)) == void)) {
          static if (hasUDA!(__traits(getMember, T, fieldName), EntityAttribute)) {
            {
              enum attr = getUDAs!(__traits(getMember, T, fieldName), EntityAttribute)[0];
              auto value = __traits(getMember, entity, fieldName);
              string key = attr.name.length > 0 ? attr.name : fieldName;
              result[key] = value.to!string;
            }
          }
        }
      }
    }

    return result;
  }

  /**
 * Populate entity from associative array using UDA field names
 */
  void fromAnnotatedMap(T)(T entity, string[string] data) if (is(T == class)) {
    import std.traits : hasUDA, getUDAs, isCallable;

    static foreach (fieldName; __traits(allMembers, T)) {
      {
        static if (__traits(compiles, __traits(getMember, entity, fieldName)) &&
          !isCallable!(__traits(getMember, T, fieldName)) &&
          !is(typeof(__traits(getMember, T, fieldName)) == void)) {
          static if (hasUDA!(__traits(getMember, T, fieldName), EntityAttribute)) {
            {
              // Skip ReadOnly fields
              static if (!hasUDA!(__traits(getMember, T, fieldName), ReadOnly)) {
                enum attr = getUDAs!(__traits(getMember, T, fieldName), EntityAttribute)[0];
                string key = attr.name.length > 0 ? attr.name : fieldName;

                if (auto ptr = key in data) {
                  alias FieldType = typeof(__traits(getMember, entity, fieldName));
                  static if (is(FieldType == string)) {
                    __traits(getMember, entity, fieldName) = *ptr;
                  } else static if (is(FieldType : long)) {
                    __traits(getMember, entity, fieldName) = (*ptr).to!FieldType;
                  } else static if (is(FieldType : real)) {
                    __traits(getMember, entity, fieldName) = (*ptr).to!FieldType;
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  /**
 * Base class for annotated entities
 */
  abstract class DAnnotateUIMEntity : UIMEntity {
    this() {
      super();
    }

    this(UUID entityId) {
      super(entityId);
    }

    /**
   * Validate this entity using UDAs
   */
    string[] validate() {
      return validateAnnotateUIMEntity(this);
    }

    /**
   * Check if entity is valid
   */
    override bool isValid() {
      return validate().length == 0;
    }

    /**
   * Convert to associative array
   */
    override string[string] toAA() {
      return toAnnotatedMap(this);
    }

    /**
   * Populate from associative array
   */
    DAnnotateUIMEntity fromAA(string[string] data) {
      fromAnnotatedMap(this, data);
      return this;
    }
  }

  /**
 * Mixin template to add annotated functionality to existing entities
 */
  mixin template AnnotateUIMEntity() {
    /**
   * Validate this entity using UDAs
   */
    string[] validate() {
      return validateAnnotateUIMEntity(this);
    }

    /**
   * Check if entity is valid
   */
    override bool isValid() {
      return validate().length == 0;
    }

    /**
   * Convert to associative array using annotated fields
   */
    override string[string] toAA() {
      return toAnnotatedMap(this);
    }

    /**
   * Populate from associative array using annotated fields
   */
    void fromAA(string[string] data) {
      fromAnnotatedMap(this, data);
    }
  }
}
  unittest {
    mixin(ShowTest!"Testing annotated entity validation...");

    @UseEntity("test_users")
    class TestUser : UIMEntity {
      @EntityAttribute("username")
      @Required
      @MaxLength(50)
      string username;

      @EntityAttribute("email")
      @Required
      @Pattern(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
      string email;

      @EntityAttribute("age")
      @Range(0, 150)
      int age;

      @EntityAttribute("id", false)
      @ReadOnly
      string entityId;
    }

    auto user = new TestUser();

    // Set valid values
    user.username = "john_doe";
    user.email = "john@example.com";
    user.age = 25;
    assert(user.username == "john_doe");
    assert(user.email == "john@example.com");

    writeln("✓ Annotated entity tests passed!");
  }

  unittest {
    mixin(ShowTest!"Testing annotated entity mapping...");

    @UseEntity("products")
    class Product : UIMEntity {
      /*
      @EntityAttribute("name")
      @Required
      string name; */

      @EntityAttribute("price")
      @Range(0, 1_000_000)
      double price;

      @EntityAttribute("sku")
      @ReadOnly
      string sku;

      override string[string] toAA() {
        auto map = super.toAA();
        map["price"] = this.price.to!string;
        map["sku"] = this.sku;
        return map;
      }
    }

    auto product = new Product();
    product.name = "Laptop";
    product.price = 999.99;
    product.sku = "LAP-001";

    // Test toAA
    auto map = product.toAA();
    writeln("Product as map: ", map);
    writeln("name: ", map);
    assert(map["name"] == "Laptop");
    assert(map["price"] == "999.99");

    // Create another instance
    auto newProduct = new Product();
    newProduct.name = "Mouse";
    newProduct.price = 29.99;
    assert(newProduct.name == "Mouse");
    assert(newProduct.price == 29.99);

    writeln("✓ Annotated entity mapping tests passed!");
  }
