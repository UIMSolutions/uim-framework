/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.events.attributes;

import uim.core;
import uim.oop;

@safe:

/**
 * UDA to mark a method as an event listener
 * Usage: @EventListener("event.name")
 */
struct EventListener {
    string eventName;
    int priority = 0;
    
    this(string name, int prio = 0) {
        eventName = name;
        priority = prio;
    }
}

/**
 * UDA to mark a method as a one-time event listener
 * Usage: @EventListenerOnce("event.name")
 */
struct EventListenerOnce {
    string eventName;
    int priority = 0;
    
    this(string name, int prio = 0) {
        eventName = name;
        priority = prio;
    }
}

/**
 * UDA to specify listener priority
 * Usage: @Priority(10)
 */
struct Priority {
    int value;
    
    this(int val) {
        value = val;
    }
}

/**
 * UDA to mark an event handler that should run asynchronously
 * Usage: @Async
 */
struct Async {
}

/**
 * UDA to mark an event class
 * Usage: @Event("event.name")
 */
struct Event {
    string name;
    
    this(string eventName) {
        name = eventName;
    }
}

/**
 * Helper function to check if a type has an Event UDA
 */
template hasEventAttribute(T) {
    import std.traits : hasUDA;
    enum hasEventAttribute = hasUDA!(T, Event);
}

/**
 * Helper function to get the event name from an Event UDA
 */
template getEventName(T) {
    import std.traits : getUDAs;
    
    static if (hasEventAttribute!T) {
        enum getEventName = getUDAs!(T, Event)[0].name;
    } else {
        enum getEventName = "";
    }
}

/**
 * Helper function to check if a member has an EventListener UDA
 */
template hasListenerAttribute(alias member) {
    import std.traits : hasUDA;
    enum hasListenerAttribute = hasUDA!(member, EventListener);
}

/**
 * Helper function to check if a member has an EventListenerOnce UDA
 */
template hasListenerOnceAttribute(alias member) {
    import std.traits : hasUDA;
    enum hasListenerOnceAttribute = hasUDA!(member, EventListenerOnce);
}

/**
 * Helper function to get EventListener UDA data
 */
template getListenerAttribute(alias member) {
    import std.traits : getUDAs;
    
    static if (hasListenerAttribute!member) {
        alias getListenerAttribute = getUDAs!(member, EventListener)[0];
    }
}

/**
 * Helper function to get EventListenerOnce UDA data
 */
template getListenerOnceAttribute(alias member) {
    import std.traits : getUDAs;
    
    static if (hasListenerOnceAttribute!member) {
        alias getListenerOnceAttribute = getUDAs!(member, EventListenerOnce)[0];
    }
}

unittest {
    import uim.events.event : DEvent;
    
    writeln("Testing UDA attributes...");
    
    @Event("test.event")
    class TestEvent : DEvent {
        this() { super("test.event"); }
    }
    
    assert(hasEventAttribute!TestEvent);
    assert(getEventName!TestEvent == "test.event");
    
    writeln("✓ UDA attributes tests passed!");
}
