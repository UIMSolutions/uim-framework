/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module test_uda;

import uim.events;
import std.stdio;

void testEventAttribute() {
  writeln("Testing @Event attribute...");

  @Event("custom.event")
  class CustomEvent : DEvent {
    this() {
      super("custom.event");
    }
  }

  assert(hasEventAttribute!CustomEvent);
  assert(getEventName!CustomEvent == "custom.event");

  writeln("✓ @Event attribute test passed");
}

void testBasicAnnotatedListener() {
  writeln("Testing basic annotated listener...");

  class TestHandler : DAnnotatedEventHandler {
    int callCount = 0;

    @EventListener("test.event")
    void onTestEvent(IEvent event) {
      callCount++;
    }
  }

  auto dispatcher = EventDispatcher();
  auto handler = new TestHandler();
  handler.registerWith(dispatcher);

  dispatcher.dispatch(Event("test.event"));
  assert(handler.callCount == 1);

  dispatcher.dispatch(Event("test.event"));
  assert(handler.callCount == 2);

  writeln("✓ Basic annotated listener test passed");
}

void testAnnotatedListenerOnce() {
  writeln("Testing annotated one-time listener...");

  class TestHandler : DAnnotatedEventHandler {
    int callCount = 0;

    @EventListenerOnce("once.event")
    void onOnceEvent(IEvent event) {
      callCount++;
    }
  }

  auto dispatcher = EventDispatcher();
  auto handler = new TestHandler();
  handler.registerWith(dispatcher);

  dispatcher.dispatch(Event("once.event"));
  assert(handler.callCount == 1);

  dispatcher.dispatch(Event("once.event"));
  assert(handler.callCount == 1); // Should not increment

  writeln("✓ Annotated one-time listener test passed");
}

void testAnnotatedPriority() {
  writeln("Testing annotated listener priority...");

  class TestHandler : DAnnotatedEventHandler {
    string order = "";

    @EventListener("priority.test", 0)
    void normalPriority(IEvent event) {
      order ~= "B";
    }

    @EventListener("priority.test", 10)
    void highPriority(IEvent event) {
      order ~= "A";
    }

    @EventListener("priority.test", -5)
    void lowPriority(IEvent event) {
      order ~= "C";
    }
  }

  auto dispatcher = EventDispatcher();
  auto handler = new TestHandler();
  handler.registerWith(dispatcher);

  dispatcher.dispatch(Event("priority.test"));
  assert(handler.order == "ABC", "Expected ABC but got: " ~ handler.order);

  writeln("✓ Annotated listener priority test passed");
}

void testMultipleAnnotatedHandlers() {
  writeln("Testing multiple annotated handlers...");

  class Handler1 : DAnnotatedEventHandler {
    int count = 0;

    @EventListener("shared.event")
    void onSharedEvent(IEvent event) {
      count++;
    }
  }

  class Handler2 : DAnnotatedEventHandler {
    int count = 0;

    @EventListener("shared.event")
    void onSharedEvent(IEvent event) {
      count++;
    }
  }

  auto dispatcher = EventDispatcher();
  auto handler1 = new Handler1();
  auto handler2 = new Handler2();

  handler1.registerWith(dispatcher);
  handler2.registerWith(dispatcher);

  dispatcher.dispatch(Event("shared.event"));

  assert(handler1.count == 1);
  assert(handler2.count == 1);

  writeln("✓ Multiple annotated handlers test passed");
}

void testAnnotatedWithCustomEvent() {
  writeln("Testing annotated listeners with custom events...");

  @Event("user.created")
  class UserCreatedEvent : DEvent {
    string username;

    this(string name) {
      super("user.created");
      username = name;
    }
  }

  class UserHandler : DAnnotatedEventHandler {
    string lastUsername;

    @EventListener("user.created")
    void onUserCreated(IEvent event) {
      auto userEvent = cast(UserCreatedEvent)event;
      lastUsername = userEvent.username;
    }
  }

  auto dispatcher = EventDispatcher();
  auto handler = new UserHandler();
  handler.registerWith(dispatcher);

  dispatcher.dispatch(new UserCreatedEvent("john_doe"));
  assert(handler.lastUsername == "john_doe");

  writeln("✓ Annotated listeners with custom events test passed");
}

void testMixedAnnotatedAndManual() {
  writeln("Testing mixed annotated and manual listeners...");

  class TestHandler : DAnnotatedEventHandler {
    int annotatedCount = 0;

    @EventListener("mixed.event")
    void onAnnotatedEvent(IEvent event) {
      annotatedCount++;
    }
  }

  auto dispatcher = EventDispatcher();
  auto handler = new TestHandler();
  handler.registerWith(dispatcher);

  int manualCount = 0;
  dispatcher.on("mixed.event", (IEvent event) { manualCount++; });

  dispatcher.dispatch(Event("mixed.event"));

  assert(handler.annotatedCount == 1);
  assert(manualCount == 1);

  writeln("✓ Mixed annotated and manual listeners test passed");
}

void testAnnotatedEventData() {
  writeln("Testing annotated listeners with event data...");

  class DataHandler : DAnnotatedEventHandler {
    string receivedData;

    @EventListener("data.event")
    void onDataEvent(IEvent event) {
      receivedData = event.getData("key");
    }
  }

  auto dispatcher = EventDispatcher();
  auto handler = new DataHandler();
  handler.registerWith(dispatcher);

  auto event = Event("data.event");
  event.setData("key", "test_value");
  dispatcher.dispatch(event);

  assert(handler.receivedData == "test_value");

  writeln("✓ Annotated listeners with event data test passed");
}

void testAnnotatedStopPropagation() {
  writeln("Testing annotated listener stop propagation...");

  class PropagationHandler : DAnnotatedEventHandler {
    bool firstCalled = false;
    bool secondCalled = false;

    @EventListener("stop.test", 10)
    void firstHandler(IEvent event) {
      firstCalled = true;
      event.stopPropagation();
    }

    @EventListener("stop.test", 0)
    void secondHandler(IEvent event) {
      secondCalled = true;
    }
  }

  auto dispatcher = EventDispatcher();
  auto handler = new PropagationHandler();
  handler.registerWith(dispatcher);

  dispatcher.dispatch(Event("stop.test"));

  assert(handler.firstCalled);
  assert(!handler.secondCalled);

  writeln("✓ Annotated listener stop propagation test passed");
}

void main() {
  writeln("=== Running UIM Events UDA Tests ===\n");

  testEventAttribute();
  testBasicAnnotatedListener();
  testAnnotatedListenerOnce();
  testAnnotatedPriority();
  testMultipleAnnotatedHandlers();
  testAnnotatedWithCustomEvent();
  testMixedAnnotatedAndManual();
  testAnnotatedEventData();
  testAnnotatedStopPropagation();

  writeln("\n=== All UDA tests passed! ===");
}
