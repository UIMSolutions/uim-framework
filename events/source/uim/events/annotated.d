/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.events.annotated;

import uim.core;
import uim.oop;
import uim.events.interfaces;
import uim.events.event;
import uim.events.dispatcher;
import uim.events.attributes;

@safe:

/**
 * Automatically register event listeners from a class using UDAs
 * Scans the object for methods marked with @EventListener or @EventListenerOnce
 */
void registerAnnotatedListeners(T)(T obj, DEventDispatcher dispatcher)
    if (is(T == class) || is(T == struct)) {
  import std.traits : hasUDA, getUDAs;

  static foreach (memberName; __traits(allMembers, T)) {
    {
      static if (is(typeof(__traits(getMember, obj, memberName)) == function)) {
        // Check for @EventListener
        static if (hasUDA!(__traits(getMember, T, memberName), EventListener)) {
          {
            {
              enum attr = getUDAs!(__traits(getMember, T, memberName), EventListener)[0];

              dispatcher.on(attr.eventName, (IEvent event) @trusted {
                __traits(getMember, obj, memberName)(event);
              }, attr.priority);
            }
          }
        } // Check for @EventListenerOnce
        else static if (hasUDA!(__traits(getMember, T, memberName), EventListenerOnce)) {
          {
            {
              enum attr = getUDAs!(__traits(getMember, T, memberName), EventListenerOnce)[0];

              dispatcher.once(attr.eventName, (IEvent event) @trusted {
                __traits(getMember, obj, memberName)(event);
              }, attr.priority);
            }
          }
        }
      }
    }
  }
}

/**
 * Base class for annotated event handlers
 * Automatically registers all @EventListener annotated methods
 */
abstract class DAnnotatedEventHandler : UIMObject {
  this() {
    super();
  }

  /**
     * Register this handler's annotated methods with a dispatcher
     * Must be called with the actual type to properly scan for UDAs
     */
  abstract void registerWith(DEventDispatcher dispatcher) @trusted;
}

/**
 * Mixin template to implement registerWith for derived classes
 */
mixin template RegisterAnnotated() {
  override void registerWith(DEventDispatcher dispatcher) @trusted {
    registerAnnotatedListeners!(typeof(this))(this, dispatcher);
  }
}

unittest {
  mixin(ShowTest!"Testing annotated event handlers...");

  import uim.events.dispatcher : EventDispatcher;
  import uim.events.event : Event;

  class TestHandler : DAnnotatedEventHandler {
    mixin RegisterAnnotated;

    int loginCount = 0;
    int logoutCount = 0;
    int priorityOrder = 0;

    @EventListener("user.login", 0)
    void onUserLogin(IEvent event) {
      loginCount++;
    }

    @EventListenerOnce("user.logout")
    void onUserLogout(IEvent event) {
      logoutCount++;
    }

    @EventListener("priority.test", 10)
    void highPriority(IEvent event) {
      priorityOrder = 1;
    }

    @EventListener("priority.test", 0)
    void normalPriority(IEvent event) {
      if (priorityOrder == 1)
        priorityOrder = 2;
    }
  }

  auto dispatcher = EventDispatcher();
  auto handler = new TestHandler();
  handler.registerWith(dispatcher);

  // Test regular listener
  dispatcher.dispatch(Event("user.login"));
  assert(handler.loginCount == 1);

  dispatcher.dispatch(Event("user.login"));
  assert(handler.loginCount == 2);

  // Test one-time listener
  dispatcher.dispatch(Event("user.logout"));
  assert(handler.logoutCount == 1);

  dispatcher.dispatch(Event("user.logout"));
  assert(handler.logoutCount == 1); // Should not increment

  // Test priority
  dispatcher.dispatch(Event("priority.test"));
  assert(handler.priorityOrder == 2); // Both methods executed in order

  writeln("✓ Annotated event handlers tests passed!");
}
