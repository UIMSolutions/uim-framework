/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.udas;

import uim.oop;

@safe:

/** Marks a type as a generic IoC component. */
struct UDAComponent {
  string name;

  this(string componentName) {
    name = componentName;
  }
}

/** Marks a type as a service component. */
struct UDAService {
  string name;

  this(string serviceName) {
    name = serviceName;
  }
}

/** Marks a type as a repository component. */
struct UDARepository {
  string name;

  this(string repositoryName) {
    name = repositoryName;
  }
}

/** Marks a type as a web/controller component. */
struct UDAWebController {
  string name;

  this(string controllerName) {
    name = controllerName;
  }
}

/** Marks a type that contains bean factory methods. */
struct UDAConfiguration {
}

/** Marks a method as bean factory method. */
struct UDABean {
  string name;

  this(string beanName) {
    name = beanName;
  }
}

/** Marks a field/parameter for autowiring. */
struct UDAAutowired {
  bool required = true;

  this(bool isRequired) {
    required = isRequired;
  }
}

/** JSR-style injection marker. */
struct UDAInject {
}

/** Selects a concrete bean by qualifier name. */
struct UDAQualifier {
  string value;

  this(string qualifier) {
    value = qualifier;
  }
}

/** Injects a literal or property expression value. */
struct UDAValue {
  string expression;

  this(string expr) {
    expression = expr;
  }
}

/** Declares component scope, e.g. singleton/prototype. */
struct UDAScope {
  string name;

  this(string scopeName) {
    name = scopeName;
  }
}

/** Marks a component for lazy initialization. */
struct UDALazy {
  bool enabled = true;

  this(bool isEnabled) {
    enabled = isEnabled;
  }
}

/** Marks a preferred bean candidate. */
struct UDAPrimary {
}

/** Lifecycle hook called after dependency injection. */
struct PostConstruct {
}

/** Lifecycle hook called before bean destruction. */
struct PreDestroy {
}

/** Marks a member for getter generation/handling. */
struct Getter {
  string fieldName;
  string datatype;
  string methodName;

  this(string field, string type = "", string method = "") {
    fieldName = field;
    datatype = type.length > 0 ? type : "auto";
    methodName = method.length > 0 ? method : "get" ~ fieldName[0 .. 1].toUpper() ~ fieldName[1 .. $];
  }
}
///
unittest {
  Getter g = Getter("age", "int");
  assert(g.fieldName == "age");
  assert(g.datatype == "int");
  assert(g.methodName == "getAge");

  Getter g2 = Getter("name", "string", "fetchName");
  assert(g2.fieldName == "name");
  assert(g2.datatype == "string");
  assert(g2.methodName == "fetchName");
}

private string generateGetterMethod(Getter getter) {
  return format(q{
  %1$s %2$s() {
    return this.%3$s;
  }}, getter.datatype, getter.methodName, getter.fieldName);
}
///
unittest {
  Getter g = Getter("age", "int");
  string generatedCode = generateGetterMethod(g);
  assert(generatedCode == q{
  int getAge() {
    return this.age;
  }});

  Getter g2 = Getter("name", "string", "fetchName");
  string generatedCode2 = generateGetterMethod(g2);
  assert(generatedCode2 == q{
  string fetchName() {
    return this.name;
  }});

  Getter g3 = Getter("email");
  string generatedCode3 = generateGetterMethod(g3);
  assert(generatedCode3 == q{
  auto getEmail() {
    return this.email;
  }});
}

/** Marks a member for setter generation/handling. */
struct Setter {
  string fieldName;
  string datatype;
  string methodName;
  string resultType;
  string returnCode;
  this(string field, string type = "", string method = "", string result = "void", string returns = "") {
    fieldName = field;
    datatype = type.length > 0 ? type : "auto";
    methodName = method.length > 0 ? method : "set" ~ fieldName[0 .. 1].toUpper() ~ fieldName[1 .. $];
    resultType = result.length > 0 ? result : "void";
    this.returnCode = returns;

  }
}
/// 
unittest {
  Setter s = Setter("age", "int");
  assert(s.fieldName == "age");
  assert(s.datatype == "int");
  assert(s.methodName == "setAge");
  assert(s.resultType == "void");
  assert(s.returnCode == "");

  Setter s2 = Setter("name", "string", "updateName");
  assert(s2.fieldName == "name");
  assert(s2.datatype == "string");
  assert(s2.methodName == "updateName");
  assert(s2.resultType == "void");
  assert(s2.returnCode == "");

  Setter s3 = Setter("email", "string", "changeEmail", "string", "return this.email;");
  assert(s3.fieldName == "email");
  assert(s3.datatype == "string");
  assert(s3.methodName == "changeEmail");
  assert(s3.resultType == "string");
  assert(s3.returnCode == "return this.email;");
}

private string generateSetterMethod(Setter setter) {
  return format(q{
  %4$s %2$s(%1$s value) {
    this.%3$s = value;
  }}, setter.datatype, setter.methodName, setter.fieldName, setter.resultType);
}
/// 
unittest {
  Setter s = Setter("age", "int");
  string generatedCode = generateSetterMethod(s);

  assert(generatedCode == q{
  void setAge(int value) {
    this.age = value;
  }});
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
    || hasUDA!(T, UDAService)
    || hasUDA!(T, UDARepository)
    || hasUDA!(T, UDAWebController);
}

/** Returns the configured component name (empty when not specified). */
template getComponentName(T) {
  import std.traits : getUDAs, hasUDA;

  static if (hasUDA!(T, Component)) {
    enum getComponentName = getUDAs!(T, Component)[0].name;
  } else static if (hasUDA!(T, UDAService)) {
    enum getComponentName = getUDAs!(T, UDAService)[0].name;
  } else static if (hasUDA!(T, UDARepository)) {
    enum getComponentName = getUDAs!(T, UDARepository)[0].name;
  } else static if (hasUDA!(T, UDAWebController)) {
    enum getComponentName = getUDAs!(T, UDAWebController)[0].name;
  } else {
    enum getComponentName = "";
  }
}

/** Checks whether a member is marked for dependency injection. */
template hasInjectionAttribute(alias member) {
  import std.traits : hasUDA;

  enum hasInjectionAttribute = hasUDA!(member, UDAAutowired) || hasUDA!(member, UDAInject);
}

/** Returns true when a method is marked as bean factory. */
template hasBeanAttribute(alias member) {
  import std.traits : hasUDA;

  enum hasBeanAttribute = hasUDA!(member, UDABean);
}

/** Returns bean name from @UDABean("...") or an empty string. */
template getBeanName(alias member) {
  import std.traits : getUDAs;

  static if (hasBeanAttribute!member) {
    enum getBeanName = getUDAs!(member, UDABean)[0].name;
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
    enum getRequestMethod = getUDAs!(member, RequestMapping)[0]
        .method;
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
  @UDARepository("userRepository")
  class UserRepository {
  }

  @UDAService("userService")
  class UserService {
    @UDAAutowired UserRepository repository;

    @Getter("displayName", "string")
    @Setter("displayName", "string")
    string displayName;
    @Accessor
    string email;
    @PostConstruct
    void init() {
    }

    auto repo = new UserRepository();
    // auto serv = new UserService();
  }

  @UDAWebController("users")
  class UserController {
    @GetMapping("/users")
    void list() {
    }

    @RequestMapping("/users/:id", "DELETE")
    void remove() {
    }
  }

  @UDAConfiguration
  class AppConfig {
    @UDABean("repo")
    UserRepository createRepository() {
      return new UserRepository();
    }
  }

  static assert(hasComponentAttribute!UserService);
  static assert(
    getComponentName!UserService == "userService");

  alias repositoryField = __traits(getMember, UserService, "repository");
  static assert(
    hasInjectionAttribute!repositoryField);

  alias displayNameField = __traits(getMember, UserService, "displayName");
  static assert(
    hasGetterAttribute!displayNameField);
  static assert(
    hasSetterAttribute!displayNameField);
  static assert(
    hasAccessorAttribute!displayNameField);

  alias emailField = __traits(getMember, UserService, "email");
  static assert(hasGetterAttribute!emailField);
  static assert(hasSetterAttribute!emailField);
  static assert(hasAccessorAttribute!emailField);

  alias listMethod = __traits(getMember, UserController, "list");
  static assert(hasRequestMapping!listMethod);
  static assert(
    getRequestPath!listMethod == "/users");
  static assert(
    getRequestMethod!listMethod == "GET");

  alias removeMethod = __traits(getMember, UserController, "remove");
  static assert(
    getRequestMethod!removeMethod == "DELETE");

  alias createRepositoryMethod = __traits(getMember, AppConfig, "createRepository");
  static assert(
    hasBeanAttribute!createRepositoryMethod);
  static assert(
    getBeanName!createRepositoryMethod == "repo");

  @UDAScope("prototype")
  @UDALazy(true)
  class ProtoService {}
  
  import std.traits : getUDAs, hasUDA;
  static assert(hasUDA!(ProtoService, UDAScope));
  static assert(getUDAs!(ProtoService, UDAScope)[0].name == "prototype");
  static assert(getUDAs!(ProtoService, UDALazy)[0].enabled == true);

  class UnmarkedClass {}
  static assert(!hasComponentAttribute!UnmarkedClass);
  static assert(getComponentName!UnmarkedClass == "");
}
