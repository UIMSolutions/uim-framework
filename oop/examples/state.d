module oop.examples.state;

import std.stdio;
import uim.oop.patterns.states;

void main() {
    writeln("=== State Pattern Examples ===\n");
    
    // Example 1: Traffic Light System
    writeln("1. Traffic Light State Machine:");
    auto trafficLight = new TrafficLight();
    
    writeln("   Initial state: ", trafficLight.currentState);
    
    writeln("\n   Changing lights:");
    for (int i = 0; i < 6; i++) {
        writeln("     Current: ", trafficLight.currentState);
        trafficLight.change();
    }
    
    writeln("\n   Traffic light log:");
    writeln(trafficLight.log());
    
    // Example 2: Document Workflow
    writeln("2. Document Workflow System:");
    auto document = new Document("Project Proposal v1.0");
    
    writeln("   Document: ", document.content);
    writeln("   Initial state: ", document.currentState);
    
    writeln("\n   Workflow progression:");
    writeln("     ", document.currentState, " -> Submitting for review");
    document.submit();
    writeln("     Now in: ", document.currentState);
    
    writeln("     ", document.currentState, " -> Approving for publication");
    document.submit();
    writeln("     Now in: ", document.currentState);
    
    writeln("     ", document.currentState, " -> Archiving");
    document.submit();
    writeln("     Now in: ", document.currentState);
    
    writeln("\n   State history:");
    foreach (state; document.stateHistory()) {
        writeln("     - ", state);
    }
    writeln();
    
    // Example 3: TCP Connection State Machine
    writeln("3. TCP Connection State Machine:");
    auto connection = new TCPConnection();
    
    writeln("   Initial state: ", connection.currentState);
    
    writeln("\n   Opening connection:");
    connection.open();
    writeln("     State: ", connection.currentState);
    
    writeln("\n   Acknowledging connection:");
    connection.acknowledge();
    writeln("     State: ", connection.currentState);
    
    writeln("\n   Closing connection:");
    connection.close();
    writeln("     State: ", connection.currentState);
    
    writeln("\n   Connection events:");
    foreach (event; connection.events()) {
        writeln("     - ", event);
    }
    writeln();
    
    // Example 4: Generic State Machine
    writeln("4. Generic State Machine with Transitions:");
    auto stateMachine = new StateMachine();
    
    // Define states for a vending machine
    class IdleState : BaseState {
        this() @safe { super("Idle"); }
        override void handle() {}
    }
    
    class HasMoneyState : BaseState {
        this() @safe { super("HasMoney"); }
        override void handle() {}
    }
    
    class DispensingState : BaseState {
        this() @safe { super("Dispensing"); }
        override void handle() {}
    }
    
    class OutOfStockState : BaseState {
        this() @safe { super("OutOfStock"); }
        override void handle() {}
    }
    
    // Register states
    stateMachine.registerState(new IdleState());
    stateMachine.registerState(new HasMoneyState());
    stateMachine.registerState(new DispensingState());
    stateMachine.registerState(new OutOfStockState());
    
    // Define allowed transitions
    writeln("   Setting up vending machine states...");
    stateMachine.allowTransition("Idle", "HasMoney");
    stateMachine.allowTransition("HasMoney", "Dispensing");
    stateMachine.allowTransition("HasMoney", "Idle");
    stateMachine.allowTransition("Dispensing", "Idle");
    stateMachine.allowTransition("Dispensing", "OutOfStock");
    
    stateMachine.setInitialState("Idle");
    writeln("   Initial state: ", stateMachine.currentState);
    
    writeln("\n   Available states:");
    foreach (state; stateMachine.availableStates()) {
        writeln("     - ", state);
    }
    
    writeln("\n   Transaction flow:");
    writeln("     Current: ", stateMachine.currentState);
    
    writeln("     Insert money...");
    if (stateMachine.transitionTo("HasMoney")) {
        writeln("     Transition to: ", stateMachine.currentState);
    }
    
    writeln("     Available next states:");
    foreach (state; stateMachine.availableTransitions()) {
        writeln("       - ", state);
    }
    
    writeln("     Select product...");
    if (stateMachine.transitionTo("Dispensing")) {
        writeln("     Transition to: ", stateMachine.currentState);
    }
    
    writeln("     Dispense complete...");
    if (stateMachine.transitionTo("Idle")) {
        writeln("     Transition to: ", stateMachine.currentState);
    }
    writeln();
    
    // Example 5: Order Processing State Machine
    writeln("5. Order Processing System:");
    auto orderMachine = new StateMachine();
    
    class NewOrderState : BaseState {
        this() @safe { super("New"); }
        override void handle() {}
    }
    
    class ProcessingState : BaseState {
        this() @safe { super("Processing"); }
        override void handle() {}
    }
    
    class ShippedState : BaseState {
        this() @safe { super("Shipped"); }
        override void handle() {}
    }
    
    class DeliveredState : BaseState {
        this() @safe { super("Delivered"); }
        override void handle() {}
    }
    
    class CancelledState : BaseState {
        this() @safe { super("Cancelled"); }
        override void handle() {}
    }
    
    orderMachine.registerState(new NewOrderState());
    orderMachine.registerState(new ProcessingState());
    orderMachine.registerState(new ShippedState());
    orderMachine.registerState(new DeliveredState());
    orderMachine.registerState(new CancelledState());
    
    // Set up transitions
    orderMachine.allowTransition("New", "Processing");
    orderMachine.allowTransition("New", "Cancelled");
    orderMachine.allowTransition("Processing", "Shipped");
    orderMachine.allowTransition("Processing", "Cancelled");
    orderMachine.allowTransition("Shipped", "Delivered");
    
    orderMachine.setInitialState("New");
    
    writeln("   Order #12345");
    writeln("   Status: ", orderMachine.currentState);
    
    writeln("\n   Processing order...");
    orderMachine.transitionTo("Processing");
    writeln("   Status: ", orderMachine.currentState);
    
    writeln("\n   Shipping order...");
    orderMachine.transitionTo("Shipped");
    writeln("   Status: ", orderMachine.currentState);
    
    writeln("\n   Order delivered!");
    orderMachine.transitionTo("Delivered");
    writeln("   Status: ", orderMachine.currentState);
    writeln();
    
    // Example 6: Context with State Changes
    writeln("6. Context-Based State Management:");
    
    class LightOffState : BaseState {
        this() @safe { super("Off"); }
        override void handle() {
            writeln("     [State] Lights are OFF");
        }
    }
    
    class LightOnState : BaseState {
        this() @safe { super("On"); }
        override void handle() {
            writeln("     [State] Lights are ON");
        }
    }
    
    class LightDimState : BaseState {
        this() @safe { super("Dimmed"); }
        override void handle() {
            writeln("     [State] Lights are DIMMED");
        }
    }
    
    auto context = new Context(new LightOffState());
    
    writeln("   Light control system");
    writeln("   Current state: ", context.state.name);
    context.request();
    
    writeln("\n   Turning on lights...");
    context.state = new LightOnState();
    writeln("   Current state: ", context.state.name);
    context.request();
    
    writeln("\n   Dimming lights...");
    context.state = new LightDimState();
    writeln("   Current state: ", context.state.name);
    context.request();
    
    writeln("\n   State history:");
    foreach (i, state; context.history()) {
        writeln("     ", i + 1, ". ", state);
    }
    writeln();
    
    // Example 7: Benefits of State Pattern
    writeln("7. Benefits of State Pattern:");
    writeln("   ✓ Encapsulates state-specific behavior");
    writeln("   ✓ Makes state transitions explicit");
    writeln("   ✓ Simplifies context code");
    writeln("   ✓ Easy to add new states");
    writeln("   ✓ Eliminates large conditional statements");
    writeln("   ✓ Makes state-dependent behavior reusable");
    writeln();
    
    writeln("   Without State Pattern:");
    writeln("   - Large if/else or switch statements");
    writeln("   - State logic scattered throughout code");
    writeln("   - Hard to add new states");
    writeln("   - Error-prone state management");
    writeln();
    
    writeln("   With State Pattern:");
    writeln("   - Each state is a separate class");
    writeln("   - State logic is encapsulated");
    writeln("   - New states are just new classes");
    writeln("   - Context delegates to current state");
    writeln();
    
    // Example 8: Real-world Scenario - Player States in a Game
    writeln("8. Game Player State Example:");
    auto playerMachine = new StateMachine();
    
    class StandingState : BaseState {
        this() @safe { super("Standing"); }
        override void handle() {}
    }
    
    class RunningState : BaseState {
        this() @safe { super("Running"); }
        override void handle() {}
    }
    
    class JumpingState : BaseState {
        this() @safe { super("Jumping"); }
        override void handle() {}
    }
    
    class CrouchingState : BaseState {
        this() @safe { super("Crouching"); }
        override void handle() {}
    }
    
    playerMachine.registerState(new StandingState());
    playerMachine.registerState(new RunningState());
    playerMachine.registerState(new JumpingState());
    playerMachine.registerState(new CrouchingState());
    
    playerMachine.allowTransition("Standing", "Running");
    playerMachine.allowTransition("Standing", "Jumping");
    playerMachine.allowTransition("Standing", "Crouching");
    playerMachine.allowTransition("Running", "Standing");
    playerMachine.allowTransition("Running", "Jumping");
    playerMachine.allowTransition("Jumping", "Standing");
    playerMachine.allowTransition("Crouching", "Standing");
    
    playerMachine.setInitialState("Standing");
    
    writeln("   Player animation state machine");
    writeln("   Initial: ", playerMachine.currentState);
    
    writeln("\n   Player actions:");
    writeln("     Press W -> Running");
    playerMachine.transitionTo("Running");
    writeln("     State: ", playerMachine.currentState);
    
    writeln("     Press Space -> Jumping");
    playerMachine.transitionTo("Jumping");
    writeln("     State: ", playerMachine.currentState);
    
    writeln("     Land -> Standing");
    playerMachine.transitionTo("Standing");
    writeln("     State: ", playerMachine.currentState);
    
    writeln("     Press Ctrl -> Crouching");
    playerMachine.transitionTo("Crouching");
    writeln("     State: ", playerMachine.currentState);
}
