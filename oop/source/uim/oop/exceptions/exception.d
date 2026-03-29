module uim.oop.exceptions.exception;


import uim.oop;

mixin(ShowModule!());

@safe:

class UIMException : Exception {
  this(string msg) {
    super(msg);
  }

  this(string msg, string file = __FILE__, size_t line = __LINE__, Throwable next = null) {
    super(msg, file, line, next);
  }
}
///
unittest {
  UIMException ex1 = new UIMException("Test message");
  assert(ex1.message == "Test message");

  UIMException ex2 = new UIMException("Test message", "testfile.d", 123);
  assert(ex2.message == "Test message");
  assert(ex2.file == "testfile.d");
  assert(ex2.line == 123);
}