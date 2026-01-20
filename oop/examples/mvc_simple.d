/*********************************************************************************************************
	Copyright: © 2015-2026 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module oop.examples.mvc_simple;

import uim.oop;
import std.stdio;

/**
 * Simple MVC Pattern Example
 * 
 * This example demonstrates the basic usage of the MVC pattern
 * with a simple user management application.
 */

@safe:

void runSimpleMVCExample() {
    writeln("\n╔════════════════════════════════════════╗");
    writeln("║   Simple MVC Pattern Example          ║");
    writeln("╚════════════════════════════════════════╝\n");

    // 1. Create the Model
    writeln("1. Creating Model...");
    auto model = new Model();
    model.set("username", "john_doe");
    model.set("email", "john@example.com");
    model.set("role", "admin");
    writeln("   ✓ Model created with user data\n");

    // 2. Create the View with a template
    writeln("2. Creating View with template...");
    auto view = new TemplateView(
        model, 
        "User Profile\n" ~
        "------------\n" ~
        "Username: {{username}}\n" ~
        "Email: {{email}}\n" ~
        "Role: {{role}}"
    );
    writeln("   ✓ View created\n");

    // 3. Create the Controller
    writeln("3. Creating RESTful Controller...");
    auto controller = new RESTController(model, view);
    writeln("   ✓ Controller created\n");

    // 4. Display initial state
    writeln("4. Initial State:");
    writeln("──────────────────────────────────────");
    writeln(view.render());
    writeln();

    // 5. Update through controller
    writeln("5. Updating user role through controller...");
    controller.executeAction("update", [
        "id": "1",
        "role": "moderator"
    ]);
    writeln("   ✓ Update executed\n");

    // 6. Display updated state (view automatically reflects changes)
    writeln("6. Updated State:");
    writeln("──────────────────────────────────────");
    writeln(view.render());
    writeln();

    // 7. Create a JSON view for API response
    writeln("7. Creating JSON View for API...");
    auto jsonView = new JSONView(model);
    writeln("   API Response:");
    writeln("   " ~ jsonView.render());
    writeln();

    // 8. Create an HTML view
    writeln("8. Creating HTML View...");
    auto htmlView = new HTMLView(model, "user-profile");
    writeln("   HTML Output:");
    writeln("   " ~ htmlView.render());
    writeln();

    // 9. Demonstrate Observable Model
    writeln("9. Demonstrating Observable Model with callbacks...");
    auto observableModel = new ObservableModel();
    
    observableModel.onBeforeChange((key, oldVal, newVal) {
        writeln("   Before: Changing ", key, " from '", oldVal, "' to '", newVal, "'");
    });
    
    observableModel.onAfterChange((key, newVal) {
        writeln("   After: ", key, " is now '", newVal, "'");
    });
    
    observableModel.set("status", "active");
    writeln();

    // 10. Create complete MVC application
    writeln("10. Creating complete MVC Application...");
    auto app = createMVCApplication();
    
    auto result = app.run([
        "action": "create",
        "title": "New Task",
        "priority": "high"
    ]);
    
    writeln("   Application Response: ", result);
    writeln("   ✓ MVC Application executed successfully\n");

    writeln("╔════════════════════════════════════════╗");
    writeln("║   MVC Example Completed Successfully  ║");
    writeln("╚════════════════════════════════════════╝\n");
}

version(example_mvc_simple) {
    void main() {
        runSimpleMVCExample();
    }
}
