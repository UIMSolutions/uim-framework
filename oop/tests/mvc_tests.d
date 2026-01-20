/*********************************************************************************************************
	Copyright: © 2015-2026 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module oop.tests.mvc_tests;

import uim.oop;

@safe:

// Test Model
unittest {
    import std.stdio : writeln;
    writeln("\n=== Testing Model ===");

    auto model = new Model();
    
    // Test basic set/get
    model.set("name", "John");
    assert(model.get("name") == "John", "Model set/get failed");
    
    // Test getData
    auto data = model.getData();
    assert("name" in data, "getData failed");
    assert(data["name"] == "John", "getData value failed");
    
    // Test setData
    model.setData(["key1": "value1", "key2": "value2"]);
    assert(model.get("key1") == "value1", "setData failed");
    assert(model.get("key2") == "value2", "setData failed");
    
    writeln("✓ Model tests passed");
}

// Test View
unittest {
    import std.stdio : writeln;
    writeln("\n=== Testing View ===");

    auto model = new Model();
    model.set("title", "Test Title");
    
    auto view = new View(model);
    
    // Test model association
    assert(view.getModel() is model, "View model association failed");
    
    // Test render
    auto output = view.render();
    assert(output.length > 0, "View render failed");
    
    writeln("✓ View tests passed");
}

// Test TemplateView
unittest {
    import std.stdio : writeln;
    writeln("\n=== Testing TemplateView ===");

    auto model = new Model();
    model.set("name", "Alice");
    model.set("age", "25");
    
    auto view = new TemplateView(model, "Name: {{name}}, Age: {{age}}");
    auto output = view.render();
    
    assert(output == "Name: Alice, Age: 25", "TemplateView render failed: " ~ output);
    
    writeln("✓ TemplateView tests passed");
}

// Test JSONView
unittest {
    import std.stdio : writeln;
    writeln("\n=== Testing JSONView ===");

    auto model = new Model();
    model.set("key", "value");
    
    auto view = new JSONView(model);
    auto output = view.render();
    
    assert(output.length > 0, "JSONView render failed");
    import std.string : indexOf;
    assert(output.indexOf("key") >= 0, "JSONView missing key");
    assert(output.indexOf("value") >= 0, "JSONView missing value");
    
    writeln("✓ JSONView tests passed");
}

// Test HTMLView
unittest {
    import std.stdio : writeln;
    writeln("\n=== Testing HTMLView ===");

    auto model = new Model();
    model.set("content", "test");
    
    auto view = new HTMLView(model, "test-class");
    auto output = view.render();
    
    import std.string : indexOf;
    assert(output.indexOf("<div") >= 0, "HTMLView missing div tag");
    assert(output.indexOf("test-class") >= 0, "HTMLView missing CSS class");
    
    writeln("✓ HTMLView tests passed");
}

// Test Controller
unittest {
    import std.stdio : writeln;
    writeln("\n=== Testing Controller ===");

    auto model = new Model();
    auto view = new View(model);
    auto controller = new Controller(model, view);
    
    // Test model/view association
    assert(controller.getModel() is model, "Controller model association failed");
    assert(controller.getView() is view, "Controller view association failed");
    
    // Test action registration
    bool actionCalled = false;
    controller.registerAction("test", (params) {
        actionCalled = true;
        return ["result": "success"];
    });
    
    auto result = controller.executeAction("test");
    assert(actionCalled, "Action not called");
    assert(result == "success", "Action result incorrect");
    
    writeln("✓ Controller tests passed");
}

// Test RESTController
unittest {
    import std.stdio : writeln;
    writeln("\n=== Testing RESTController ===");

    auto model = new Model();
    auto view = new View(model);
    auto controller = new RESTController(model, view);
    
    // Test create action
    controller.executeAction("create", ["name": "Test", "value": "123"]);
    assert(model.get("name") == "Test", "RESTController create failed");
    
    // Test update action
    controller.executeAction("update", ["id": "1", "name": "Updated"]);
    assert(model.get("name") == "Updated", "RESTController update failed");
    
    writeln("✓ RESTController tests passed");
}

// Test ValidationController
unittest {
    import std.stdio : writeln;
    writeln("\n=== Testing ValidationController ===");

    auto controller = new ValidationController();
    
    // Add validation rule
    controller.addValidationRule((input) {
        return "required_field" in input;
    });
    
    // Test validation
    assert(!controller.validateInput(["other": "value"]), "Validation should fail");
    assert(controller.validateInput(["required_field": "value"]), "Validation should pass");
    
    writeln("✓ ValidationController tests passed");
}

// Test AsyncController
unittest {
    import std.stdio : writeln;
    writeln("\n=== Testing AsyncController ===");

    auto controller = new AsyncController();
    
    bool beforeCalled = false;
    bool afterCalled = false;
    
    controller.before((action, params) {
        beforeCalled = true;
    });
    
    controller.after((action, params, result) {
        afterCalled = true;
    });
    
    controller.registerAction("test", (params) {
        return ["result": "done"];
    });
    
    controller.executeAction("test");
    
    assert(beforeCalled, "Before callback not called");
    assert(afterCalled, "After callback not called");
    
    writeln("✓ AsyncController tests passed");
}

// Test ObservableModel
unittest {
    import std.stdio : writeln;
    writeln("\n=== Testing ObservableModel ===");

    auto model = new ObservableModel();
    
    bool beforeCalled = false;
    bool afterCalled = false;
    string capturedKey;
    string capturedValue;
    
    model.onBeforeChange((key, oldVal, newVal) {
        beforeCalled = true;
        capturedKey = key;
        capturedValue = newVal;
    });
    
    model.onAfterChange((key, newVal) {
        afterCalled = true;
    });
    
    model.set("test", "value");
    
    assert(beforeCalled, "Before change callback not called");
    assert(afterCalled, "After change callback not called");
    assert(capturedKey == "test", "Captured key incorrect");
    assert(capturedValue == "value", "Captured value incorrect");
    
    writeln("✓ ObservableModel tests passed");
}

// Test MVCApplication
unittest {
    import std.stdio : writeln;
    writeln("\n=== Testing MVCApplication ===");

    auto app = createMVCApplication();
    
    // Test initialization
    assert(app.getModel() !is null, "App model not initialized");
    assert(app.getView() !is null, "App view not initialized");
    assert(app.getController() !is null, "App controller not initialized");
    
    // Test run
    auto output = app.run(["action": "index"]);
    assert(output.length > 0, "App run failed");
    
    writeln("✓ MVCApplication tests passed");
}

// Test Model-View synchronization
unittest {
    import std.stdio : writeln;
    writeln("\n=== Testing Model-View Synchronization ===");

    auto model = new Model();
    auto view = new View(model);
    
    int updateCount = 0;
    
    // Create custom view that counts updates
    class CountingView : View {
        int* counter;
        
        this(IModel model, int* cnt) {
            super(model);
            counter = cnt;
        }
        
        override void update(IModel model) {
            (*counter)++;
            super.update(model);
        }
    }
    
    auto countingView = new CountingView(model, &updateCount);
    
    // Changing model should trigger view update
    model.set("key", "value");
    assert(updateCount > 0, "View not updated when model changed");
    
    writeln("✓ Model-View synchronization tests passed");
}

// Test DataModel with typed data
unittest {
    import std.stdio : writeln;
    writeln("\n=== Testing DataModel ===");

    auto model = new DataModel!int(42);
    assert(model.getTypedData() == 42, "DataModel initial value failed");
    
    model.setTypedData(100);
    assert(model.getTypedData() == 100, "DataModel setTypedData failed");
    
    writeln("✓ DataModel tests passed");
}

// Integration test
unittest {
    import std.stdio : writeln;
    writeln("\n=== Testing Full MVC Integration ===");

    // Create components
    auto model = new Model();
    auto view = new TemplateView(model, "User: {{username}}, Status: {{status}}");
    auto controller = new RESTController(model, view);
    
    // Register custom action
    controller.registerAction("register", (params) {
        string username = params.get("username", "");
        if (username.length > 0) {
            controller.getModel().set("username", username);
            controller.getModel().set("status", "registered");
            return ["result": "User registered"];
        }
        return ["result": "Registration failed"];
    });
    
    // Execute action
    auto result = controller.executeAction("register", ["username": "testuser"]);
    assert(result == "User registered", "Integration test action failed");
    
    // Verify model
    assert(model.get("username") == "testuser", "Integration test model update failed");
    assert(model.get("status") == "registered", "Integration test status failed");
    
    // Verify view
    auto output = view.render();
    import std.string : indexOf;
    assert(output.indexOf("testuser") >= 0, "Integration test view failed");
    
    writeln("✓ Full MVC integration tests passed");
}

void main() {
    import std.stdio : writeln;
    
    writeln("\n╔════════════════════════════════════════╗");
    writeln("║   MVC Pattern Test Suite              ║");
    writeln("╚════════════════════════════════════════╝");
    
    writeln("\n✅ All MVC pattern tests completed successfully!");
}
