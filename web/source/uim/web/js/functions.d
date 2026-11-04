/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.web.js.functions;

import uim.web;

mixin(ShowModule!());

@safe:

/// Variable declaration, e.g. jsVar("x", "42") -> "var x = 42;"
string jsVar(string name, string expression) {
  return "var %s = %s;".format(name, expression);
}

/// Let declaration, e.g. jsLet("x", "42") -> "let x = 42;"
string jsLet(string name, string expression) {
  return "let %s = %s;".format(name, expression);
}

/// Const declaration, e.g. jsConst("x", "42") -> "const x = 42;"
string jsConst(string name, string expression) {
  return "const %s = %s;".format(name, expression);
}

/// Function call, e.g. jsCall("alert", "'hi'") -> "alert('hi');"
string jsCall(string functionName, string[] arguments...) {
  return "%s(%s);".format(functionName, arguments.join(", "));
}

/// Function call on an object, e.g. jsMethodCall("console", "log", "'hi'") -> "console.log('hi');"
string jsMethodCall(string objectName, string method, string[] arguments...) {
  return "%s.%s(%s);".format(objectName, method, arguments.join(", "));
}

/// Function declaration, e.g. jsFunction("greet", ["name"], "return name;")
string jsFunction(string name, string[] parameters, string body) {
  return "function %s(%s) { %s }".format(name, parameters.join(", "), body);
}

/// Arrow function expression, e.g. jsArrow(["x"], "x * 2") -> "(x) => x * 2"
string jsArrow(string[] parameters, string expression) {
  return "(%s) => %s".format(parameters.join(", "), expression);
}

/// Arrow function with block body
string jsArrowBlock(string[] parameters, string body) {
  return "(%s) => { %s }".format(parameters.join(", "), body);
}

/// Anonymous function expression
string jsAnonymous(string[] parameters, string body) {
  return "function(%s) { %s }".format(parameters.join(", "), body);
}

/// Immediately invoked function expression (IIFE)
string jsIife(string body) {
  return "(function() { %s })();".format(body);
}

/// Return statement, e.g. jsReturn("x") -> "return x;"
string jsReturn(string expression) {
  return "return %s;".format(expression);
}

/// If statement, e.g. jsIf("x > 1", "y();")
string jsIf(string condition, string thenBody, string elseBody = null) {
  return elseBody.length > 0
    ? "if (%s) { %s } else { %s }".format(condition, thenBody, elseBody)
    : "if (%s) { %s }".format(condition, thenBody);
}

/// For loop statement, e.g. jsFor("let i = 0", "i < 10", "i++", "f(i);")
string jsFor(string init, string condition, string increment, string body) {
  return "for (%s; %s; %s) { %s }".format(init, condition, increment, body);
}

/// for...of loop statement
string jsForOf(string variable, string iterable, string body) {
  return "for (const %s of %s) { %s }".format(variable, iterable, body);
}

/// while loop statement
string jsWhile(string condition, string body) {
  return "while (%s) { %s }".format(condition, body);
}

/// try/catch statement
string jsTryCatch(string tryBody, string catchBody, string errorVariable = "error") {
  return "try { %s } catch (%s) { %s }".format(tryBody, errorVariable, catchBody);
}

/// Template literal with placeholders, e.g. jsTemplate("Hello ${name}") -> "`Hello ${name}`"
string jsTemplate(string content) {
  return "`%s`".format(content);
}

/// console.log() call, e.g. consoleLog("'hi'") -> "console.log('hi');"
string consoleLog(string[] arguments...) {
  return jsMethodCall("console", "log", arguments);
}

/// console.error() call
string consoleError(string[] arguments...) {
  return jsMethodCall("console", "error", arguments);
}

/// alert() call with a string message, e.g. alert("hi") -> `alert('hi');`
string alert(string message) {
  return jsCall("alert", jsString(message));
}

/// confirm() call with a string message
string confirm(string message) {
  return jsCall("confirm", jsString(message));
}

/// setTimeout() call, e.g. setTimeout("f()", 1000) -> "setTimeout(f(), 1000);"
string setTimeout(string expression, int milliseconds) {
  return jsCall("setTimeout", expression, milliseconds.to!string);
}

/// setInterval() call
string setInterval(string expression, int milliseconds) {
  return jsCall("setInterval", expression, milliseconds.to!string);
}

///
unittest {
  // declarations
  assert(jsVar("x", "42") == "var x = 42;");
  assert(jsLet("x", "42") == "let x = 42;");
  assert(jsConst("x", "42") == "const x = 42;");

  // calls
  assert(jsCall("alert", "'hi'") == "alert('hi');");
  assert(jsCall("f") == "f();");
  assert(jsMethodCall("console", "log", "'hi'") == "console.log('hi');");

  // functions
  assert(jsFunction("greet", ["name"], "return name;") == "function greet(name) { return name; }");
  assert(jsArrow(["x"], "x * 2") == "(x) => x * 2");
  assert(jsArrowBlock(["x"], "return x;") == "(x) => { return x; }");
  assert(jsAnonymous(["a", "b"], "return a + b;") == "function(a, b) { return a + b; }");
  assert(jsIife("init();") == "(function() { init(); })();");

  // control flow
  assert(jsReturn("x") == "return x;");
  assert(jsIf("x > 1", "y();") == "if (x > 1) { y(); }");
  assert(jsIf("x > 1", "y();", "z();") == "if (x > 1) { y(); } else { z(); }");
  assert(jsFor("let i = 0", "i < 10", "i++", "f(i);") == "for (let i = 0; i < 10; i++) { f(i); }");
  assert(jsForOf("item", "items", "f(item);") == "for (const item of items) { f(item); }");
  assert(jsWhile("running", "tick();") == "while (running) { tick(); }");
  assert(jsTryCatch("run();", "log(error);") == "try { run(); } catch (error) { log(error); }");

  // template literal
  assert(jsTemplate("Hello ${name}") == "`Hello ${name}`");

  // console and dialogs
  assert(consoleLog("'hi'") == "console.log('hi');");
  assert(consoleError("'oops'") == "console.error('oops');");
  assert(alert("hi") == "alert('hi');");
  assert(alert("it's") == `alert('it\'s');`);
  assert(confirm("Sure?") == "confirm('Sure?');");

  // timers
  assert(setTimeout("f()", 1000) == "setTimeout(f(), 1000);");
  assert(setInterval("tick()", 500) == "setInterval(tick(), 500);");
}
