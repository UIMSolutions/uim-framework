module uim.oop.patterns.mediators.mediator;

import uim.oop;
import uim.oop.patterns.mediators.interfaces;

mixin(ShowModule!());

@safe:

/**
 * Abstract base colleague class.
 */
abstract class BaseColleague : IColleague {
    protected IMediator _mediator;
    
    void mediator(IMediator mediator) @safe {
        _mediator = mediator;
    }
    
    IMediator mediator() @safe {
        return _mediator;
    }
}

/**
 * Concrete mediator coordinating colleague interactions.
 */
class ConcreteMediator : IMediator {
    private IColleague[] _colleagues;
    
    void addColleague(IColleague colleague) @safe {
        _colleagues ~= colleague;
        colleague.mediator = this;
    }
    
    void notify(IColleague sender, string event) @safe {
        // Override in subclass to handle specific events
    }
    
    size_t colleagueCount() const @safe {
        return _colleagues.length;
    }
}

/**
 * Generic mediator implementation with typed messages.
 */
class GenericMediator(TMessage) : IGenericMediator!TMessage {
    private void delegate(string sender, TMessage message) @safe[string] _handlers;
    
    void send(string sender, TMessage message) @safe {
        foreach (receiver, handler; _handlers) {
            if (receiver != sender) {
                handler(sender, message);
            }
        }
    }
    
    void register(string receiver, void delegate(string sender, TMessage message) @safe handler) @safe {
        _handlers[receiver] = handler;
    }
    
    void unregister(string receiver) @safe {
        _handlers.remove(receiver);
    }
    
    size_t handlerCount() const @safe {
        return _handlers.length;
    }
}

/**
 * Event-based mediator implementation.
 */
class EventMediator : IEventMediator {
    private void delegate(string eventData) @safe[][string] _subscribers;
    
    void subscribe(string eventName, void delegate(string eventData) @safe handler) @safe {
        _subscribers[eventName] ~= handler;
    }
    
    void unsubscribe(string eventName, void delegate(string eventData) @safe handler) @safe {
        if (auto handlers = eventName in _subscribers) {
            // Note: delegate comparison might not work as expected
            // In production, consider using unique IDs
        }
    }
    
    void publish(string eventName, string eventData) @safe {
        if (auto handlers = eventName in _subscribers) {
            foreach (handler; *handlers) {
                handler(eventData);
            }
        }
    }
    
    size_t subscriberCount(string eventName) const @safe {
        if (auto handlers = eventName in _subscribers) {
            return handlers.length;
        }
        return 0;
    }
}

/**
 * Request-response mediator implementation.
 */
class RequestResponseMediator : IRequestResponseMediator {
    private string delegate(string requestData) @safe[string] _handlers;
    
    string request(string requestType, string requestData) @safe {
        if (auto handler = requestType in _handlers) {
            return (*handler)(requestData);
        }
        return "No handler found for: " ~ requestType;
    }
    
    void registerHandler(string requestType, string delegate(string requestData) @safe handler) @safe {
        _handlers[requestType] = handler;
    }
    
    bool hasHandler(string requestType) const @safe {
        return (requestType in _handlers) !is null;
    }
}

// Real-world example: Chat room mediator

/**
 * Chat room mediator coordinating user communication.
 */
class ChatRoom : IMediator {
    private User[string] _users;
    private string[] _messageLog;
    
    void registerUser(User user) @safe {
        _users[user.name] = user;
        user.mediator = this;
    }
    
    void notify(IColleague sender, string event) @safe {
        if (auto user = cast(User)sender) {
            // Parse event format: "message:targetUser:content"
            auto parts = event.split(":");
            if (parts.length >= 3 && parts[0] == "message") {
                string targetName = parts[1];
                string message = parts[2];
                
                if (targetName == "all") {
                    broadcastMessage(user.name, message);
                } else if (auto targetUser = targetName in _users) {
                    sendPrivateMessage(user.name, targetName, message);
                }
            }
        }
    }
    
    private void broadcastMessage(string senderName, string message) @safe {
        string logEntry = format("[%s to all]: %s", senderName, message);
        _messageLog ~= logEntry;
        
        foreach (name, user; _users) {
            if (name != senderName) {
                user.receiveMessage(senderName, message);
            }
        }
    }
    
    private void sendPrivateMessage(string senderName, string recipientName, string message) @safe {
        string logEntry = format("[%s to %s]: %s", senderName, recipientName, message);
        _messageLog ~= logEntry;
        
        if (auto recipient = recipientName in _users) {
            recipient.receiveMessage(senderName, message);
        }
    }
    
    string[] messageLog() const @safe {
        return _messageLog.dup;
    }
    
    size_t userCount() const @safe {
        return _users.length;
    }
}

/**
 * User in a chat room.
 */
class User : BaseColleague {
    private string _name;
    private string[] _receivedMessages;
    
    this(string name) @safe {
        _name = name;
    }
    
    @property string name() const @safe {
        return _name;
    }
    
    void sendMessage(string recipient, string message) @safe {
        string event = format("message:%s:%s", recipient, message);
        if (_mediator !is null) {
            _mediator.notify(this, event);
        }
    }
    
    void receiveMessage(string sender, string message) @safe {
        _receivedMessages ~= format("From %s: %s", sender, message);
    }
    
    string[] receivedMessages() const @safe {
        return _receivedMessages.dup;
    }
}

// Air traffic control example

/**
 * Air traffic control tower (mediator).
 */
class AirTrafficControl {
    private Aircraft[string] _aircraft;
    private string[] _communicationLog;
    
    void registerAircraft(Aircraft aircraft) @safe {
        _aircraft[aircraft.callSign] = aircraft;
        aircraft.setControl(this);
        logCommunication(format("%s registered with ATC", aircraft.callSign));
    }
    
    void requestLanding(string callSign) @safe {
        logCommunication(format("%s requesting landing permission", callSign));
        
        if (auto aircraft = callSign in _aircraft) {
            aircraft.receiveClearance("Landing approved on runway 27L");
        }
    }
    
    void requestTakeoff(string callSign) @safe {
        logCommunication(format("%s requesting takeoff clearance", callSign));
        
        if (auto aircraft = callSign in _aircraft) {
            aircraft.receiveClearance("Takeoff approved on runway 09R");
        }
    }
    
    void reportPosition(string callSign, string position) @safe {
        logCommunication(format("%s reporting position: %s", callSign, position));
    }
    
    private void logCommunication(string message) @safe {
        _communicationLog ~= message;
    }
    
    string[] communicationLog() const @safe {
        return _communicationLog.dup;
    }
    
    size_t aircraftCount() const @safe {
        return _aircraft.length;
    }
}

/**
 * Aircraft communicating through ATC.
 */
class Aircraft {
    private string _callSign;
    private AirTrafficControl _control;
    private string[] _receivedClearances;
    
    this(string callSign) @safe {
        _callSign = callSign;
    }
    
    @property string callSign() const @safe {
        return _callSign;
    }
    
    void setControl(AirTrafficControl control) @safe {
        _control = control;
    }
    
    void requestLanding() @safe {
        if (_control !is null) {
            _control.requestLanding(_callSign);
        }
    }
    
    void requestTakeoff() @safe {
        if (_control !is null) {
            _control.requestTakeoff(_callSign);
        }
    }
    
    void reportPosition(string position) @safe {
        if (_control !is null) {
            _control.reportPosition(_callSign, position);
        }
    }
    
    void receiveClearance(string clearance) @safe {
        _receivedClearances ~= clearance;
    }
    
    string[] receivedClearances() const @safe {
        return _receivedClearances.dup;
    }
}

// UI component coordination example

/**
 * Dialog mediator coordinating UI components.
 */
class DialogMediator {
    private Button _submitButton;
    private Button _cancelButton;
    private TextBox _nameInput;
    private CheckBox _agreeCheckbox;
    
    void setSubmitButton(Button button) @safe {
        _submitButton = button;
        button.setMediator(this);
        updateSubmitButton();
    }
    
    void setCancelButton(Button button) @safe {
        _cancelButton = button;
        button.setMediator(this);
    }
    
    void setNameInput(TextBox input) @safe {
        _nameInput = input;
        input.setMediator(this);
        updateSubmitButton();
    }
    
    void setAgreeCheckbox(CheckBox checkbox) @safe {
        _agreeCheckbox = checkbox;
        checkbox.setMediator(this);
        updateSubmitButton();
    }
    
    void notify(string componentName, string event) @safe {
        if (event == "textChanged") {
            updateSubmitButton();
        } else if (event == "checkChanged") {
            updateSubmitButton();
        } else if (event == "submitClicked") {
            handleSubmit();
        } else if (event == "cancelClicked") {
            handleCancel();
        }
    }
    
    private void updateSubmitButton() @safe {
        if (_submitButton !is null && _nameInput !is null && _agreeCheckbox !is null) {
            bool canSubmit = _nameInput.text.length > 0 && _agreeCheckbox.isChecked;
            _submitButton.enabled = canSubmit;
        }
    }
    
    private void handleSubmit() @safe {
        // Handle form submission
    }
    
    private void handleCancel() @safe {
        // Handle cancellation
    }
}

/**
 * UI Button component.
 */
class Button {
    private string _name;
    private bool _enabled;
    private DialogMediator _mediator;
    
    this(string name) @safe {
        _name = name;
        _enabled = true;
    }
    
    @property string name() const @safe { return _name; }
    @property bool enabled() const @safe { return _enabled; }
    @property void enabled(bool value) @safe { _enabled = value; }
    
    void setMediator(DialogMediator mediator) @safe {
        _mediator = mediator;
    }
    
    void click() @safe {
        if (_enabled && _mediator !is null) {
            _mediator.notify(_name, _name ~ "Clicked");
        }
    }
}

/**
 * UI TextBox component.
 */
class TextBox {
    private string _name;
    private string _text;
    private DialogMediator _mediator;
    
    this(string name) @safe {
        _name = name;
        _text = "";
    }
    
    @property string name() const @safe { return _name; }
    @property string text() const @safe { return _text; }
    
    @property void text(string value) @safe {
        _text = value;
        if (_mediator !is null) {
            _mediator.notify(_name, "textChanged");
        }
    }
    
    void setMediator(DialogMediator mediator) @safe {
        _mediator = mediator;
    }
}

/**
 * UI CheckBox component.
 */
class CheckBox {
    private string _name;
    private bool _isChecked;
    private DialogMediator _mediator;
    
    this(string name) @safe {
        _name = name;
        _isChecked = false;
    }
    
    @property string name() const @safe { return _name; }
    @property bool isChecked() const @safe { return _isChecked; }
    
    @property void isChecked(bool value) @safe {
        _isChecked = value;
        if (_mediator !is null) {
            _mediator.notify(_name, "checkChanged");
        }
    }
    
    void setMediator(DialogMediator mediator) @safe {
        _mediator = mediator;
    }
}

@safe unittest {
    // Test basic mediator
    auto mediator = new ConcreteMediator();
    assert(mediator.colleagueCount() == 0);
}

@safe unittest {
    // Test generic mediator
    auto mediator = new GenericMediator!string();
    
    string received = "";
    mediator.register("receiver", (string sender, string message) @safe {
        received = message;
    });
    
    mediator.send("sender", "Hello");
    assert(received == "Hello");
}

@safe unittest {
    // Test event mediator
    auto mediator = new EventMediator();
    
    int eventCount = 0;
    mediator.subscribe("test", (string data) @safe {
        eventCount++;
    });
    
    mediator.publish("test", "data");
    assert(eventCount == 1);
}

@safe unittest {
    // Test request-response mediator
    auto mediator = new RequestResponseMediator();
    
    mediator.registerHandler("echo", (string data) @safe {
        return "Echo: " ~ data;
    });
    
    string result = mediator.request("echo", "test");
    assert(result == "Echo: test");
}

@safe unittest {
    // Test chat room
    auto chatRoom = new ChatRoom();
    auto alice = new User("Alice");
    auto bob = new User("Bob");
    
    chatRoom.registerUser(alice);
    chatRoom.registerUser(bob);
    
    alice.sendMessage("all", "Hello everyone!");
    
    assert(bob.receivedMessages().length == 1);
    assert(chatRoom.messageLog().length == 1);
}

@safe unittest {
    // Test air traffic control
    auto atc = new AirTrafficControl();
    auto flight1 = new Aircraft("UA123");
    auto flight2 = new Aircraft("AA456");
    
    atc.registerAircraft(flight1);
    atc.registerAircraft(flight2);
    
    flight1.requestLanding();
    
    assert(flight1.receivedClearances().length == 1);
    assert(atc.communicationLog().length >= 2);
}

@safe unittest {
    // Test dialog mediator
    auto mediator = new DialogMediator();
    auto submitBtn = new Button("submit");
    auto nameInput = new TextBox("name");
    auto agreeBox = new CheckBox("agree");
    
    mediator.setSubmitButton(submitBtn);
    mediator.setNameInput(nameInput);
    mediator.setAgreeCheckbox(agreeBox);
    
    // Initially disabled (no name, not agreed)
    assert(!submitBtn.enabled);
    
    // Enter name
    nameInput.text = "John";
    assert(!submitBtn.enabled);
    
    // Agree to terms
    agreeBox.isChecked = true;
    assert(submitBtn.enabled);
}

import std.string : split;
