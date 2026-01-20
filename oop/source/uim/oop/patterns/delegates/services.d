/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.delegates.services;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Base Business Service implementation.
 */
abstract class BusinessService : IBusinessService {
  protected string _name;

  /**
   * Constructor.
   */
  this(string name) {
    _name = name;
  }

  /**
   * Execute a business operation.
   * Must be implemented by subclasses.
   */
  abstract string execute();

  /**
   * Get the service name.
   */
  string serviceName() {
    return _name;
  }
}

/**
 * EJB Business Service.
 * Simulates an Enterprise JavaBeans-style service.
 */
class EJBService : BusinessService {
  private string _response;

  /**
   * Constructor.
   */
  this(string response = "EJB Service: Processing request") {
    super("EJBService");
    _response = response;
  }

  /**
   * Execute EJB business logic.
   */
  override string execute() {
    return _response;
  }
}

/**
 * JMS Business Service.
 * Simulates a Java Message Service-style service.
 */
class JMSService : BusinessService {
  private string _message;

  /**
   * Constructor.
   */
  this(string message = "JMS Service: Message sent") {
    super("JMSService");
    _message = message;
  }

  /**
   * Execute JMS business logic.
   */
  override string execute() {
    return _message;
  }
}

/**
 * REST API Business Service.
 * Simulates a RESTful web service.
 */
class RESTService : BusinessService {
  private string _endpoint;
  private string _method;

  /**
   * Constructor.
   */
  this(string endpoint, string method = "GET") {
    super("RESTService");
    _endpoint = endpoint;
    _method = method;
  }

  /**
   * Execute REST API call.
   */
  override string execute() {
    return "REST " ~ _method ~ " " ~ _endpoint ~ ": Success";
  }

  /**
   * Get the endpoint.
   */
  string endpoint() {
    return _endpoint;
  }

  /**
   * Get the HTTP method.
   */
  string method() {
    return _method;
  }
}

/**
 * Database Business Service.
 * Simulates database operations.
 */
class DatabaseService : BusinessService {
  private string _query;

  /**
   * Constructor.
   */
  this(string query) {
    super("DatabaseService");
    _query = query;
  }

  /**
   * Execute database query.
   */
  override string execute() {
    return "Database: Executed query - " ~ _query;
  }

  /**
   * Get the query.
   */
  string query() {
    return _query;
  }
}

/**
 * Email Business Service.
 * Handles email operations.
 */
class EmailService : BusinessService {
  private string _recipient;
  private string _subject;

  /**
   * Constructor.
   */
  this(string recipient, string subject) {
    super("EmailService");
    _recipient = recipient;
    _subject = subject;
  }

  /**
   * Send email.
   */
  override string execute() {
    return "Email sent to " ~ _recipient ~ " with subject: " ~ _subject;
  }

  /**
   * Get recipient.
   */
  string recipient() {
    return _recipient;
  }

  /**
   * Get subject.
   */
  string subject() {
    return _subject;
  }
}

/**
 * Authentication Business Service.
 */
class AuthenticationService : BusinessService {
  private bool delegate(string, string) @safe _authenticator;

  /**
   * Constructor.
   */
  this(bool delegate(string, string) @safe authenticator) {
    super("AuthenticationService");
    _authenticator = authenticator;
  }

  /**
   * Authenticate user.
   */
  string authenticate(string username, string password) {
    if (_authenticator(username, password)) {
      return "Authentication successful for " ~ username;
    }
    return "Authentication failed for " ~ username;
  }

  /**
   * Execute authentication with default credentials.
   */
  override string execute() {
    return "Authentication service ready";
  }
}

/**
 * Payment Business Service.
 */
class PaymentService : BusinessService {
  private double _amount;
  private string _currency;

  /**
   * Constructor.
   */
  this() {
    super("PaymentService");
    _amount = 0.0;
    _currency = "USD";
  }

  /**
   * Process payment.
   */
  string processPayment(double amount, string currency = "USD") {
    _amount = amount;
    _currency = currency;
    return execute();
  }

  /**
   * Execute payment processing.
   */
  override string execute() {
    import std.conv : to;
    if (_amount <= 0) {
      return "Payment Error: Invalid amount";
    }
    return "Payment processed: " ~ _amount.to!string ~ " " ~ _currency;
  }

  /**
   * Get amount.
   */
  double amount() {
    return _amount;
  }

  /**
   * Get currency.
   */
  string currency() {
    return _currency;
  }
}

/**
 * Logging Business Service.
 */
class LoggingService : BusinessService {
  private string[] _logs;
  private string _level;

  /**
   * Constructor.
   */
  this(string level = "INFO") {
    super("LoggingService");
    _level = level;
  }

  /**
   * Log a message.
   */
  string log(string message) {
    import std.datetime : Clock;
    string logEntry = "[" ~ _level ~ "] " ~ Clock.currTime().toISOExtString() ~ " - " ~ message;
    _logs ~= logEntry;
    return logEntry;
  }

  /**
   * Execute logging.
   */
  override string execute() {
    return log("Service executed");
  }

  /**
   * Get all logs.
   */
  string[] logs() {
    return _logs;
  }

  /**
   * Clear logs.
   */
  void clearLogs() {
    _logs = [];
  }

  /**
   * Get log level.
   */
  string level() {
    return _level;
  }

  /**
   * Set log level.
   */
  void setLevel(string level) {
    _level = level;
  }
}

/**
 * Generic Calculation Service.
 */
class CalculationService : IGenericBusinessService!(double[], double) {
  private string _operation;

  /**
   * Constructor.
   */
  this(string operation = "sum") {
    _operation = operation;
  }

  /**
   * Execute calculation.
   */
  double execute(double[] numbers) {
    import std.algorithm : sum, maxElement, minElement;
    import std.math : sqrt;

    switch (_operation) {
      case "sum":
        return numbers.sum();
      case "average":
        return numbers.length > 0 ? numbers.sum() / numbers.length : 0.0;
      case "max":
        return numbers.length > 0 ? numbers.maxElement() : 0.0;
      case "min":
        return numbers.length > 0 ? numbers.minElement() : 0.0;
      default:
        return 0.0;
    }
  }

  /**
   * Get service name.
   */
  string serviceName() {
    return "CalculationService[" ~ _operation ~ "]";
  }

  /**
   * Get operation type.
   */
  string operation() {
    return _operation;
  }

  /**
   * Set operation type.
   */
  void setOperation(string operation) {
    _operation = operation;
  }
}

// Unit Tests

@safe unittest {
  // Test EJB Service
  auto ejb = new EJBService("Custom EJB Response");
  assert(ejb.serviceName() == "EJBService");
  assert(ejb.execute() == "Custom EJB Response");
}

@safe unittest {
  // Test JMS Service
  auto jms = new JMSService("Custom JMS Message");
  assert(jms.serviceName() == "JMSService");
  assert(jms.execute() == "Custom JMS Message");
}

@safe unittest {
  // Test REST Service
  auto rest = new RESTService("/api/users", "POST");
  assert(rest.serviceName() == "RESTService");
  assert(rest.endpoint() == "/api/users");
  assert(rest.method() == "POST");
  string result = rest.execute();
  assert(result == "REST POST /api/users: Success");
}

@safe unittest {
  // Test Database Service
  auto db = new DatabaseService("SELECT * FROM users");
  assert(db.serviceName() == "DatabaseService");
  assert(db.query() == "SELECT * FROM users");
  string result = db.execute();
  assert(result.length > 0);
}

@safe unittest {
  // Test Email Service
  auto email = new EmailService("user@example.com", "Test Subject");
  assert(email.serviceName() == "EmailService");
  assert(email.recipient() == "user@example.com");
  assert(email.subject() == "Test Subject");
  string result = email.execute();
  assert(result.length > 0);
}

@safe unittest {
  // Test Authentication Service
  auto auth = new AuthenticationService((string user, string pass) {
    return user == "admin" && pass == "secret";
  });

  assert(auth.serviceName() == "AuthenticationService");
  string result1 = auth.authenticate("admin", "secret");
  assert(result1.length > 0 && result1[0..14] == "Authentication");
  
  string result2 = auth.authenticate("admin", "wrong");
  assert(result2.length > 0);
}

@safe unittest {
  // Test Payment Service
  auto payment = new PaymentService();
  assert(payment.serviceName() == "PaymentService");

  string result = payment.processPayment(99.99, "EUR");
  assert(payment.amount() == 99.99);
  assert(payment.currency() == "EUR");
  assert(result.length > 0);
}

@safe unittest {
  // Test Logging Service
  auto logger = new LoggingService("DEBUG");
  assert(logger.serviceName() == "LoggingService");
  assert(logger.level() == "DEBUG");

  logger.log("Test message 1");
  logger.log("Test message 2");
  assert(logger.logs().length == 2);

  logger.clearLogs();
  assert(logger.logs().length == 0);

  logger.setLevel("ERROR");
  assert(logger.level() == "ERROR");
}

@safe unittest {
  // Test Calculation Service
  auto calc = new CalculationService("sum");
  assert(calc.serviceName() == "CalculationService[sum]");
  assert(calc.operation() == "sum");

  double result = calc.execute([1.5, 2.5, 3.0]);
  assert(result == 7.0);

  calc.setOperation("average");
  result = calc.execute([10.0, 20.0, 30.0]);
  assert(result == 20.0);

  calc.setOperation("max");
  result = calc.execute([5.0, 15.0, 10.0]);
  assert(result == 15.0);

  calc.setOperation("min");
  result = calc.execute([5.0, 15.0, 10.0]);
  assert(result == 5.0);
}
