/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.udas;

@safe:

/** Marks a type as a generic IoC component. */
struct Component {
  string name;

  this(string componentName) {
    name = componentName;
  }
}

/** Marks a type as a service component. */
struct Service {
  string name;

  this(string serviceName) {
    name = serviceName;
  }
}

/** Marks a type as a repository component. */
struct Repository {
  string name;

  this(string repositoryName) {
    name = repositoryName;
  }
}

/** Marks a type as a web/controller component. */
struct WebController {
  string name;

  this(string controllerName) {
    name = controllerName;
  }
}

/** Marks a type that contains bean factory methods. */
struct Configuration {
}

/** Marks a method as bean factory method. */
struct Bean {
  string name;

  this(string beanName) {
    name = beanName;
  }
}

/** Marks a field/parameter for autowiring. */
struct Autowired {
  bool required = true;

  this(bool isRequired) {
    required = isRequired;
  }
}

/** JSR-style injection marker. */
struct Inject {
}

/** Selects a concrete bean by qualifier name. */
struct Qualifier {
  string value;

  this(string qualifier) {
    value = qualifier;
  }
}

/** Injects a literal or property expression value. */
struct Value {
  string expression;

  this(string expr) {
    expression = expr;
  }
}

/** Declares component scope, e.g. singleton/prototype. */
struct Scope {
  string name;

  this(string scopeName) {
    name = scopeName;
  }
}

/** Marks a component for lazy initialization. */
struct Lazy {
  bool enabled = true;

  this(bool isEnabled) {
    enabled = isEnabled;
  }
}

/** Marks a preferred bean candidate. */
struct Primary {
}

/** Lifecycle hook called after dependency injection. */
struct PostConstruct {
}

/** Lifecycle hook called before bean destruction. */
struct PreDestroy {
}

/** Marks a member for getter generation/handling. */
struct Getter {
}

/** Marks a member for setter generation/handling. */
struct Setter {
}

/** Marks a member as both getter and setter capable. */
struct Accessor {
}

/** Generic request mapping marker. */
struct RequestMapping {
  string path;
  string method;

  this(string mappingPath, string httpMethod = "") {
    path = mappingPath;
    method = httpMethod;
  }
}

/** Shortcut for GET request mapping. */
struct GetMapping {
  string path;

  this(string mappingPath) {
    path = mappingPath;
  }
}

/** Shortcut for POST request mapping. */
struct PostMapping {
  string path;

  this(string mappingPath) {
    path = mappingPath;
  }
}

/** Shortcut for PUT request mapping. */
struct PutMapping {
  string path;

  this(string mappingPath) {
    path = mappingPath;
  }
}

/** Shortcut for DELETE request mapping. */
struct DeleteMapping {
  string path;

  this(string mappingPath) {
    path = mappingPath;
  }
}

/** Shortcut for PATCH request mapping. */
struct PatchMapping {
  string path;

  this(string mappingPath) {
    path = mappingPath;
  }
}

/** Checks whether a type has Spring-style component stereotype UDAs. */
template hasComponentAttribute(T) {
  import std.traits : hasUDA;

  enum hasComponentAttribute = hasUDA!(T, Component)
      || hasUDA!(T, Service)
      || hasUDA!(T, Repository)
      || hasUDA!(T, WebController);
}

/** Returns the configured component name (empty when not specified). */
template getComponentName(T) {
  import std.traits : getUDAs, hasUDA;

  static if (hasUDA!(T, Component)) {
    enum getComponentName = getUDAs!(T, Component)[0].name;
  } else static if (hasUDA!(T, Service)) {
    enum getComponentName = getUDAs!(T, Service)[0].name;
  } else static if (hasUDA!(T, Repository)) {
    enum getComponentName = getUDAs!(T, Repository)[0].name;
  } else static if (hasUDA!(T, WebController)) {
    enum getComponentName = getUDAs!(T, WebController)[0].name;
  } else {
    enum getComponentName = "";
  }
}

/** Checks whether a member is marked for dependency injection. */
template hasInjectionAttribute(alias member) {
  import std.traits : hasUDA;

  enum hasInjectionAttribute = hasUDA!(member, Autowired) || hasUDA!(member, Inject);
}

/** Returns true when a method is marked as bean factory. */
template hasBeanAttribute(alias member) {
  import std.traits : hasUDA;

  enum hasBeanAttribute = hasUDA!(member, Bean);
}

/** Returns bean name from @Bean("...") or an empty string. */
template getBeanName(alias member) {
  import std.traits : getUDAs;

  static if (hasBeanAttribute!member) {
    enum getBeanName = getUDAs!(member, Bean)[0].name;
  } else {
    enum getBeanName = "";
  }
}

/** Checks whether a member has an HTTP mapping UDA. */
template hasRequestMapping(alias member) {
  import std.traits : hasUDA;

  enum hasRequestMapping = hasUDA!(member, RequestMapping)
      || hasUDA!(member, GetMapping)
      || hasUDA!(member, PostMapping)
      || hasUDA!(member, PutMapping)
      || hasUDA!(member, DeleteMapping)
      || hasUDA!(member, PatchMapping);
}

/** Checks whether a member has a getter marker UDA. */
template hasGetterAttribute(alias member) {
  import std.traits : hasUDA;

  enum hasGetterAttribute = hasUDA!(member, Getter) || hasUDA!(member, Accessor);
}

/** Checks whether a member has a setter marker UDA. */
template hasSetterAttribute(alias member) {
  import std.traits : hasUDA;

  enum hasSetterAttribute = hasUDA!(member, Setter) || hasUDA!(member, Accessor);
}

/** Checks whether a member has both getter and setter semantics. */
template hasAccessorAttribute(alias member) {
  import std.traits : hasUDA;

  enum hasAccessorAttribute = hasUDA!(member, Accessor)
      || (hasUDA!(member, Getter) && hasUDA!(member, Setter));
}

/** Returns mapped path for request mapping UDAs. */
template getRequestPath(alias member) {
  import std.traits : getUDAs, hasUDA;

  static if (hasUDA!(member, RequestMapping)) {
    enum getRequestPath = getUDAs!(member, RequestMapping)[0].path;
  } else static if (hasUDA!(member, GetMapping)) {
    enum getRequestPath = getUDAs!(member, GetMapping)[0].path;
  } else static if (hasUDA!(member, PostMapping)) {
    enum getRequestPath = getUDAs!(member, PostMapping)[0].path;
  } else static if (hasUDA!(member, PutMapping)) {
    enum getRequestPath = getUDAs!(member, PutMapping)[0].path;
  } else static if (hasUDA!(member, DeleteMapping)) {
    enum getRequestPath = getUDAs!(member, DeleteMapping)[0].path;
  } else static if (hasUDA!(member, PatchMapping)) {
    enum getRequestPath = getUDAs!(member, PatchMapping)[0].path;
  } else {
    enum getRequestPath = "";
  }
}

/** Returns mapped HTTP method for request mapping UDAs. */
template getRequestMethod(alias member) {
  import std.traits : getUDAs, hasUDA;

  static if (hasUDA!(member, RequestMapping)) {
    enum getRequestMethod = getUDAs!(member, RequestMapping)[0].method;
  } else static if (hasUDA!(member, GetMapping)) {
    enum getRequestMethod = "GET";
  } else static if (hasUDA!(member, PostMapping)) {
    enum getRequestMethod = "POST";
  } else static if (hasUDA!(member, PutMapping)) {
    enum getRequestMethod = "PUT";
  } else static if (hasUDA!(member, DeleteMapping)) {
    enum getRequestMethod = "DELETE";
  } else static if (hasUDA!(member, PatchMapping)) {
    enum getRequestMethod = "PATCH";
  } else {
    enum getRequestMethod = "";
  }
}

unittest {
  @Repository("userRepository")
  class UserRepository {
  }

  @Service("userService")
  class UserService {
    @Autowired UserRepository repository;

    @Getter
    @Setter
    string displayName;

    @Accessor
    string email;

    @PostConstruct
    void init() {
    }
  }

  @WebController("users")
  class UserController {
    @GetMapping("/users")
    void list() {
    }

    @RequestMapping("/users/:id", "DELETE")
    void remove() {
    }
  }

  @Configuration
  class AppConfig {
    @Bean("repo")
    UserRepository createRepository() {
      return new UserRepository();
    }
  }

  static assert(hasComponentAttribute!UserService);
  static assert(getComponentName!UserService == "userService");

  alias repositoryField = __traits(getMember, UserService, "repository");
  static assert(hasInjectionAttribute!repositoryField);

  alias displayNameField = __traits(getMember, UserService, "displayName");
  static assert(hasGetterAttribute!displayNameField);
  static assert(hasSetterAttribute!displayNameField);
  static assert(hasAccessorAttribute!displayNameField);

  alias emailField = __traits(getMember, UserService, "email");
  static assert(hasGetterAttribute!emailField);
  static assert(hasSetterAttribute!emailField);
  static assert(hasAccessorAttribute!emailField);

  alias listMethod = __traits(getMember, UserController, "list");
  static assert(hasRequestMapping!listMethod);
  static assert(getRequestPath!listMethod == "/users");
  static assert(getRequestMethod!listMethod == "GET");

  alias removeMethod = __traits(getMember, UserController, "remove");
  static assert(getRequestMethod!removeMethod == "DELETE");

  alias createRepositoryMethod = __traits(getMember, AppConfig, "createRepository");
  static assert(hasBeanAttribute!createRepositoryMethod);
  static assert(getBeanName!createRepositoryMethod == "repo");
}
