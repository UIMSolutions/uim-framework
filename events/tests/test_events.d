/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module events.tests.test_events;

import uim.events;
import std.stdio;

void testEventCreation() {
  writeln("Testing event creation...");

  auto event = Event("test.event");
  assert(event.name() == "test.event");
  assert(!event.isPropagationStopped());

  writeln("✓ Event creation test passed");
}

void testEventData() {
  writeln("Testing event data...");

  auto event = Event("test.data");
  event.setData("key1", Json("value1"));
  event.setData("key2", Json("value2"));

  assert(event.hasKey("key1"));
  assert(event.getData("key1") == Json("value1"));
  assert(event.getData("key2") == Json("value2"));
  assert(event.getData("nonexistent", Json("default")) == Json("default"));

  writeln("✓ Event data test passed");
}

void testEventPropagation() {
  writeln("Testing event propagation...");

  auto event = Event("test.propagation");
  assert(!event.isPropagationStopped());

  event.stopPropagation();
  assert(event.isPropagationStopped());

  writeln("✓ Event propagation test passed");
}

void testListener() {
  writeln("Testing listeners...");

  int callCount = 0;
  auto listener = EventListener((IEvent event) { callCount++; });

  auto event = Event("test");
  listener.execute(event);
  assert(callCount == 1);

  listener.execute(event);
  assert(callCount == 2);

  writeln("✓ Listener test passed");
}

void testOneTimeListener() {
  writeln("Testing one-time listeners...");

  int callCount = 0;
  auto listener = EventListenerOnce((IEvent event) { callCount++; });

  auto event = Event("test");
  listener.execute(event);
  assert(callCount == 1);

  listener.execute(event);
  assert(callCount == 1); // Should not increment

  writeln("✓ One-time listener test passed");
}

void testDispatcher() {
  writeln("Testing dispatcher...");

  auto dispatcher = EventDispatcher();
  int callCount = 0;

  dispatcher.on("test.event", (IEvent event) { callCount++; });

  auto event = Event("test.event");
  dispatcher.dispatch(event);
  assert(callCount == 1);

  writeln("✓ Dispatcher test passed");
}

void testDispatcherPriority() {
  writeln("Testing dispatcher priority...");

  auto dispatcher = EventDispatcher();
  string order = "";

  dispatcher.on("test", (IEvent event) { order ~= "B"; }, 0);

  dispatcher.on("test", (IEvent event) { order ~= "A"; }, 10);

  dispatcher.on("test", (IEvent event) { order ~= "C"; }, -5);

  dispatcher.dispatch(Event("test"));
  assert(order == "ABC", "Expected ABC but got: " ~ order);

  writeln("✓ Dispatcher priority test passed");
}

void testDispatcherStopPropagation() {
  writeln("Testing dispatcher stop propagation...");

  auto dispatcher = EventDispatcher();
  string order = "";

  dispatcher.on("test", (IEvent event) { order ~= "1"; event.stopPropagation(); }, 10);

  dispatcher.on("test", (IEvent event) { order ~= "2"; }, 0);

  dispatcher.dispatch(Event("test"));
  assert(order == "1", "Expected only '1' but got: " ~ order);

  writeln("✓ Dispatcher stop propagation test passed");
}

void testDispatcherOnce() {
  writeln("Testing dispatcher once...");

  auto dispatcher = EventDispatcher();
  int callCount = 0;

  dispatcher.once("test", (IEvent event) { callCount++; });

  dispatcher.dispatch(Event("test"));
  assert(callCount == 1);

  dispatcher.dispatch(Event("test"));
  assert(callCount == 1); // Should not increment

  writeln("✓ Dispatcher once test passed");
}

void testMultipleListeners() {
  writeln("Testing multiple listeners...");

  auto dispatcher = EventDispatcher();
  int count1 = 0, count2 = 0, count3 = 0;

  dispatcher.on("test", (IEvent event) { count1++; });
  dispatcher.on("test", (IEvent event) { count2++; });
  dispatcher.on("test", (IEvent event) { count3++; });

  dispatcher.dispatch(Event("test"));
  assert(count1 == 1);
  assert(count2 == 1);
  assert(count3 == 1);

  writeln("✓ Multiple listeners test passed");
}

void testRemoveListeners() {
  writeln("Testing remove listeners...");

  auto dispatcher = EventDispatcher();
  int callCount = 0;

  dispatcher.on("test", (IEvent event) { callCount++; });

  assert(dispatcher.hasListeners("test"));

  dispatcher.dispatch(Event("test"));
  assert(callCount == 1);

  dispatcher.removeListeners("test");
  assert(!dispatcher.hasListeners("test"));

  dispatcher.dispatch(Event("test"));
  assert(callCount == 1); // Should not increment

  writeln("✓ Remove listeners test passed");
}

void testSubscriber() {
  writeln("Testing subscriber...");

  class TestSubscriber : DEventSubscriber {
    int count1 = 0;
    int count2 = 0;

    override void subscribe(DEventDispatcher dispatcher) {
      dispatcher.on("event1", (IEvent event) { count1++; });

      dispatcher.on("event2", (IEvent event) { count2++; });
    }
  }

  auto dispatcher = EventDispatcher();
  auto subscriber = new TestSubscriber();
  subscriber.subscribe(dispatcher);

  dispatcher.dispatch(Event("event1"));
  assert(subscriber.count1 == 1);
  assert(subscriber.count2 == 0);

  dispatcher.dispatch(Event("event2"));
  assert(subscriber.count1 == 1);
  assert(subscriber.count2 == 1);

  writeln("✓ Subscriber test passed");
}

void main() {
  writeln("=== Running UIM Events Tests ===\n");

  testEventCreation();
  testEventData();
  testEventPropagation();
  testListener();
  testOneTimeListener();
  testDispatcher();
  testDispatcherPriority();
  testDispatcherStopPropagation();
  testDispatcherOnce();
  testMultipleListeners();
  testRemoveListeners();
  testSubscriber();

  writeln("\n=== All tests passed! ===");
}
