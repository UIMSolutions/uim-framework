module oop.examples.mediator;

import std.stdio;
import uim.oop.patterns.mediators;

void main() {
    writeln("=== Mediator Pattern Examples ===\n");
    
    // Example 1: Chat Room Mediator
    writeln("1. Chat Room Mediator:");
    auto chatRoom = new ChatRoom();
    
    auto alice = new User("Alice");
    auto bob = new User("Bob");
    auto charlie = new User("Charlie");
    auto diana = new User("Diana");
    
    chatRoom.registerUser(alice);
    chatRoom.registerUser(bob);
    chatRoom.registerUser(charlie);
    chatRoom.registerUser(diana);
    
    writeln("   Users in chat room: ", chatRoom.userCount());
    
    writeln("\n   Broadcasting messages:");
    alice.sendMessage("all", "Hello everyone!");
    bob.sendMessage("all", "Hi Alice!");
    
    writeln("\n   Private messaging:");
    charlie.sendMessage("Alice", "Hey Alice, can we talk?");
    diana.sendMessage("Bob", "Bob, check your email");
    
    writeln("\n   Bob's received messages:");
    foreach (msg; bob.receivedMessages()) {
        writeln("     ", msg);
    }
    
    writeln("\n   Alice's received messages:");
    foreach (msg; alice.receivedMessages()) {
        writeln("     ", msg);
    }
    
    writeln("\n   Chat room log:");
    foreach (msg; chatRoom.messageLog()) {
        writeln("     ", msg);
    }
    writeln();
    
    // Example 2: Air Traffic Control
    writeln("2. Air Traffic Control Mediator:");
    auto atc = new AirTrafficControl();
    
    auto flight1 = new Aircraft("UA123");
    auto flight2 = new Aircraft("DL456");
    auto flight3 = new Aircraft("AA789");
    
    atc.registerAircraft(flight1);
    atc.registerAircraft(flight2);
    atc.registerAircraft(flight3);
    
    writeln("   Aircraft registered: ", atc.aircraftCount());
    
    writeln("\n   Flight operations:");
    flight1.reportPosition("50 miles east, altitude 35,000 feet");
    flight1.requestLanding();
    
    flight2.reportPosition("Holding pattern at waypoint BRAVO");
    flight2.requestTakeoff();
    
    flight3.reportPosition("On final approach");
    flight3.requestLanding();
    
    writeln("\n   UA123 clearances:");
    foreach (clearance; flight1.receivedClearances()) {
        writeln("     ", clearance);
    }
    
    writeln("\n   ATC Communication Log:");
    foreach (entry; atc.communicationLog()) {
        writeln("     ", entry);
    }
    writeln();
    
    // Example 3: UI Dialog Mediator
    writeln("3. UI Dialog Mediator (Form Validation):");
    auto dialogMediator = new DialogMediator();
    
    auto submitButton = new Button("submit");
    auto cancelButton = new Button("cancel");
    auto nameInput = new TextBox("name");
    auto emailInput = new TextBox("email");
    auto agreeCheckbox = new CheckBox("agree");
    
    dialogMediator.setSubmitButton(submitButton);
    dialogMediator.setCancelButton(cancelButton);
    dialogMediator.setNameInput(nameInput);
    dialogMediator.setAgreeCheckbox(agreeCheckbox);
    
    writeln("   Initial state:");
    writeln("     Submit button enabled: ", submitButton.enabled);
    
    writeln("\n   User enters name:");
    nameInput.text = "John Doe";
    writeln("     Submit button enabled: ", submitButton.enabled);
    
    writeln("\n   User checks agreement:");
    agreeCheckbox.isChecked = true;
    writeln("     Submit button enabled: ", submitButton.enabled);
    
    writeln("\n   User clears name:");
    nameInput.text = "";
    writeln("     Submit button enabled: ", submitButton.enabled);
    
    writeln("\n   User re-enters name:");
    nameInput.text = "Jane Smith";
    writeln("     Submit button enabled: ", submitButton.enabled);
    writeln();
    
    // Example 4: Generic Mediator
    writeln("4. Generic String Mediator:");
    auto genericMediator = new GenericMediator!string();
    
    writeln("   Setting up message handlers...");
    
    genericMediator.register("Logger", (string sender, string message) @safe {
        writeln("     [Logger] ", sender, ": ", message);
    });
    
    genericMediator.register("Validator", (string sender, string message) @safe {
        writeln("     [Validator] Received from ", sender, ": '", message, "'");
    });
    
    genericMediator.register("Storage", (string sender, string message) @safe {
        writeln("     [Storage] Storing message from ", sender);
    });
    
    writeln("\n   Sending message:");
    genericMediator.send("Controller", "User action performed");
    
    writeln("\n   Handler count: ", genericMediator.handlerCount());
    writeln();
    
    // Example 5: Event Mediator
    writeln("5. Event-Based Mediator:");
    auto eventMediator = new EventMediator();
    
    writeln("   Subscribing to events...");
    
    int loginCount = 0;
    eventMediator.subscribe("userLogin", (string data) @safe {
        loginCount++;
        writeln("     [Auth] User logged in: ", data);
    });
    
    eventMediator.subscribe("userLogin", (string data) @safe {
        writeln("     [Analytics] Recording login for: ", data);
    });
    
    eventMediator.subscribe("userLogout", (string data) @safe {
        writeln("     [Auth] User logged out: ", data);
    });
    
    writeln("\n   Publishing events:");
    eventMediator.publish("userLogin", "alice@example.com");
    eventMediator.publish("userLogin", "bob@example.com");
    eventMediator.publish("userLogout", "alice@example.com");
    
    writeln("\n   Total logins recorded: ", loginCount);
    writeln("   Subscribers to 'userLogin': ", eventMediator.subscriberCount("userLogin"));
    writeln();
    
    // Example 6: Request-Response Mediator
    writeln("6. Request-Response Mediator:");
    auto rrMediator = new RequestResponseMediator();
    
    writeln("   Registering request handlers...");
    
    rrMediator.registerHandler("getUser", (string id) @safe {
        return "User{id: " ~ id ~ ", name: 'John Doe'}";
    });
    
    rrMediator.registerHandler("calculateTotal", (string items) @safe {
        return "Total: $125.50";
    });
    
    rrMediator.registerHandler("validateEmail", (string email) @safe {
        return email.indexOf("@") > 0 ? "Valid" : "Invalid";
    });
    
    writeln("\n   Making requests:");
    writeln("     ", rrMediator.request("getUser", "12345"));
    writeln("     ", rrMediator.request("calculateTotal", "item1,item2,item3"));
    writeln("     ", rrMediator.request("validateEmail", "test@example.com"));
    writeln("     ", rrMediator.request("validateEmail", "invalid-email"));
    writeln();
    
    // Example 7: Complex Chat Scenario
    writeln("7. Complex Chat Scenario:");
    auto workChat = new ChatRoom();
    
    auto manager = new User("Manager");
    auto dev1 = new User("Dev1");
    auto dev2 = new User("Dev2");
    auto designer = new User("Designer");
    
    workChat.registerUser(manager);
    workChat.registerUser(dev1);
    workChat.registerUser(dev2);
    workChat.registerUser(designer);
    
    writeln("   Team members: ", workChat.userCount());
    
    manager.sendMessage("all", "Team meeting at 3 PM");
    dev1.sendMessage("Dev2", "Can you review my PR?");
    dev2.sendMessage("Dev1", "Sure, I'll check it out");
    designer.sendMessage("all", "New mockups are ready");
    manager.sendMessage("Designer", "Great work on the UI!");
    
    writeln("\n   Dev1's inbox (", dev1.receivedMessages().length, " messages):");
    foreach (msg; dev1.receivedMessages()) {
        writeln("     ", msg);
    }
    
    writeln("\n   Designer's inbox (", designer.receivedMessages().length, " messages):");
    foreach (msg; designer.receivedMessages()) {
        writeln("     ", msg);
    }
    writeln();
    
    // Example 8: Benefits of Mediator Pattern
    writeln("8. Benefits of Mediator Pattern:");
    writeln("   ✓ Reduced coupling between components");
    writeln("   ✓ Centralized control logic");
    writeln("   ✓ Easier to add new components");
    writeln("   ✓ Simplified object protocols");
    writeln("   ✓ Components don't need to know about each other");
    writeln();
    
    writeln("   Without Mediator:");
    writeln("   - Each component needs references to all others");
    writeln("   - N components = N*(N-1) potential connections");
    writeln("   - Hard to maintain and extend");
    writeln();
    
    writeln("   With Mediator:");
    writeln("   - Components only know the mediator");
    writeln("   - N components = N connections to mediator");
    writeln("   - Easy to add/remove components");
}

import std.string : indexOf;
