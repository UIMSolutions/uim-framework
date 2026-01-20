/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.states.interfaces;

/**
 * State interface that defines behavior for a particular state.
 * All concrete states must implement this interface.
 */
interface IState {
    /**
     * Handles the current state's behavior.
     * This is the main method that gets called by the context.
     */
    @safe void handle();
    
    /**
     * Gets the state name.
     * Returns: A string identifying this state
     */
    @safe string name() const;
}

/**
 * Context interface that maintains a reference to a State object.
 * The context delegates state-specific behavior to the current State object.
 */
interface IContext {
    /**
     * Gets the current state.
     * Returns: The current state object
     */
    @safe IState state() const;
    
    /**
     * Sets the current state.
     * Params:
     *   newState = The new state to transition to
     */
    @safe void state(IState newState);
    
    /**
     * Requests the context to perform an action.
     * The behavior depends on the current state.
     */
    @safe void request();
}

/**
 * Generic state interface with typed context.
 * Provides compile-time type safety for state-context interactions.
 */
interface IGenericState(TContext) {
    /**
     * Handles the state with access to the typed context.
     * Params:
     *   context = The context object
     */
    @safe void handle(TContext context);
    
    /**
     * Gets the state name.
     * Returns: A string identifying this state
     */
    @safe string name() const;
}

/**
 * State machine interface for managing state transitions.
 * Provides a higher-level abstraction for state management.
 */
interface IStateMachine {
    /**
     * Gets the current state name.
     * Returns: The name of the current state
     */
    @safe string currentState() const;
    
    /**
     * Transitions to a new state by name.
     * Params:
     *   stateName = The name of the state to transition to
     * Returns: true if the transition was successful
     */
    @safe bool transitionTo(string stateName);
    
    /**
     * Checks if a transition to a state is valid.
     * Params:
     *   stateName = The target state name
     * Returns: true if the transition is allowed
     */
    @safe bool canTransitionTo(string stateName) const;
    
    /**
     * Gets all available states.
     * Returns: Array of state names
     */
    @safe string[] availableStates() const;
}

/**
 * Lifecycle state interface for states with enter/exit callbacks.
 */
interface ILifecycleState : IState {
    /**
     * Called when entering this state.
     */
    @safe void onEnter();
    
    /**
     * Called when exiting this state.
     */
    @safe void onExit();
}

/**
 * Hierarchical state interface for states that can have substates.
 */
interface IHierarchicalState : IState {
    /**
     * Gets the parent state, if any.
     * Returns: The parent state or null if this is a top-level state
     */
    @safe IHierarchicalState parent() const;
    
    /**
     * Gets the current substate, if any.
     * Returns: The active substate or null if no substate is active
     */
    @safe IHierarchicalState substate() const;
    
    /**
     * Sets the current substate.
     * Params:
     *   state = The substate to activate
     */
    @safe void substate(IHierarchicalState state);
}
