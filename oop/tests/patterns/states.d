module oop.tests.patterns.states;

import uim.oop.patterns.states;

@safe unittest {
    // Test base state creation
    class SimpleState : BaseState {
        this() @safe { super("SimpleState"); }
        override void handle() {}
    }
    
    auto state = new SimpleState();
    assert(state !is null);
    assert(state.name == "SimpleState");
}

@safe unittest {
    // Test state name property
    class NamedState : BaseState {
        this(string name) @safe { super(name); }
        override void handle() {}
    }
    
    auto state = new NamedState("TestState");
    assert(state.name == "TestState");
}

@safe unittest {
    // Test context with initial state
    class InitialState : BaseState {
        this() @safe { super("Initial"); }
        override void handle() {}
    }
    
    auto initialState = new InitialState();
    auto context = new Context(initialState);
    
    assert(context.state !is null);
    assert(context.state.name == "Initial");
}

@safe unittest {
    // Test state transition in context
    class StateOne : BaseState {
        this() @safe { super("One"); }
        override void handle() {}
    }
    
    class StateTwo : BaseState {
        this() @safe { super("Two"); }
        override void handle() {}
    }
    
    auto state1 = new StateOne();
    auto state2 = new StateTwo();
    auto context = new Context(state1);
    
    assert(context.state.name == "One");
    
    context.state = state2;
    assert(context.state.name == "Two");
}

@safe unittest {
    // Test context history tracking
    class SA : BaseState {
        this() @safe { super("A"); }
        override void handle() {}
    }
    
    class SB : BaseState {
        this() @safe { super("B"); }
        override void handle() {}
    }
    
    class SC : BaseState {
        this() @safe { super("C"); }
        override void handle() {}
    }
    
    auto context = new Context(new SA());
    context.state = new SB();
    context.state = new SC();
    
    auto history = context.history();
    assert(history.length == 3);
    assert(history[0] == "A");
    assert(history[1] == "B");
    assert(history[2] == "C");
}

@safe unittest {
    // Test state machine creation
    auto machine = new StateMachine();
    assert(machine !is null);
    assert(machine.currentState == "");
}

@safe unittest {
    // Test state machine register state
    class State1 : BaseState {
        this() @safe { super("State1"); }
        override void handle() {}
    }
    
    auto machine = new StateMachine();
    auto state1 = new State1();
    
    machine.registerState(state1);
    
    auto available = machine.availableStates();
    assert(available.length == 1);
    assert(available[0] == "State1");
}

@safe unittest {
    // Test state machine initial state
    class InitState : BaseState {
        this() @safe { super("Init"); }
        override void handle() {}
    }
    
    auto machine = new StateMachine();
    machine.registerState(new InitState());
    machine.setInitialState("Init");
    
    assert(machine.currentState == "Init");
}

@safe unittest {
    // Test state machine transitions
    class Alpha : BaseState {
        this() @safe { super("Alpha"); }
        override void handle() {}
    }
    
    class Beta : BaseState {
        this() @safe { super("Beta"); }
        override void handle() {}
    }
    
    auto machine = new StateMachine();
    machine.registerState(new Alpha());
    machine.registerState(new Beta());
    
    machine.allowTransition("Alpha", "Beta");
    machine.setInitialState("Alpha");
    
    assert(machine.canTransitionTo("Beta"));
    assert(!machine.canTransitionTo("Gamma"));
}

@safe unittest {
    // Test state machine transition execution
    class S1 : BaseState {
        this() @safe { super("S1"); }
        override void handle() {}
    }
    
    class S2 : BaseState {
        this() @safe { super("S2"); }
        override void handle() {}
    }
    
    auto machine = new StateMachine();
    machine.registerState(new S1());
    machine.registerState(new S2());
    
    machine.allowTransition("S1", "S2");
    machine.setInitialState("S1");
    
    bool success = machine.transitionTo("S2");
    assert(success);
    assert(machine.currentState == "S2");
}

@safe unittest {
    // Test invalid transition
    class Valid : BaseState {
        this() @safe { super("Valid"); }
        override void handle() {}
    }
    
    auto machine = new StateMachine();
    machine.registerState(new Valid());
    machine.setInitialState("Valid");
    
    bool success = machine.transitionTo("Invalid");
    assert(!success);
    assert(machine.currentState == "Valid");
}

@safe unittest {
    // Test traffic light red to green
    auto light = new TrafficLight();
    
    assert(light.currentState == "Red");
    light.change();
    assert(light.currentState == "Green");
}

@safe unittest {
    // Test traffic light full cycle
    auto light = new TrafficLight();
    
    light.change(); // Red -> Green
    light.change(); // Green -> Yellow
    light.change(); // Yellow -> Red
    
    assert(light.currentState == "Red");
}

@safe unittest {
    // Test traffic light logging
    auto light = new TrafficLight();
    
    light.change();
    light.change();
    
    auto log = light.log();
    assert(log.length > 0);
}

@safe unittest {
    // Test document initial state
    auto doc = new Document("Test document");
    
    assert(doc.currentState == "Draft");
    assert(doc.content == "Test document");
}

@safe unittest {
    // Test document workflow progression
    auto doc = new Document("Important doc");
    
    doc.submit(); // Draft -> Review
    assert(doc.currentState == "Review");
    
    doc.submit(); // Review -> Published
    assert(doc.currentState == "Published");
    
    doc.submit(); // Published -> Archived
    assert(doc.currentState == "Archived");
}

@safe unittest {
    // Test document state history
    auto doc = new Document("Doc");
    
    doc.submit();
    doc.submit();
    
    auto history = doc.stateHistory();
    assert(history.length >= 3);
    assert(history[0] == "Draft");
    assert(history[1] == "Review");
    assert(history[2] == "Published");
}

@safe unittest {
    // Test TCP connection initial state
    auto conn = new TCPConnection();
    
    assert(conn.currentState == "Closed");
}

@safe unittest {
    // Test TCP connection open
    auto conn = new TCPConnection();
    
    conn.open();
    assert(conn.currentState == "Listen");
}

@safe unittest {
    // Test TCP connection establish
    auto conn = new TCPConnection();
    
    conn.open();
    conn.acknowledge();
    
    assert(conn.currentState == "Established");
}

@safe unittest {
    // Test TCP connection close
    auto conn = new TCPConnection();
    
    conn.open();
    conn.acknowledge();
    conn.close();
    
    assert(conn.currentState == "Closed");
}

@safe unittest {
    // Test TCP connection events
    auto conn = new TCPConnection();
    
    conn.open();
    conn.acknowledge();
    
    auto events = conn.events();
    assert(events.length >= 2);
}

@safe unittest {
    // Test lifecycle state enter/exit
    class TrackedState : LifecycleState {
        bool entered = false;
        bool exited = false;
        
        this() @safe { super("Tracked"); }
        
        override void handle() {}
        
        override void onEnter() {
            entered = true;
        }
        
        override void onExit() {
            exited = true;
        }
    }
    
    auto state = new TrackedState();
    state.onEnter();
    assert(state.entered);
    
    state.onExit();
    assert(state.exited);
}

@safe unittest {
    // Test multiple state registrations
    auto machine = new StateMachine();
    
    class S1 : BaseState {
        this() @safe { super("S1"); }
        override void handle() {}
    }
    
    class S2 : BaseState {
        this() @safe { super("S2"); }
        override void handle() {}
    }
    
    class S3 : BaseState {
        this() @safe { super("S3"); }
        override void handle() {}
    }
    
    machine.registerState(new S1());
    machine.registerState(new S2());
    machine.registerState(new S3());
    
    auto available = machine.availableStates();
    assert(available.length == 3);
}

@safe unittest {
    // Test state machine complex transitions
    auto machine = new StateMachine();
    
    class A : BaseState {
        this() @safe { super("A"); }
        override void handle() {}
    }
    
    class B : BaseState {
        this() @safe { super("B"); }
        override void handle() {}
    }
    
    class C : BaseState {
        this() @safe { super("C"); }
        override void handle() {}
    }
    
    machine.registerState(new A());
    machine.registerState(new B());
    machine.registerState(new C());
    
    machine.allowTransition("A", "B");
    machine.allowTransition("B", "C");
    machine.allowTransition("C", "A");
    
    machine.setInitialState("A");
    
    machine.transitionTo("B");
    assert(machine.currentState == "B");
    
    machine.transitionTo("C");
    assert(machine.currentState == "C");
    
    machine.transitionTo("A");
    assert(machine.currentState == "A");
}

@safe unittest {
    // Test state machine available transitions
    auto machine = new StateMachine();
    
    class X : BaseState {
        this() @safe { super("X"); }
        override void handle() {}
    }
    
    class Y : BaseState {
        this() @safe { super("Y"); }
        override void handle() {}
    }
    
    class Z : BaseState {
        this() @safe { super("Z"); }
        override void handle() {}
    }
    
    machine.registerState(new X());
    machine.registerState(new Y());
    machine.registerState(new Z());
    
    machine.allowTransition("X", "Y");
    machine.allowTransition("X", "Z");
    
    machine.setInitialState("X");
    
    auto available = machine.availableTransitions();
    assert(available.length == 2);
}

@safe unittest {
    // Test context request
    class HandleState : BaseState {
        bool wasHandled = false;
        
        this() @safe { super("Handle"); }
        
        override void handle() {
            wasHandled = true;
        }
    }
    
    auto state = new HandleState();
    auto context = new Context(state);
    
    context.request();
    assert(state.wasHandled);
}

@safe unittest {
    // Test traffic light multiple cycles
    auto light = new TrafficLight();
    
    for (int i = 0; i < 6; i++) {
        light.change();
    }
    
    assert(light.currentState == "Red");
}

@safe unittest {
    // Test document workflow all states
    auto doc = new Document("Full workflow test");
    
    assert(doc.currentState == "Draft");
    doc.submit();
    
    assert(doc.currentState == "Review");
    doc.submit();
    
    assert(doc.currentState == "Published");
    doc.submit();
    
    assert(doc.currentState == "Archived");
    
    auto history = doc.stateHistory();
    assert(history.length == 4);
}

@safe unittest {
    // Test TCP full connection lifecycle
    auto conn = new TCPConnection();
    
    assert(conn.currentState == "Closed");
    
    conn.open();
    assert(conn.currentState == "Listen");
    
    conn.acknowledge();
    assert(conn.currentState == "Established");
    
    conn.close();
    assert(conn.currentState == "Closed");
    
    auto events = conn.events();
    assert(events.length == 3);
}

import std.algorithm : canFind;
