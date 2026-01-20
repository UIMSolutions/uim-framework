/*********************************************************************************************************
	Copyright: © 2015-2026 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module oop.examples.mvc_todolist;

import uim.oop;
import std.stdio;

/**
 * Example: Todo List Application using MVC Pattern
 * 
 * This example demonstrates how to build a simple todo list application
 * using the MVC pattern with a RESTful controller.
 */

@safe:

/**
 * TodoModel - Model for managing todo items
 */
class TodoModel : Model {
    private int _nextId = 1;

    this() {
        super();
    }

    /**
     * Adds a new todo item
     */
    void addTodo(string title, string description = "") {
        import std.conv : to;
        
        string id = _nextId.to!string;
        set("todo_" ~ id ~ "_title", title);
        set("todo_" ~ id ~ "_description", description);
        set("todo_" ~ id ~ "_status", "pending");
        _nextId++;
    }

    /**
     * Marks a todo as completed
     */
    void completeTodo(string id) {
        set("todo_" ~ id ~ "_status", "completed");
    }

    /**
     * Gets all todos
     */
    string[] getTodos() {
        import std.algorithm : filter, map;
        import std.array : array;
        
        string[] result;
        auto data = getData();
        
        foreach (key, value; data) {
            import std.string : indexOf;
            if (key.indexOf("_title") > 0) {
                result ~= value;
            }
        }
        
        return result;
    }
}

/**
 * TodoView - View for displaying todo items
 */
class TodoView : View {
    this(IModel model) {
        super(model);
    }

    override string render() {
        import std.array : appender;
        
        auto result = appender!string();
        result.put("=== Todo List ===\n\n");
        
        auto data = _model.getData();
        
        // Group todos by ID
        int[string] todoIds;
        foreach (key, value; data) {
            import std.string : indexOf, split;
            import std.conv : to;
            
            if (key.indexOf("todo_") == 0) {
                auto parts = key.split("_");
                if (parts.length >= 2) {
                    todoIds[parts[1]] = 1;
                }
            }
        }
        
        // Display each todo
        foreach (id, _; todoIds) {
            string title = _model.get("todo_" ~ id ~ "_title");
            string description = _model.get("todo_" ~ id ~ "_description");
            string status = _model.get("todo_" ~ id ~ "_status");
            
            if (title !is null) {
                result.put("[");
                result.put(id);
                result.put("] ");
                
                if (status == "completed") {
                    result.put("[✓] ");
                } else {
                    result.put("[ ] ");
                }
                
                result.put(title);
                
                if (description.length > 0) {
                    result.put("\n    ");
                    result.put(description);
                }
                
                result.put("\n");
            }
        }
        
        return result.data;
    }
}

/**
 * TodoController - Controller for todo operations
 */
class TodoController : RESTController {
    this(IModel model, IView view) {
        super(model, view);
        registerTodoActions();
    }

    private void registerTodoActions() {
        // Add todo action
        registerAction("add", (params) {
            string title = params.get("title", "");
            string description = params.get("description", "");
            
            if (title.length > 0) {
                auto todoModel = cast(TodoModel)_model;
                if (todoModel !is null) {
                    todoModel.addTodo(title, description);
                    return ["result": "Todo added successfully"];
                }
            }
            
            return ["result": "Failed to add todo"];
        });

        // Complete todo action
        registerAction("complete", (params) {
            string id = params.get("id", "");
            
            if (id.length > 0) {
                auto todoModel = cast(TodoModel)_model;
                if (todoModel !is null) {
                    todoModel.completeTodo(id);
                    return ["result": "Todo completed"];
                }
            }
            
            return ["result": "Failed to complete todo"];
        });

        // List todos action
        registerAction("list", (params) {
            return ["result": "Listing todos"];
        });
    }
}

/**
 * Example demonstrating the todo list application
 */
void runTodoListExample() {
    writeln("\n=== Todo List MVC Example ===\n");

    // Create MVC components
    auto model = new TodoModel();
    auto view = new TodoView(model);
    auto controller = new TodoController(model, view);

    // Add some todos
    writeln("Adding todos...");
    controller.executeAction("add", [
        "title": "Learn D programming",
        "description": "Study the D language features"
    ]);
    
    controller.executeAction("add", [
        "title": "Implement MVC pattern",
        "description": "Build a complete MVC implementation"
    ]);
    
    controller.executeAction("add", [
        "title": "Write documentation"
    ]);

    // Display todos
    writeln("\n" ~ view.render());

    // Complete a todo
    writeln("Completing todo #1...");
    controller.executeAction("complete", ["id": "1"]);

    // Display updated todos
    writeln("\n" ~ view.render());
}

version(example_mvc) {
    void main() {
        runTodoListExample();
    }
}
