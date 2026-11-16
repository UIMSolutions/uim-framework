# MVC (Model-View-Controller) Pattern

The MVC pattern is an architectural pattern that separates an application into three main logical components: MVCModel, View, and Controller. Each of these components handles specific development aspects of an application.

## Overview

**Purpose**: Separates application logic into three interconnected components to separate internal representations of information from the ways that information is presented to and accepted from the user.

**Location**: `patterns/mvc/`

## UML Diagrams

### Class Diagram

```
┌─────────────────────────────┐
│      <<interface>>          │
│         IMVCModel              │
├─────────────────────────────┤
│ + set(key, value): void     │
│ + get(key): string          │
│ + has(key): bool            │
│ + remove(key): void         │
│ + validate(): bool          │
│ + attachView(IView): void   │
│ + detachView(IView): void   │
│ + notifyViews(): void       │
└─────────────────────────────┘
           △
           │ implements
           │
┌──────────┴───────────────────┐
│         Model                │
├──────────────────────────────┤
│ - data: string[string]       │
│ - views: IView[]             │
├──────────────────────────────┤
│ + set(key, value): void      │
│ + get(key): string           │
│ + has(key): bool             │
│ + getData(): string[string]  │
│ + validate(): bool           │
│ + attachView(view): void     │
│ + detachView(view): void     │
│ + notifyViews(): void        │
└──────────────────────────────┘

┌─────────────────────────────┐
│      <<interface>>          │
│         IView               │
├─────────────────────────────┤
│ + render(): string          │
│ + update(): void            │
│ + setModel(IMVCModel): void    │
│ + getModel(): IMVCModel        │
└─────────────────────────────┘
           △
           │ implements
           │
┌──────────┴──────────────────────────────┐
│              View                       │
├─────────────────────────────────────────┤
│ - model: IMVCModel                         │
├─────────────────────────────────────────┤
│ + render(): string                      │
│ + update(): void                        │
│ + setModel(model): void                 │
│ + getModel(): IMVCModel                    │
└─────────────────────────────────────────┘
           △
           │
    ┌──────┴──────┬──────────┬────────┐
    │             │          │        │
┌───────────┐ ┌─────────┐ ┌─────────┐ ┌──────────┐
│ Template  │ │  Json   │ │  HTML   │ │   ...    │
│   View    │ │  View   │ │  View   │ │          │
└───────────┘ └─────────┘ └─────────┘ └──────────┘

┌─────────────────────────────┐
│      <<interface>>          │
│       IController           │
├─────────────────────────────┤
│ + handleRequest(params)     │
│ + executeAction(name, params)│
│ + setModel(IMVCModel): void    │
│ + setView(IView): void      │
│ + getModel(): IMVCModel        │
│ + getView(): IView          │
└─────────────────────────────┘
           △
           │ implements
           │
┌──────────┴────────────────────────────────────┐
│              Controller                       │
├───────────────────────────────────────────────┤
│ - model: IMVCModel                               │
│ - view: IView                                 │
│ - actions: bool delegate(string[string])[string] │
├───────────────────────────────────────────────┤
│ + handleRequest(params): string[string]       │
│ + executeAction(name, params): string[string] │
│ + registerAction(name, handler): void         │
│ + setModel(model): void                       │
│ + setView(view): void                         │
│ + getModel(): IMVCModel                          │
│ + getView(): IView                            │
└───────────────────────────────────────────────┘
           △
           │
    ┌──────┴──────┬──────────┬────────────┐
    │             │          │            │
┌───────────┐ ┌─────────────┐ ┌──────────────┐ ┌────────┐
│   REST    │ │ Validation  │ │    Async     │ │  ...   │
│Controller │ │ Controller  │ │ Controller   │ │        │
└───────────┘ └─────────────┘ └──────────────┘ └────────┘

┌────────────────────────────────────┐
│      <<interface>>                 │
│      IMVCApplication               │
├────────────────────────────────────┤
│ + initialize(): void               │
│ + run(params): string[string]      │
│ + getModel(): IMVCModel               │
│ + getView(): IView                 │
│ + getController(): IController     │
└────────────────────────────────────┘
           △
           │ implements
           │
┌──────────┴─────────────────────────┐
│       MVCApplication               │
├────────────────────────────────────┤
│ - model: IMVCModel                    │
│ - view: IView                      │
│ - controller: IController          │
├────────────────────────────────────┤
│ + this(model, view, controller)    │
│ + initialize(): void               │
│ + run(params): string[string]      │
│ + getModel(): IMVCModel               │
│ + getView(): IView                 │
│ + getController(): IController     │
└────────────────────────────────────┘
            │
            │ contains
    ┌───────┼────────┐
    │       │        │
    ▼       ▼        ▼
  Model   View   Controller
```

### Component Relationships

```
┌──────────┐         ┌────────────┐         ┌──────┐
│  User    │────────>│ Controller │────────>│ Model│
└──────────┘         └────────────┘         └──────┘
                            │                   │
                            │                   │ notifies
                            │                   ▼
                            │              ┌──────┐
                            └─────────────>│ View │
                                           └──────┘
                                               │
                                               │ renders
                                               ▼
                                          ┌────────┐
                                          │ Output │
                                          └────────┘
```

### Sequence Diagram: Handling a User Request

```
User          Controller        Model           View
 │                │              │               │
 │─request────────>│              │               │
 │                │              │               │
 │                │─executeAction─>│              │
 │                │              │               │
 │                │              │─validate()    │
 │                │              │               │
 │                │              │─set(data)     │
 │                │              │               │
 │                │              │─notifyViews()─>│
 │                │              │               │
 │                │              │               │─update()
 │                │              │               │
 │                │<─────────────┤               │
 │                │              │               │
 │                │──────────────────render()───>│
 │                │              │               │
 │                │<──────────────────output────┤
 │                │              │               │
 │<─response──────┤              │               │
 │                │              │               │
```

### Sequence Diagram: MVCModel Update with Observer Pattern

```
Controller       Model                View1        View2
    │              │                    │            │
    │─set(key,val)─>│                   │            │
    │              │                    │            │
    │              │─notifyViews()────> │            │
    │              │                    │            │
    │              │                    │─update()   │
    │              │                    │            │
    │              │                    │─render()   │
    │              │                    │            │
    │              │─────────────────────────────────>│
    │              │                    │            │
    │              │                    │            │─update()
    │              │                    │            │
    │              │                    │            │─render()
    │              │                    │            │
    │<─────────────┤                    │            │
    │              │                    │            │
```

### State Diagram: Controller Action Processing

```
                    ┌─────────────┐
                    │   Idle      │
                    └──────┬──────┘
                           │ request received
                           ▼
                    ┌─────────────┐
                    │ Validating  │
                    │   Input     │
                    └──────┬──────┘
                           │
                  ┌────────┴────────┐
                  │                 │
            valid │                 │ invalid
                  ▼                 ▼
         ┌─────────────┐    ┌─────────────┐
         │ Executing   │    │   Error     │
         │   Action    │    │  Response   │
         └──────┬──────┘    └──────┬──────┘
                │                  │
                │ success          │
                ▼                  │
         ┌─────────────┐           │
         │  Updating   │           │
         │    Model    │           │
         └──────┬──────┘           │
                │                  │
                │                  │
                ▼                  │
         ┌─────────────┐           │
         │ Rendering   │           │
         │    View     │           │
         └──────┬──────┘           │
                │                  │
                └────────┬─────────┘
                         │
                         ▼
                  ┌─────────────┐
                  │  Response   │
                  │   Sent      │
                  └─────────────┘
```

### Package Diagram

```
┌────────────────────────────────────────────────────┐
│          uim.oop.patterns.mvc                      │
├────────────────────────────────────────────────────┤
│                                                    │
│  ┌──────────────────┐  ┌──────────────────┐      │
│  │   interfaces     │  │     helpers      │      │
│  ├──────────────────┤  └──────────────────┘      │
│  │ - IMVCModel         │           │                 │
│  │ - IView          │           │                 │
│  │ - IController    │           ▼                 │
│  │ - IMVCApplication│  ┌──────────────────┐      │
│  └────────┬─────────┘  │ createMVCApp()   │      │
│           │            │ createModel()    │      │
│           │            │ createView()     │      │
│           │            │ createController()│      │
│           │            └──────────────────┘      │
│           │                                       │
│           │ implements                            │
│           ▼                                       │
│  ┌──────────────────────────────────────────┐   │
│  │  model.d    view.d    controller.d       │   │
│  ├──────────────────────────────────────────┤   │
│  │ Model       View      Controller         │   │
│  │ DataModel   TemplateView  RESTController │   │
│  │ Observable  JsonView      Validation...  │   │
│  │ Model       HTMLView      AsyncController│   │
│  └──────────────────────────────────────────┘   │
│           │                                       │
│           │ used by                               │
│           ▼                                       │
│  ┌──────────────────┐                            │
│  │  application.d   │                            │
│  ├──────────────────┤                            │
│  │ MVCApplication   │                            │
│  └──────────────────┘                            │
│                                                    │
└────────────────────────────────────────────────────┘
```

## Components

### 1. Model (`IMVCModel`, `Model`)

The Model represents the data and business logic of the application.

**Key Features**:
- Data storage and retrieval
- Business logic and validation
- Observer pattern for notifying views
- Support for typed data with `DataModel!T`
- Before/after change callbacks with `ObservableModel`

**Example**:
```d
auto model = new MVCModel();
model.set("username", "john_doe");
model.set("email", "john@example.com");

// Validate data
if (model.validate()) {
    // Process valid data
}

// Observable model with callbacks
auto observable = new ObservableModel();
observable.onAfterChange((key, value) {
    writeln("Changed: ", key, " = ", value);
});
observable.set("status", "active"); // Triggers callback
```

### 2. View (`IView`, `View`)

The View is responsible for presenting the model data to the user.

**Key Features**:
- Multiple rendering formats (text, Json, HTML, templates)
- Automatic updates when model changes
- Template variable substitution
- Custom formatting support

**View Types**:
- `View` - Basic view with simple rendering
- `TemplateView` - Supports `{{variable}}` placeholders
- `JsonView` - Renders data as Json
- `HTMLView` - Renders data as HTML

**Example**:
```d
auto model = new MVCModel();
model.set("name", "Alice");
model.set("age", "30");

// Basic view
auto view = new View(model);
writeln(view.render());

// Template view
auto templateView = new TemplateView(model, "Hello {{name}}, age {{age}}!");
writeln(templateView.render()); // "Hello Alice, age 30!"

// Json view
auto jsonView = new JsonView(model);
writeln(jsonView.render()); // {"name": "Alice", "age": "30"}

// HTML view
auto htmlView = new HTMLView(model, "user-info");
writeln(htmlView.render()); // <div class="user-info">...</div>
```

### 3. Controller (`IController`, `Controller`)

The Controller acts as an intermediary between Model and View, processing user input and updating the model.

**Key Features**:
- Action-based request handling
- Model and view coordination
- Custom action registration
- RESTful CRUD operations with `RESTController`
- Input validation with `ValidationController`
- Before/after action hooks with `AsyncController`

**Example**:
```d
auto model = new MVCModel();
auto view = new View(model);
auto controller = new Controller(model, view);

// Register custom action
controller.registerAction("greet", (params) {
    string name = params.get("name", "Guest");
    controller.getModel().set("greeting", "Hello, " ~ name);
    return ["result": "Greeting set"];
});

// Handle request
auto response = controller.handleRequest([
    "action": "greet",
    "name": "Bob"
]);

// REST controller
auto restController = new RESTController(model, view);
restController.executeAction("create", ["title": "New Item"]);
restController.executeAction("update", ["id": "1", "title": "Updated"]);
```

### 4. MVC Application (`MVCApplication`)

A complete MVC application that wires all components together.

**Example**:
```d
// Create a complete application
auto app = createMVCApplication();

// Or with custom components
auto model = new MVCModel();
auto view = new TemplateView(model, "User: {{username}}");
auto controller = new RESTController(model, view);
auto app = createMVCApplication(model, view, controller);

// Initialize and run
app.initialize();
auto output = app.run([
    "action": "create",
    "username": "alice",
    "email": "alice@example.com"
]);
```

## Use Cases

### 1. Web Applications
```d
auto model = new MVCModel();
auto view = new HTMLView(model, "content");
auto controller = new RESTController(model, view);

auto app = new MVCApplication(model, view, controller);
app.initialize();

// Handle HTTP-like request
auto response = app.run([
    "action": "create",
    "title": "New Post",
    "content": "Post content here"
]);
```

### 2. Data Entry Forms
```d
auto model = new ObservableModel();
model.onAfterChange((key, value) {
    writeln("Field updated: ", key);
});

auto view = new TemplateView(model, 
    "Name: {{name}}\nEmail: {{email}}");

auto controller = new ValidationController(model, view);
controller.addValidationRule((input) {
    return "email" in input && input["email"].length > 0;
});

// Process form submission
if (controller.validateInput(formData)) {
    controller.handleRequest(formData);
}
```

### 3. API Endpoints
```d
auto model = new MVCModel();
auto view = new JsonView(model);
auto controller = new RESTController(model, view);

// Handle API request
auto jsonResponse = controller.handleRequest([
    "action": "show",
    "id": "123"
]);
// Returns Json formatted data
```

### 4. Real-time Updates
```d
auto model = new ObservableModel();

// Attach multiple views
auto textView = new View(model);
auto jsonView = new JsonView(model);
auto htmlView = new HTMLView(model);

model.attachView(textView);
model.attachView(jsonView);
model.attachView(htmlView);

// Update model - all views are automatically notified
model.set("status", "updated");
// All three views now reflect the change
```

## Advanced Features

### Custom Actions
```d
auto controller = new Controller();

controller.registerAction("custom", (params) {
    // Custom logic here
    return ["result": "Custom action executed"];
});
```

### Validation Rules
```d
auto controller = new ValidationController();

controller.addValidationRule((input) {
    return "username" in input && input["username"].length >= 3;
});

controller.addValidationRule((input) {
    return "password" in input && input["password"].length >= 8;
});
```

### Lifecycle Hooks
```d
auto controller = new AsyncController();

controller.before((action, params) {
    writeln("Before action: ", action);
});

controller.after((action, params, result) {
    writeln("After action: ", action, " -> ", result);
});
```

### Typed Models
```d
struct UserData {
    string name;
    int age;
    string email;
}

auto model = new DataModel!UserData();
model.setTypedData(UserData("Alice", 30, "alice@example.com"));

auto data = model.getTypedData();
writeln(data.name); // "Alice"
```

## Best Practices

1. **Separation of Concerns**: Keep business logic in the model, presentation in the view, and coordination in the controller

2. **Thin Controllers**: Controllers should delegate work to models and views, not contain business logic

3. **View Independence**: Views should not directly modify models, use controllers for that

4. **Model Validation**: Implement validation in the model, not in controllers or views

5. **Reusable Views**: Design views to work with different models of the same type

6. **Action Organization**: Group related actions in specialized controllers

## Testing

```d
unittest {
    auto model = new MVCModel();
    model.set("key", "value");
    assert(model.get("key") == "value");
}

unittest {
    auto model = new MVCModel();
    auto view = new TemplateView(model, "{{key}}");
    model.set("key", "test");
    assert(view.render() == "test");
}

unittest {
    auto app = createMVCApplication();
    auto output = app.run(["action": "index"]);
    assert(output.length > 0);
}
```

## Integration

```d
import uim.oop.patterns.mvc;

// All MVC components are available
auto app = createMVCApplication();

// Or use individual components
auto model = new MVCModel();
auto view = new View(model);
auto controller = new Controller(model, view);
```

## Architecture

```
MVC Pattern
├── Model (Data & Logic)
│   ├── Model - Basic model
│   ├── DataModel!T - Typed model
│   └── ObservableModel - With callbacks
│
├── View (Presentation)
│   ├── View - Basic view
│   ├── TemplateView - Template support
│   ├── JsonView - Json output
│   └── HTMLView - HTML output
│
├── Controller (Coordination)
│   ├── Controller - Basic controller
│   ├── RESTController - REST operations
│   ├── ValidationController - With validation
│   └── AsyncController - With hooks
│
└── Application
    └── MVCApplication - Complete app
```

## Related Patterns

- **Observer Pattern**: Models notify views of changes
- **Strategy Pattern**: Different rendering strategies in views
- **Command Pattern**: Actions in controllers
- **Template Method**: View rendering pipeline

---

**Pattern Type**: Architectural  
**Complexity**: Medium  
**Use When**: Building applications with clear separation between data, presentation, and logic
