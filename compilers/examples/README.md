# UIM Compilers Module - Examples

Updated on 1. February 2026

This directory contains examples demonstrating D language's powerful compile-time features. These examples showcase metaprogramming capabilities that make D unique and powerful.

## Examples Overview

### 1. String Mixins (`string_mixins.d`)

Demonstrates D's ability to generate and inject code at compile-time using string mixins.

**Topics covered:**

- Basic string mixin syntax
- Compile-time function generation (getters/setters)
- Math operation generation
- Switch case generation
- Property generation with validation
- Template-based code generation

**Run:**

```bash
cd /home/oz/DEV/D/UIM2026/LIBS/uim-framework/compilers
dub run :string_mixins
```

### 2. Compile-Time Function Execution (`ctfe.d`)

Shows how D can execute functions at compile-time, computing values and generating data before your program even runs.

**Topics covered:**

- Fibonacci calculation at compile-time
- String manipulation during compilation
- Lookup table generation
- Configuration parsing at compile-time
- Prime number generation
- Email validation during compilation
- Buffer size calculations
- Version string building

**Run:**

```bash
dub run :ctfe
```

### 3. Template Metaprogramming (`templates.d`)

Explores D's template system for generic programming and compile-time computation.

**Topics covered:**

- Basic function templates
- Template constraints
- Template specialization
- Recursive templates
- Template tuple parameters
- Type selection based on conditions
- Variadic template functions
- Compile-time power calculations

**Run:**

```bash
dub run :templates
```

### 4. Traits and Type Introspection (`traits.d`)

Demonstrates D's comprehensive compile-time type introspection capabilities.

**Topics covered:**

- Type checking (isNumeric, isFloatingPoint, etc.)
- Function traits (return type, parameters)
- Struct/class member introspection
- Checking for member existence
- Function attributes checking (@safe, pure, nothrow)
- Array type detection
- Compile-time type filtering
- Generic printing using traits

**Run:**

```bash
dub run :traits
```

### 5. User Defined Attributes (`udas.d`)

Shows how to use UDAs (User Defined Attributes) for metadata and compile-time annotations.

**Topics covered:**

- Simple marker attributes
- Attributes with parameters
- Multiple attributes on symbols
- Attributes on struct members
- Validation using attributes
- Custom serialization with attributes
- HTTP route annotations
- Dependency injection markers

**Run:**

```bash
dub run :udas
```

## Building All Examples

To build all examples at once:

```bash
cd /home/oz/DEV/D/UIM2026/LIBS/uim-framework/compilers
dub build --config=string_mixins
dub build --config=ctfe
dub build --config=templates
dub build --config=traits
dub build --config=udas
```

## Learning Path

For beginners to D's metaprogramming features, we recommend following this order:

1. **Start with `string_mixins.d`** - Learn the basics of compile-time code generation
2. **Move to `ctfe.d`** - Understand how functions can run at compile-time
3. **Study `templates.d`** - Master D's powerful template system
4. **Explore `traits.d`** - Learn compile-time type introspection
5. **Finish with `udas.d`** - Apply metadata and annotations to your code

## Key Concepts

### Compile-Time vs Runtime

D can execute a lot of code at compile-time:

- **Compile-time**: Happens during compilation, results are baked into the binary
- **Runtime**: Traditional program execution

Benefits of compile-time execution:

- Zero runtime overhead for computed values
- Earlier error detection
- Smaller binary sizes (pre-computed data)
- Powerful metaprogramming capabilities

### When to Use What

- **String Mixins**: When you need to generate code dynamically
- **CTFE**: When you want to compute values at compile-time
- **Templates**: For generic programming and type-based logic
- **Traits**: To inspect and manipulate types at compile-time
- **UDAs**: To add metadata for frameworks and tools

## Requirements

- DMD (D compiler) version 2.100 or later
- DUB (D package manager)
- uim-framework core modules

## Further Reading

- [D Programming Language - Templates](https://dlang.org/spec/template.html)
- [D Programming Language - CTFE](https://dlang.org/spec/function.html#interpretation)
- [D Programming Language - Traits](https://dlang.org/spec/traits.html)
- [D Programming Language - UDAs](https://dlang.org/spec/attribute.html#uda)

## License

Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.

## Author

Ozan Nurettin Süel (aka UIManufaktur)
