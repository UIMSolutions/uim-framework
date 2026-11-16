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
    
    void mediator(IMediator mediator) {
        _mediator = mediator;
    }
    
    IMediator mediator() {
        return _mediator;
    }
}

/**
 * Concrete mediator coordinating colleague interactions.
 */
class ConcreteMediator : IMediator {
    private IColleague[] _colleagues;
    
    void addColleague(IColleague colleague) {
        _colleagues ~= colleague;
        colleague.mediator = this;
    }
    
    void notify(IColleague sender, string event) {
        // Override in subclass to handle specific events
    }
    
    size_t colleagueCount() const {
        return _colleagues.length;
    }
}

/**
 * Generic mediator implementation with typed messages.
 */
class GenericMediator(TMessage) : IGenericMediator!TMessage {
    private void delegate(string sender, TMessage message) @safe[string] _handlers;
    
    void send(string sender, TMessage message) {
        foreach (receiver, handler; _handlers) {
            if (receiver != sender) {
                handler(sender, message);
            }
        }
    }
    
    void register(string receiver, void delegate(string sender, TMessage message) @safe handler) {
        _handlers[receiver] = handler;
    }
    
    void unregister(string receiver) {
        _handlers.remove(receiver);
    }
    
    size_t handlerCount() const {
        return _handlers.length;
    }
}

/**
 * Event-based mediator implementation.
 */
class EventMediator : IEventMediator {
    private void delegate(string eventData) @safe[][string] _subscribers;
    
    void subscribe(string eventName, void delegate(string eventData) @safe handler) {
        _subscribers[eventName] ~= handler;
    }
    
    void unsubscribe(string eventName, void delegate(string eventData) @safe handler) {
        if (auto handlers = eventName in _subscribers) {
            // Note: delegate comparison might not work as expected
            // In production, consider using unique IDs
        }
    }
    
    void publish(string eventName, string eventData) {
        if (auto handlers = eventName in _subscribers) {
            foreach (handler; *handlers) {
                handler(eventData);
            }
        }
    }
    
    size_t subscriberCount(string eventName) const {
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
    
    string request(string requestType, string requestData) {
        if (auto handler = requestType in _handlers) {
            return (*handler)(requestData);
        }
        return "No handler found for: " ~ requestType;
    }
    
    void registerHandler(string requestType, string delegate(string requestData) @safe handler) {
        _handlers[requestType] = handler;
    }
    
    bool hasHandler(string requestType) const {
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
    
    void registerUser(User user) {
        _users[user.name] = user;
        user.mediator = this;
    }
    
    void notify(IColleague sender, string event) {
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
    
    private void broadcastMessage(string senderName, string message) {
        string logEntry = format("[%s to all]: %s", senderName, message);
        _messageLog ~= logEntry;
        
        foreach (name, user; _users) {
            if (name != senderName) {
                user.receiveMessage(senderName, message);
            }
        }
    }
    
    private void sendPrivateMessage(string senderName, string recipientName, string message) {
        string logEntry = format("[%s to %s]: %s", senderName, recipientName, message);
        _messageLog ~= logEntry;
        
        if (auto recipient = recipientName in _users) {
            recipient.receiveMessage(senderName, message);
        }
    }
    
    string[] messageLog() const {
        return _messageLog.dup;
    }
    
    size_t userCount() const {
        return _users.length;
    }
}

/**
 * User in a chat room.
 */
class User : BaseColleague {
    private string _name;
    private string[] _receivedMessages;
    
    this(string name) {
        _name = name;
    }
    
    @property string name() const {
        return _name;
    }
    
    void sendMessage(string recipient, string message) {
        string event = format("message:%s:%s", recipient, message);
        if (_mediator !is null) {
            _mediator.notify(this, event);
        }
    }
    
    void receiveMessage(string sender, string message) {
        _receivedMessages ~= format("From %s: %s", sender, message);
    }
    
    string[] receivedMessages() const {
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
    
    void registerAircraft(Aircraft aircraft) {
        _aircraft[aircraft.callSign] = aircraft;
        aircraft.setControl(this);
        logCommunication(format("%s registered with ATC", aircraft.callSign));
    }
    
    void requestLanding(string callSign) {
        logCommunication(format("%s requesting landing permission", callSign));
        
        if (auto aircraft = callSign in _aircraft) {
            aircraft.receiveClearance("Landing approved on runway 27L");
        }
    }
    
    void requestTakeoff(string callSign) {
        logCommunication(format("%s requesting takeoff clearance", callSign));
        
        if (auto aircraft = callSign in _aircraft) {
            aircraft.receiveClearance("Takeoff approved on runway 09R");
        }
    }
    
    void reportPosition(string callSign, string position) {
        logCommunication(format("%s reporting position: %s", callSign, position));
    }
    
    private void logCommunication(string message) {
        _communicationLog ~= message;
    }
    
    string[] communicationLog() const {
        return _communicationLog.dup;
    }
    
    size_t aircraftCount() const {
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
    
    this(string callSign) {
        _callSign = callSign;
    }
    
    @property string callSign() const {
        return _callSign;
    }
    
    void setControl(AirTrafficControl control) {
        _control = control;
    }
    
    void requestLanding() {
        if (_control !is null) {
            _control.requestLanding(_callSign);
        }
    }
    
    void requestTakeoff() {
        if (_control !is null) {
            _control.requestTakeoff(_callSign);
        }
    }
    
    void reportPosition(string position) {
        if (_control !is null) {
            _control.reportPosition(_callSign, position);
        }
    }
    
    void receiveClearance(string clearance) {
        _receivedClearances ~= clearance;
    }
    
    string[] receivedClearances() const {
        return _receivedClearances.dup;
    }
}

// UI component coordination example

/**
 * Dialog mediator coordinating UI components.
 */
class DialogMediator {
    private MediatorButton _submitButton;
    private MediatorButton _cancelButton;
    private MediatorTextBox _nameInput;
    private MediatorCheckBox _agreeCheckbox;
    
    void setSubmitButton(MediatorButton button) {
        _submitButton = button;
        button.setMediator(this);
        updateSubmitButton();
    }
    
    void setCancelButton(MediatorButton button) {
        _cancelButton = button;
        button.setMediator(this);
    }
    
    void setNameInput(MediatorTextBox input) {
        _nameInput = input;
        input.setMediator(this);
        updateSubmitButton();
    }
    
    void setAgreeCheckbox(MediatorCheckBox checkbox) {
        _agreeCheckbox = checkbox;
        checkbox.setMediator(this);
        updateSubmitButton();
    }
    
    void notify(string componentName, string event) {
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
    
    private void updateSubmitButton() {
        if (_submitButton !is null && _nameInput !is null && _agreeCheckbox !is null) {
            bool canSubmit = _nameInput.text.length > 0 && _agreeCheckbox.isChecked;
            _submitButton.enabled = canSubmit;
        }
    }
    
    private void handleSubmit() {
        // Handle form submission
    }
    
    private void handleCancel() {
        // Handle cancellation
    }
}

/**
 * UI Button component.
 */
class MediatorButton {
    private string _name;
    private bool _enabled;
    private DialogMediator _mediator;
    
    this(string name) {
        _name = name;
        _enabled = true;
    }
    
    @property string name() const { return _name; }
    @property bool enabled() const { return _enabled; }
    @property void enabled(bool value) { _enabled = value; }
    
    void setMediator(DialogMediator mediator) {
        _mediator = mediator;
    }
    
    void click() {
        if (_enabled && _mediator !is null) {
            _mediator.notify(_name, _name ~ "Clicked");
        }
    }
}

/**
 * UI TextBox component.
 */
class MediatorTextBox {
    private string _name;
    private string _text;
    private DialogMediator _mediator;
    
    this(string name) {
        _name = name;
        _text = "";
    }
    
    @property string name() const { return _name; }
    @property string text() const { return _text; }
    
    @property void text(string value) {
        _text = value;
        if (_mediator !is null) {
            _mediator.notify(_name, "textChanged");
        }
    }
    
    void setMediator(DialogMediator mediator) {
        _mediator = mediator;
    }
}

/**
 * UI CheckBox component.
 */
class MediatorCheckBox {
    private string _name;
    private bool _isChecked;
    private DialogMediator _mediator;
    
    this(string name) {
        _name = name;
        _isChecked = false;
    }
    
    @property string name() const { return _name; }
    @property bool isChecked() const { return _isChecked; }
    
    @property void isChecked(bool value) {
        _isChecked = value;
        if (_mediator !is null) {
            _mediator.notify(_name, "checkChanged");
        }
    }
    
    void setMediator(DialogMediator mediator) {
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
    mediator.register("receiver", (string sender, string message) {
        received = message;
    });
    
    mediator.send("sender", "Hello");
    assert(received == "Hello");
}

@safe unittest {
    // Test event mediator
    auto mediator = new EventMediator();
    
    int eventCount = 0;
    mediator.subscribe("test", (string data) {
        eventCount++;
    });
    
    mediator.publish("test", "data");
    assert(eventCount == 1);
}

@safe unittest {
    // Test request-response mediator
    auto mediator = new RequestResponseMediator();
    
    mediator.registerHandler("echo", (string data) {
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
    auto submitBtn = new MediatorButton("submit");
    auto nameInput = new MediatorTextBox("name");
    auto agreeBox = new MediatorCheckBox("agree");
    
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
