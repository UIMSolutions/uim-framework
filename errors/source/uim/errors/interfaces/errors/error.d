/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.errors.interfaces.errors.error;

import uim.errors;

mixin(ShowModule!());
@safe:

// Error Interface
interface IError : IObject {
  bool initialize(Json[string] initData);

  string loglabel();
  IError loglabel(string newLabel);

  int errorCode();
  IError errorCode(int newCode);

  long timestamp();
  IError timestamp(long newTimestamp);

  string severity();
  IError severity(string newSeverity);

  // Read-Only
  string loglevel();
  // Read-Only
  string line();

  string message();
  IError message(string newMessage);

  string fileName();
  IError fileName(string newFileName);

  size_t lineNumber();
  IError lineNumber(size_t newLineNumber);

  string[string][] trace();
  IError trace(string[string][] newTrace);
  string traceAsString();

  IError previous();
  IError previous(IError newPrevious);

  Json[string] attributes();
  IError attributes(Json[string] newAttributes);

  IError addTrace(string reference, string file, string line);
  IError addTrace(string[string] newTrace);
}

/* Old Code 
  /*     // This interface is used to define the contract for all exception classes in the UIManufaktur framework.
    // It ensures that all exceptions have a message and a code, and provides methods for getting and setting these values.
    // The interface also defines a method for getting the exception type, which can be used to categorize exceptions.
    int getCode();
    string getType(); * /

  // Exception message
  string message();

  // The file name of the D source code corresponding with where the error was thrown from.
  string file();

  // The line number of the D source code corresponding with where the error was thrown from.
  size_t line();

  // Template string that has attributes formateded into it.
  string messageTemplate(string templateName = "default");
  void messageTemplate(string templateName, string templateText);

  string[string] messageTemplates();
  void messageTemplates(string[string] templates);

*/
