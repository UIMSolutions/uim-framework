/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.delegates.tests.test;

import uim.oop;

mixin(ShowModule!());

@safe:

@safe unittest {
  mixin(ShowTest!("Test Business Lookup - Basic Operations"));

  auto lookup = new BusinessLookup();
  auto ejbService = new EJBService("EJB Response");
  auto jmsService = new JMSService("JMS Response");

  // Register services
  lookup.registerService("EJB", ejbService);
  lookup.registerService("JMS", jmsService);

  // Check registration
  assert(lookup.hasService("EJB"), "EJB service should be registered");
  assert(lookup.hasService("JMS"), "JMS service should be registered");
  assert(!lookup.hasService("REST"), "REST service should not be registered");

  // Retrieve services
  auto retrieved = lookup.getBusinessService("EJB");
  assert(retrieved !is null, "Should retrieve EJB service");
  assert(retrieved.serviceName() == "EJBService", "Service name should match");

  // Service names
  auto names = lookup.serviceNames();
  assert(names.length == 2, "Should have 2 registered services");

  // Remove service
  assert(lookup.removeService("JMS"), "Should remove JMS service");
  assert(!lookup.hasService("JMS"), "JMS service should be removed");
  assert(lookup.hasService("EJB"), "EJB service should still exist");

  // Clear all
  lookup.clear();
  assert(lookup.serviceNames().length == 0, "All services should be cleared");
}

@safe unittest {
  mixin(ShowTest!("Test Basic Business Delegate"));

  auto lookup = new BusinessLookup();
  auto service = new EJBService("EJB Processing Complete");
  lookup.registerService("EJB", service);

  auto delegate_ = new BusinessDelegate(lookup, "EJB");

  assert(delegate_.serviceType() == "EJB", "Service type should match");

  string result = delegate_.doTask();
  assert(result == "EJB Processing Complete", "Should execute service correctly");
}

@safe unittest {
  mixin(ShowTest!("Test Business Delegate - Service Not Found"));

  auto lookup = new BusinessLookup();
  auto delegate_ = new BusinessDelegate(lookup, "NonExistent");

  string result = delegate_.doTask();
  assert(result.length > 6, "Result should contain error message");
  assert(result[0..6] == "Error:", "Should return error for missing service");
}

@safe unittest {
  mixin(ShowTest!("Test Cacheable Business Delegate"));

  auto lookup = new BusinessLookup();
  auto service = new RESTService("/api/data", "GET");
  lookup.registerService("REST", service);

  auto cacheableDelegate = new CacheableBusinessDelegate(lookup, "REST");

  // Verify caching is enabled
  assert(cacheableDelegate.isCacheEnabled(), "Cache should be enabled by default");

  // First call - not cached
  string result1 = cacheableDelegate.doTask();
  assert(result1 == "REST GET /api/data: Success", "First call should succeed");

  // Second call - should be cached
  string result2 = cacheableDelegate.doTask();
  assert(result2 == result1, "Cached result should match");

  // Clear cache
  cacheableDelegate.clearCache();

  // Disable caching
  cacheableDelegate.disableCache();
  assert(!cacheableDelegate.isCacheEnabled(), "Cache should be disabled");

  // Re-enable caching
  cacheableDelegate.enableCache();
  assert(cacheableDelegate.isCacheEnabled(), "Cache should be re-enabled");
}

@safe unittest {
  mixin(ShowTest!("Test Retryable Business Delegate"));

  auto lookup = new BusinessLookup();
  auto service = new DatabaseService("SELECT * FROM users");
  lookup.registerService("DB", service);

  auto retryDelegate = new RetryableBusinessDelegate(lookup, "DB", 3);

  // Test successful execution
  string result = retryDelegate.doTask();
  assert(result.length > 0, "Should execute successfully");
  assert(retryDelegate.retryCount() == 0, "No retries needed for success");

  // Change max retries
  retryDelegate.setMaxRetries(5);
  result = retryDelegate.doTask();
  assert(result.length > 0, "Should still execute successfully");
}

@safe unittest {
  mixin(ShowTest!("Test Logging Business Delegate"));

  auto lookup = new BusinessLookup();
  auto service = new EmailService("admin@example.com", "System Alert");
  lookup.registerService("Email", service);

  auto loggingDelegate = new LoggingBusinessDelegate(lookup, "Email");

  // Execute and check logs
  string result = loggingDelegate.doTask();
  assert(result.length > 0, "Should execute successfully");

  auto logs = loggingDelegate.logs();
  assert(logs.length >= 2, "Should have at least 2 log entries");

  // Verify log content
  bool hasExecutingLog = false;
  bool hasResultLog = false;
  foreach (log; logs) {
    if (log.indexOf("Executing service") >= 0) hasExecutingLog = true;
    if (log.indexOf("Result:") >= 0) hasResultLog = true;
  }
  assert(hasExecutingLog, "Should log execution");
  assert(hasResultLog, "Should log result");

  // Clear logs
  loggingDelegate.clearLogs();
  assert(loggingDelegate.logs().length == 0, "Logs should be cleared");

  // Disable logging
  loggingDelegate.setLoggingEnabled(false);
  loggingDelegate.doTask();
  assert(loggingDelegate.logs().length == 0, "No logs should be added when disabled");
}

@safe unittest {
  mixin(ShowTest!("Test Composite Business Delegate"));

  auto lookup = new BusinessLookup();

  // Register multiple services
  lookup.registerService("EJB", new EJBService("EJB Result"));
  lookup.registerService("JMS", new JMSService("JMS Result"));
  lookup.registerService("REST", new RESTService("/api/test", "GET"));

  // Create composite delegate
  auto composite = new CompositeBusinessDelegate("CompositeService");

  composite.addDelegate(new BusinessDelegate(lookup, "EJB"));
  composite.addDelegate(new BusinessDelegate(lookup, "JMS"));

  assert(composite.delegateCount() == 2, "Should have 2 delegates");
  assert(composite.serviceType() == "CompositeService", "Service type should match");

  // Execute composite
  string result = composite.doTask();
  assert(result.indexOf("EJB Result") >= 0, "Should contain EJB result");
  assert(result.indexOf("JMS Result") >= 0, "Should contain JMS result");
  assert(result.indexOf(" | ") >= 0, "Results should be separated");
}

@safe unittest {
  mixin(ShowTest!("Test Multiple Business Services"));

  // Test EJB Service
  auto ejb = new EJBService("Custom EJB");
  assert(ejb.serviceName() == "EJBService");
  assert(ejb.execute() == "Custom EJB");

  // Test JMS Service
  auto jms = new JMSService("Custom Message");
  assert(jms.serviceName() == "JMSService");
  assert(jms.execute() == "Custom Message");

  // Test REST Service
  auto rest = new RESTService("/users", "POST");
  assert(rest.endpoint() == "/users");
  assert(rest.method() == "POST");

  // Test Database Service
  auto db = new DatabaseService("INSERT INTO users");
  assert(db.query() == "INSERT INTO users");
}

@safe unittest {
  mixin(ShowTest!("Test Payment Service"));

  auto payment = new PaymentService();
  assert(payment.serviceName() == "PaymentService");

  // Process valid payment
  string result = payment.processPayment(150.50, "EUR");
  assert(payment.amount() == 150.50, "Amount should be set");
  assert(payment.currency() == "EUR", "Currency should be set");
  assert(result.indexOf("Payment processed") >= 0, "Should process successfully");

  // Process invalid payment
  result = payment.processPayment(0, "USD");
  assert(result.indexOf("Error") >= 0, "Should return error for invalid amount");
}

@safe unittest {
  mixin(ShowTest!("Test Logging Service"));

  auto logger = new LoggingService("INFO");
  assert(logger.serviceName() == "LoggingService");
  assert(logger.level() == "INFO");

  // Log messages
  string log1 = logger.log("First message");
  string log2 = logger.log("Second message");

  assert(logger.logs().length == 2, "Should have 2 logs");
  assert(log1.indexOf("INFO") >= 0, "Log should contain level");
  assert(log1.indexOf("First message") >= 0, "Log should contain message");

  // Change level
  logger.setLevel("ERROR");
  assert(logger.level() == "ERROR");

  // Clear logs
  logger.clearLogs();
  assert(logger.logs().length == 0, "Logs should be cleared");
}

@safe unittest {
  mixin(ShowTest!("Test Authentication Service"));

  auto auth = new AuthenticationService((string user, string pass) {
    return user == "admin" && pass == "password123";
  });

  assert(auth.serviceName() == "AuthenticationService");

  // Successful authentication
  string result = auth.authenticate("admin", "password123");
  assert(result.indexOf("successful") >= 0, "Should authenticate successfully");

  // Failed authentication
  result = auth.authenticate("admin", "wrongpass");
  assert(result.indexOf("failed") >= 0, "Should fail authentication");

  // Different user
  result = auth.authenticate("user", "password123");
  assert(result.indexOf("failed") >= 0, "Should fail for wrong user");
}

@safe unittest {
  mixin(ShowTest!("Test Calculation Service"));

  auto calc = new CalculationService("sum");
  assert(calc.serviceName() == "CalculationService[sum]");
  assert(calc.operation() == "sum");

  // Test sum
  double result = calc.execute([1.0, 2.0, 3.0, 4.0, 5.0]);
  assert(result == 15.0, "Sum should be 15.0");

  // Test average
  calc.setOperation("average");
  result = calc.execute([10.0, 20.0, 30.0]);
  assert(result == 20.0, "Average should be 20.0");

  // Test max
  calc.setOperation("max");
  result = calc.execute([5.0, 15.0, 10.0, 20.0]);
  assert(result == 20.0, "Max should be 20.0");

  // Test min
  calc.setOperation("min");
  result = calc.execute([5.0, 15.0, 10.0, 20.0]);
  assert(result == 5.0, "Min should be 5.0");

  // Test empty array
  calc.setOperation("sum");
  result = calc.execute([]);
  assert(result == 0.0, "Sum of empty array should be 0.0");
}

@safe unittest {
  mixin(ShowTest!("Test Generic Business Delegate"));

  auto calcService = new CalculationService("sum");
  auto genericDelegate = new GenericBusinessDelegate!(double[], double)(calcService, "Calculator");

  assert(genericDelegate.serviceType() == "Calculator");

  double result = genericDelegate.doTask([10.0, 20.0, 30.0]);
  assert(result == 60.0, "Sum should be 60.0");
}

@safe unittest {
  mixin(ShowTest!("Test Real-World Scenario - E-Commerce"));

  // Setup services
  auto lookup = new BusinessLookup();
  lookup.registerService("Auth", new AuthenticationService((u, p) => u == "customer" && p == "pass"));
  lookup.registerService("Payment", new PaymentService());
  lookup.registerService("Email", new EmailService("customer@example.com", "Order Confirmation"));
  lookup.registerService("DB", new DatabaseService("INSERT INTO orders VALUES (...)"));

  // Create delegates
  auto authDelegate = new BusinessDelegate(lookup, "Auth");
  auto paymentDelegate = new CacheableBusinessDelegate(lookup, "Payment");
  auto emailDelegate = new LoggingBusinessDelegate(lookup, "Email");

  // Simulate workflow
  string authResult = authDelegate.doTask();
  assert(authResult.indexOf("ready") >= 0, "Auth service should be ready");

  string paymentResult = paymentDelegate.doTask();
  assert(paymentResult.length > 0, "Payment should process");

  string emailResult = emailDelegate.doTask();
  assert(emailResult.length > 0, "Email should be sent");
  assert(emailDelegate.logs().length > 0, "Email delegate should log");
}

@safe unittest {
  mixin(ShowTest!("Test Service Replacement"));

  auto lookup = new BusinessLookup();
  auto service1 = new EJBService("Version 1");
  auto service2 = new EJBService("Version 2");

  // Register initial service
  lookup.registerService("EJB", service1);

  auto delegate_ = new BusinessDelegate(lookup, "EJB");
  string result = delegate_.doTask();
  assert(result == "Version 1", "Should use version 1");

  // Replace service
  lookup.registerService("EJB", service2);
  result = delegate_.doTask();
  assert(result == "Version 2", "Should use version 2 after replacement");
}

@safe unittest {
  mixin(ShowTest!("Test Empty Composite Delegate"));

  auto composite = new CompositeBusinessDelegate("Empty");
  assert(composite.delegateCount() == 0, "Should have no delegates");

  string result = composite.doTask();
  assert(result == "", "Empty composite should return empty string");
}
