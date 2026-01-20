/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module oop.tests.patterns.observers;

import uim.oop;
import std.stdio;

@safe:

// Test basic observer pattern
unittest {
  class Counter : Subject!Counter {
    private int _count;

    void increment() {
      _count++;
      notify();
    }

    int count() { return _count; }
  }

  int observerCallCount = 0;
  int lastCount = 0;

  auto observer = createObserver!Counter((counter, data) {
    observerCallCount++;
    lastCount = counter.count();
  });

  auto counter = new Counter();
  counter.attach(observer);

  assert(counter.observerCount() == 1, "Should have one observer");

  counter.increment();
  assert(observerCallCount == 1, "Observer should be called once");
  assert(lastCount == 1, "Observer should receive correct state");

  counter.increment();
  assert(observerCallCount == 2, "Observer should be called twice");
  assert(lastCount == 2, "Observer should receive updated state");
}

// Test multiple observers
unittest {
  class DataSource : Subject!DataSource {
    private string _data;

    void setData(string data) {
      _data = data;
      notify();
    }

    string data() { return _data; }
  }

  int observer1Calls = 0;
  int observer2Calls = 0;

  auto observer1 = createObserver!DataSource((source, data) {
    observer1Calls++;
  });

  auto observer2 = createObserver!DataSource((source, data) {
    observer2Calls++;
  });

  auto source = new DataSource();
  source.attach(observer1);
  source.attach(observer2);

  assert(source.observerCount() == 2, "Should have two observers");

  source.setData("test");
  assert(observer1Calls == 1, "Observer 1 should be called");
  assert(observer2Calls == 1, "Observer 2 should be called");

  // Detach one observer
  source.detach(observer1);
  assert(source.observerCount() == 1, "Should have one observer left");

  source.setData("test2");
  assert(observer1Calls == 1, "Observer 1 should not be called after detach");
  assert(observer2Calls == 2, "Observer 2 should still be called");
}

// Test observer with data payload
unittest {
  class NewsPublisher : Subject!NewsPublisher {
    void publishNews(string headline) {
      notify(cast(Object) new String(headline));
    }
  }

  class String {
    string value;
    this(string v) { value = v; }
  }

  string receivedHeadline;

  auto subscriber = createObserver!NewsPublisher((publisher, data) {
    if (auto headline = cast(String) data) {
      receivedHeadline = headline.value;
    }
  });

  auto publisher = new NewsPublisher();
  publisher.attach(subscriber);

  publisher.publishNews("Breaking News!");
  assert(receivedHeadline == "Breaking News!", "Should receive correct headline");
}

// Test event-based observer system
unittest {
  auto eventSystem = new EventSubject();
  
  int loginEvents = 0;
  int logoutEvents = 0;

  auto observer = new EventObserver();
  
  observer.registerHandler("user.login", (type, data) {
    loginEvents++;
  });
  
  observer.registerHandler("user.logout", (type, data) {
    logoutEvents++;
  });

  eventSystem.attach(observer);

  assert(observer.handlesEvent("user.login"), "Should handle login events");
  assert(observer.handlesEvent("user.logout"), "Should handle logout events");
  assert(!observer.handlesEvent("user.unknown"), "Should not handle unknown events");

  eventSystem.emit("user.login", new EventData("user.login"));
  assert(loginEvents == 1, "Login event should be received");
  assert(logoutEvents == 0, "Logout event should not be received");

  eventSystem.emit("user.logout", new EventData("user.logout"));
  assert(loginEvents == 1, "Login count should not change");
  assert(logoutEvents == 1, "Logout event should be received");

  // Emit unhandled event
  eventSystem.emit("user.unknown", new EventData("user.unknown"));
  assert(loginEvents == 1, "Unhandled event should not affect login count");
  assert(logoutEvents == 1, "Unhandled event should not affect logout count");
}

// Test clearing observers
unittest {
  class TestSubject : Subject!TestSubject {
    void trigger() {
      notify();
    }
  }

  int callCount = 0;
  auto observer = createObserver!TestSubject((s, d) { callCount++; });

  auto subject = new TestSubject();
  subject.attach(observer);
  subject.trigger();
  assert(callCount == 1, "Observer should be called");

  subject.clearObservers();
  assert(subject.observerCount() == 0, "All observers should be cleared");

  subject.trigger();
  assert(callCount == 1, "Observer should not be called after clear");
}

// Test duplicate observer attachment
unittest {
  class TestSubject : Subject!TestSubject {
    void trigger() {
      notify();
    }
  }

  int callCount = 0;
  auto observer = createObserver!TestSubject((s, d) { callCount++; });

  auto subject = new TestSubject();
  subject.attach(observer);
  subject.attach(observer); // Attach same observer again

  assert(subject.observerCount() == 1, "Should not add duplicate observer");

  subject.trigger();
  assert(callCount == 1, "Observer should only be called once");
}

// Test event data with payload
unittest {
  class UserData {
    string username;
    this(string name) { username = name; }
  }

  class UserEventData : EventData {
    UserData userData;
    
    this(string eventType, UserData data) {
      super(eventType);
      userData = data;
    }
  }

  auto eventSystem = new EventSubject();
  
  string receivedUsername;
  auto observer = new EventObserver();
  
  observer.registerHandler("user.created", (type, data) {
    if (auto userEvent = cast(UserEventData) data) {
      receivedUsername = userEvent.userData.username;
    }
  });

  eventSystem.attach(observer);

  auto userData = new UserData("john_doe");
  auto eventData = new UserEventData("user.created", userData);
  
  eventSystem.emit("user.created", eventData);
  assert(receivedUsername == "john_doe", "Should receive user data in event");
}
