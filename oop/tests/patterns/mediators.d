module oop.tests.patterns.mediators;

import uim.oop.patterns.mediators;

@safe unittest {
    // Test concrete mediator creation
    auto mediator = new ConcreteMediator();
    assert(mediator !is null);
    assert(mediator.colleagueCount() == 0);
}

@safe unittest {
    // Test generic mediator with string messages
    auto mediator = new GenericMediator!string();
    
    string receivedMessage = "";
    string receivedSender = "";
    
    mediator.register("receiver1", (string sender, string message) @safe {
        receivedSender = sender;
        receivedMessage = message;
    });
    
    mediator.send("sender1", "Hello World");
    
    assert(receivedMessage == "Hello World");
    assert(receivedSender == "sender1");
}

@safe unittest {
    // Test generic mediator with multiple receivers
    auto mediator = new GenericMediator!int();
    
    int count1 = 0;
    int count2 = 0;
    
    mediator.register("receiver1", (string sender, int value) @safe {
        count1 += value;
    });
    
    mediator.register("receiver2", (string sender, int value) @safe {
        count2 += value;
    });
    
    mediator.send("sender", 5);
    
    assert(count1 == 5);
    assert(count2 == 5);
    assert(mediator.handlerCount() == 2);
}

@safe unittest {
    // Test generic mediator unregister
    auto mediator = new GenericMediator!string();
    
    mediator.register("receiver1", (string s, string m) @safe {});
    mediator.register("receiver2", (string s, string m) @safe {});
    
    assert(mediator.handlerCount() == 2);
    
    mediator.unregister("receiver1");
    assert(mediator.handlerCount() == 1);
}

@safe unittest {
    // Test event mediator subscription
    auto mediator = new EventMediator();
    
    int callCount = 0;
    mediator.subscribe("testEvent", (string data) @safe {
        callCount++;
    });
    
    assert(mediator.subscriberCount("testEvent") == 1);
}

@safe unittest {
    // Test event mediator publish
    auto mediator = new EventMediator();
    
    string receivedData = "";
    mediator.subscribe("update", (string data) @safe {
        receivedData = data;
    });
    
    mediator.publish("update", "test data");
    assert(receivedData == "test data");
}

@safe unittest {
    // Test event mediator multiple subscribers
    auto mediator = new EventMediator();
    
    int count = 0;
    mediator.subscribe("event", (string data) @safe { count++; });
    mediator.subscribe("event", (string data) @safe { count++; });
    mediator.subscribe("event", (string data) @safe { count++; });
    
    mediator.publish("event", "trigger");
    assert(count == 3);
}

@safe unittest {
    // Test request-response mediator
    auto mediator = new RequestResponseMediator();
    
    mediator.registerHandler("uppercase", (string data) @safe {
        return data.toUpper();
    });
    
    string result = mediator.request("uppercase", "hello");
    assert(result == "HELLO");
}

@safe unittest {
    // Test request-response with no handler
    auto mediator = new RequestResponseMediator();
    
    string result = mediator.request("unknown", "data");
    assert(result.length > 0);
    assert(!mediator.hasHandler("unknown"));
}

@safe unittest {
    // Test request-response multiple handlers
    auto mediator = new RequestResponseMediator();
    
    mediator.registerHandler("add", (string data) @safe {
        return "Added: " ~ data;
    });
    
    mediator.registerHandler("remove", (string data) @safe {
        return "Removed: " ~ data;
    });
    
    assert(mediator.hasHandler("add"));
    assert(mediator.hasHandler("remove"));
    
    string result1 = mediator.request("add", "item");
    string result2 = mediator.request("remove", "item");
    
    assert(result1 == "Added: item");
    assert(result2 == "Removed: item");
}

@safe unittest {
    // Test chat room basic setup
    auto chatRoom = new ChatRoom();
    auto alice = new User("Alice");
    auto bob = new User("Bob");
    
    chatRoom.registerUser(alice);
    chatRoom.registerUser(bob);
    
    assert(chatRoom.userCount() == 2);
}

@safe unittest {
    // Test chat room broadcast message
    auto chatRoom = new ChatRoom();
    auto alice = new User("Alice");
    auto bob = new User("Bob");
    auto charlie = new User("Charlie");
    
    chatRoom.registerUser(alice);
    chatRoom.registerUser(bob);
    chatRoom.registerUser(charlie);
    
    alice.sendMessage("all", "Hello everyone!");
    
    assert(bob.receivedMessages().length == 1);
    assert(charlie.receivedMessages().length == 1);
    assert(alice.receivedMessages().length == 0); // Sender doesn't receive own message
}

@safe unittest {
    // Test chat room private message
    auto chatRoom = new ChatRoom();
    auto alice = new User("Alice");
    auto bob = new User("Bob");
    auto charlie = new User("Charlie");
    
    chatRoom.registerUser(alice);
    chatRoom.registerUser(bob);
    chatRoom.registerUser(charlie);
    
    alice.sendMessage("Bob", "Private message");
    
    assert(bob.receivedMessages().length == 1);
    assert(charlie.receivedMessages().length == 0);
}

@safe unittest {
    // Test chat room message logging
    auto chatRoom = new ChatRoom();
    auto alice = new User("Alice");
    auto bob = new User("Bob");
    
    chatRoom.registerUser(alice);
    chatRoom.registerUser(bob);
    
    alice.sendMessage("all", "Message 1");
    bob.sendMessage("all", "Message 2");
    
    auto log = chatRoom.messageLog();
    assert(log.length == 2);
}

@safe unittest {
    // Test air traffic control basic setup
    auto atc = new AirTrafficControl();
    auto flight1 = new Aircraft("UA123");
    auto flight2 = new Aircraft("DL456");
    
    atc.registerAircraft(flight1);
    atc.registerAircraft(flight2);
    
    assert(atc.aircraftCount() == 2);
}

@safe unittest {
    // Test air traffic control landing request
    auto atc = new AirTrafficControl();
    auto flight = new Aircraft("BA789");
    
    atc.registerAircraft(flight);
    flight.requestLanding();
    
    auto clearances = flight.receivedClearances();
    assert(clearances.length == 1);
    assert(clearances[0].indexOf("Landing approved") >= 0);
}

@safe unittest {
    // Test air traffic control takeoff request
    auto atc = new AirTrafficControl();
    auto flight = new Aircraft("LH321");
    
    atc.registerAircraft(flight);
    flight.requestTakeoff();
    
    auto clearances = flight.receivedClearances();
    assert(clearances.length == 1);
    assert(clearances[0].indexOf("Takeoff approved") >= 0);
}

@safe unittest {
    // Test air traffic control position reporting
    auto atc = new AirTrafficControl();
    auto flight = new Aircraft("AF654");
    
    atc.registerAircraft(flight);
    flight.reportPosition("10 miles north");
    
    auto log = atc.communicationLog();
    assert(log.length >= 2); // Registration + position report
}

@safe unittest {
    // Test air traffic control communication log
    auto atc = new AirTrafficControl();
    auto flight1 = new Aircraft("AA111");
    auto flight2 = new Aircraft("UA222");
    
    atc.registerAircraft(flight1);
    atc.registerAircraft(flight2);
    
    flight1.requestLanding();
    flight2.requestTakeoff();
    
    auto log = atc.communicationLog();
    assert(log.length >= 4); // 2 registrations + 2 requests
}

@safe unittest {
    // Test dialog mediator button setup
    auto mediator = new DialogMediator();
    auto submitBtn = new Button("submit");
    
    mediator.setSubmitButton(submitBtn);
    assert(submitBtn.enabled);
}

@safe unittest {
    // Test dialog mediator form validation
    auto mediator = new DialogMediator();
    auto submitBtn = new Button("submit");
    auto nameInput = new TextBox("name");
    auto agreeBox = new CheckBox("agree");
    
    mediator.setSubmitButton(submitBtn);
    mediator.setNameInput(nameInput);
    mediator.setAgreeCheckbox(agreeBox);
    
    // Initially should be disabled
    assert(!submitBtn.enabled);
}

@safe unittest {
    // Test dialog mediator enable submit on valid input
    auto mediator = new DialogMediator();
    auto submitBtn = new Button("submit");
    auto nameInput = new TextBox("name");
    auto agreeBox = new CheckBox("agree");
    
    mediator.setSubmitButton(submitBtn);
    mediator.setNameInput(nameInput);
    mediator.setAgreeCheckbox(agreeBox);
    
    // Enter name
    nameInput.text = "John Doe";
    assert(!submitBtn.enabled); // Still disabled, not agreed
    
    // Agree to terms
    agreeBox.isChecked = true;
    assert(submitBtn.enabled); // Now enabled
}

@safe unittest {
    // Test dialog mediator disable on invalid input
    auto mediator = new DialogMediator();
    auto submitBtn = new Button("submit");
    auto nameInput = new TextBox("name");
    auto agreeBox = new CheckBox("agree");
    
    mediator.setSubmitButton(submitBtn);
    mediator.setNameInput(nameInput);
    mediator.setAgreeCheckbox(agreeBox);
    
    // Enable button
    nameInput.text = "Jane";
    agreeBox.isChecked = true;
    assert(submitBtn.enabled);
    
    // Clear name
    nameInput.text = "";
    assert(!submitBtn.enabled);
}

@safe unittest {
    // Test user receiving multiple messages
    auto chatRoom = new ChatRoom();
    auto alice = new User("Alice");
    auto bob = new User("Bob");
    
    chatRoom.registerUser(alice);
    chatRoom.registerUser(bob);
    
    alice.sendMessage("all", "Message 1");
    alice.sendMessage("all", "Message 2");
    alice.sendMessage("all", "Message 3");
    
    assert(bob.receivedMessages().length == 3);
}

@safe unittest {
    // Test aircraft call sign
    auto aircraft = new Aircraft("TEST123");
    assert(aircraft.callSign == "TEST123");
}

@safe unittest {
    // Test UI components properties
    auto button = new Button("testBtn");
    assert(button.name == "testBtn");
    assert(button.enabled);
    
    button.enabled = false;
    assert(!button.enabled);
    
    auto textBox = new TextBox("testInput");
    assert(textBox.name == "testInput");
    assert(textBox.text == "");
    
    textBox.text = "Hello";
    assert(textBox.text == "Hello");
    
    auto checkBox = new CheckBox("testCheck");
    assert(checkBox.name == "testCheck");
    assert(!checkBox.isChecked);
    
    checkBox.isChecked = true;
    assert(checkBox.isChecked);
}

import std.string : toUpper, indexOf;
