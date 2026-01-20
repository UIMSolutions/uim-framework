/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.states.state;

import uim.oop.patterns.states.interfaces;
import std.format;
import std.algorithm : canFind, remove;

/**
 * Abstract base state that provides common functionality.
 */
abstract class BaseState : IState {
    protected string _name;
    
    this(string stateName) @safe {
        _name = stateName;
    }
    
    @safe string name() const {
        return _name;
    }
    
    abstract void handle();
}

/**
 * Basic context implementation that maintains a state.
 */
class Context : IContext {
    private IState _currentState;
    private string[] _history;
    
    this(IState initialState) @safe {
        _currentState = initialState;
        _history ~= initialState.name;
    }
    
    IState state() const @trusted {
        return cast(IState)_currentState;
    }
    
    @safe void state(IState newState) {
        _currentState = newState;
        _history ~= newState.name;
    }
    
    @safe void request() {
        if (_currentState !is null) {
            _currentState.handle();
        }
    }
    
    @safe string[] history() const {
        return _history.dup;
    }
}

/**
 * State machine implementation with transition management.
 */
class StateMachine : IStateMachine {
    private IState _currentState;
    private IState[string] _states;
    private bool[string][string] _transitions; // [from][to] = allowed
    
    this() @safe {
    }
    
    /**
     * Registers a state with the state machine.
     */
    @safe void registerState(IState state) {
        _states[state.name] = state;
    }
    
    /**
     * Allows a transition from one state to another.
     */
    @safe void allowTransition(string fromState, string toState) {
        if (fromState !in _transitions) {
            _transitions[fromState] = null;
        }
        _transitions[fromState][toState] = true;
    }
    
    /**
     * Sets the initial state.
     */
    @safe void setInitialState(string stateName) {
        if (stateName in _states) {
            _currentState = _states[stateName];
        }
    }
    
    @safe string currentState() const {
        return _currentState !is null ? _currentState.name : "";
    }
    
    @safe bool transitionTo(string stateName) {
        if (!canTransitionTo(stateName)) {
            return false;
        }
        
        if (stateName in _states) {
            _currentState = _states[stateName];
            return true;
        }
        
        return false;
    }
    
    @safe bool canTransitionTo(string stateName) const {
        if (_currentState is null) {
            return false;
        }
        
        string current = _currentState.name;
        if (current !in _transitions) {
            return false;
        }
        
        return (stateName in _transitions[current]) !is null;
    }
    
    @safe string[] availableStates() const {
        return _states.keys.dup;
    }
    
    /**
     * Gets states that can be transitioned to from the current state.
     */
    @safe string[] availableTransitions() const {
        if (_currentState is null) {
            return [];
        }
        
        string current = _currentState.name;
        if (current !in _transitions) {
            return [];
        }
        
        return _transitions[current].keys.dup;
    }
}

/**
 * Abstract lifecycle state with enter/exit callbacks.
 */
abstract class LifecycleState : BaseState, ILifecycleState {
    this(string stateName) @safe {
        super(stateName);
    }
    
    @safe void onEnter() {
        // Override in subclasses
    }
    
    @safe void onExit() {
        // Override in subclasses
    }
}

/**
 * Context that supports lifecycle states.
 */
class LifecycleContext : Context {
    this(ILifecycleState initialState) @safe {
        super(initialState);
        initialState.onEnter();
    }
    
    override @safe void state(IState newState) {
        auto currentLifecycle = cast(ILifecycleState)_currentState;
        if (currentLifecycle !is null) {
            currentLifecycle.onExit();
        }
        
        super.state(newState);
        
        auto newLifecycle = cast(ILifecycleState)newState;
        if (newLifecycle !is null) {
            newLifecycle.onEnter();
        }
    }
}

// Real-world example: Traffic Light

/**
 * Traffic light context.
 */
class TrafficLight {
    private IState _currentState;
    private string _log;
    
    this() @safe {
        _currentState = new RedLightState(this);
    }
    
    @safe void setState(IState state) {
        _currentState = state;
    }
    
    @safe void change() {
        _currentState.handle();
    }
    
    @safe string currentState() const {
        return _currentState.name;
    }
    
    @safe void addLog(string message) {
        _log ~= message ~ "\n";
    }
    
    @safe string log() const {
        return _log;
    }
}

/**
 * Red light state - cars must stop.
 */
class RedLightState : BaseState {
    private TrafficLight _light;
    
    this(TrafficLight light) @safe {
        super("Red");
        _light = light;
    }
    
    override @safe void handle() {
        _light.addLog("Red light - STOP");
        _light.setState(new GreenLightState(_light));
    }
}

/**
 * Green light state - cars can go.
 */
class GreenLightState : BaseState {
    private TrafficLight _light;
    
    this(TrafficLight light) @safe {
        super("Green");
        _light = light;
    }
    
    override @safe void handle() {
        _light.addLog("Green light - GO");
        _light.setState(new YellowLightState(_light));
    }
}

/**
 * Yellow light state - cars should prepare to stop.
 */
class YellowLightState : BaseState {
    private TrafficLight _light;
    
    this(TrafficLight light) @safe {
        super("Yellow");
        _light = light;
    }
    
    override @safe void handle() {
        _light.addLog("Yellow light - CAUTION");
        _light.setState(new RedLightState(_light));
    }
}

// Real-world example: Document Workflow

/**
 * Document in a workflow system.
 */
class Document {
    private ILifecycleState _currentState;
    private string _content;
    private string[] _stateHistory;
    
    this(string content) @safe {
        _content = content;
        auto draftState = new DraftState(this);
        _currentState = draftState;
        draftState.onEnter();
        _stateHistory ~= "Draft";
    }
    
    @safe void setState(ILifecycleState state) {
        _currentState.onExit();
        _currentState = state;
        state.onEnter();
        _stateHistory ~= state.name;
    }
    
    @safe void submit() {
        _currentState.handle();
    }
    
    @safe string currentState() const {
        return _currentState.name;
    }
    
    @safe string content() const {
        return _content;
    }
    
    @safe string[] stateHistory() const {
        return _stateHistory.dup;
    }
}

/**
 * Draft state - document is being edited.
 */
class DraftState : LifecycleState {
    private Document _document;
    
    this(Document doc) @safe {
        super("Draft");
        _document = doc;
    }
    
    override @safe void handle() {
        _document.setState(new ReviewState(_document));
    }
    
    override @safe void onEnter() {
        // Document is now editable
    }
    
    override @safe void onExit() {
        // Lock document for editing
    }
}

/**
 * Review state - document is under review.
 */
class ReviewState : LifecycleState {
    private Document _document;
    
    this(Document doc) @safe {
        super("Review");
        _document = doc;
    }
    
    override @safe void handle() {
        _document.setState(new PublishedState(_document));
    }
    
    override @safe void onEnter() {
        // Notify reviewers
    }
    
    override @safe void onExit() {
        // Clear review assignments
    }
}

/**
 * Published state - document is published.
 */
class PublishedState : LifecycleState {
    private Document _document;
    
    this(Document doc) @safe {
        super("Published");
        _document = doc;
    }
    
    override @safe void handle() {
        _document.setState(new ArchivedState(_document));
    }
    
    override @safe void onEnter() {
        // Make document publicly available
    }
    
    override @safe void onExit() {
        // Unpublish document
    }
}

/**
 * Archived state - document is archived.
 */
class ArchivedState : LifecycleState {
    private Document _document;
    
    this(Document doc) @safe {
        super("Archived");
        _document = doc;
    }
    
    override @safe void handle() {
        // Cannot transition from archived
    }
    
    override @safe void onEnter() {
        // Move to archive storage
    }
    
    override @safe void onExit() {
        // Restore from archive
    }
}

// Real-world example: TCP Connection

/**
 * TCP connection state machine.
 */
class TCPConnection {
    private IState _currentState;
    private string[] _events;
    
    this() @safe {
        _currentState = new ClosedState(this);
    }
    
    @safe void setState(IState state) {
        _currentState = state;
    }
    
    @safe void open() {
        addEvent("open()");
        if (auto s = cast(ClosedState)_currentState) {
            setState(new ListenState(this));
        }
    }
    
    @safe void close() {
        addEvent("close()");
        setState(new ClosedState(this));
    }
    
    @safe void acknowledge() {
        addEvent("acknowledge()");
        if (auto s = cast(ListenState)_currentState) {
            setState(new EstablishedState(this));
        }
    }
    
    @safe string currentState() const {
        return _currentState.name;
    }
    
    @safe string[] events() const {
        return _events.dup;
    }
    
    private void addEvent(string event) @safe {
        _events ~= event;
    }
}

/**
 * Closed TCP state.
 */
class ClosedState : BaseState {
    private TCPConnection _connection;
    
    this(TCPConnection conn) @safe {
        super("Closed");
        _connection = conn;
    }
    
    override @safe void handle() {
        // Stay closed
    }
}

/**
 * Listen TCP state - waiting for connection.
 */
class ListenState : BaseState {
    private TCPConnection _connection;
    
    this(TCPConnection conn) @safe {
        super("Listen");
        _connection = conn;
    }
    
    override @safe void handle() {
        // Listening for connections
    }
}

/**
 * Established TCP state - connection is active.
 */
class EstablishedState : BaseState {
    private TCPConnection _connection;
    
    this(TCPConnection conn) @safe {
        super("Established");
        _connection = conn;
    }
    
    override @safe void handle() {
        // Connection is active
    }
}

// Unit tests

@safe unittest {
    // Test basic state
    class TestState : BaseState {
        bool _handled = false;
        
        this() @safe {
            super("TestState");
        }
        
        override void handle() {
            _handled = true;
        }
    }
    
    auto state = new TestState();
    assert(state.name == "TestState");
    state.handle();
    assert(state._handled);
}

@safe unittest {
    // Test context
    class StateA : BaseState {
        this() @safe { super("A"); }
        override void handle() {}
    }
    
    class StateB : BaseState {
        this() @safe { super("B"); }
        override void handle() {}
    }
    
    auto stateA = new StateA();
    auto context = new Context(stateA);
    
    assert(context.state.name == "A");
    
    auto stateB = new StateB();
    context.state = stateB;
    
    assert(context.state.name == "B");
    assert(context.history.length == 2);
}

@safe unittest {
    // Test state machine
    class State1 : BaseState {
        this() @safe { super("State1"); }
        override void handle() {}
    }
    
    class State2 : BaseState {
        this() @safe { super("State2"); }
        override void handle() {}
    }
    
    auto machine = new StateMachine();
    auto state1 = new State1();
    auto state2 = new State2();
    
    machine.registerState(state1);
    machine.registerState(state2);
    
    machine.allowTransition("State1", "State2");
    machine.setInitialState("State1");
    
    assert(machine.currentState == "State1");
    assert(machine.canTransitionTo("State2"));
    assert(!machine.canTransitionTo("State3"));
    
    bool success = machine.transitionTo("State2");
    assert(success);
    assert(machine.currentState == "State2");
}

@safe unittest {
    // Test traffic light
    auto light = new TrafficLight();
    
    assert(light.currentState == "Red");
    
    light.change();
    assert(light.currentState == "Green");
    
    light.change();
    assert(light.currentState == "Yellow");
    
    light.change();
    assert(light.currentState == "Red");
}

@safe unittest {
    // Test document workflow
    auto doc = new Document("Test content");
    
    assert(doc.currentState == "Draft");
    
    doc.submit();
    assert(doc.currentState == "Review");
    
    doc.submit();
    assert(doc.currentState == "Published");
    
    doc.submit();
    assert(doc.currentState == "Archived");
    
    assert(doc.stateHistory.length == 4);
}

@safe unittest {
    // Test TCP connection
    auto conn = new TCPConnection();
    
    assert(conn.currentState == "Closed");
    
    conn.open();
    assert(conn.currentState == "Listen");
    
    conn.acknowledge();
    assert(conn.currentState == "Established");
    
    conn.close();
    assert(conn.currentState == "Closed");
}

@safe unittest {
    // Test lifecycle state transitions
    auto doc = new Document("Content");
    auto history = doc.stateHistory();
    
    assert(history.length >= 1);
    assert(history[0] == "Draft");
}

@safe unittest {
    // Test state machine available transitions
    auto machine = new StateMachine();
    
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
    
    machine.registerState(new SA());
    machine.registerState(new SB());
    machine.registerState(new SC());
    
    machine.allowTransition("A", "B");
    machine.allowTransition("A", "C");
    machine.allowTransition("B", "C");
    
    machine.setInitialState("A");
    
    auto available = machine.availableTransitions();
    assert(available.length == 2);
    assert(available.canFind("B"));
    assert(available.canFind("C"));
}
