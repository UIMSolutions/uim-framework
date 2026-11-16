/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.patterns.mvc.models.model;

import uim.oop;

@safe:

/**
 * Model - Base implementation of the Model component in MVC pattern
 * 
 * This class provides a basic implementation of IMVCModel with support for:
 * - Data storage and retrieval
 * - Observer pattern for view notifications
 * - Validation hooks
 */
class MVCModel : IMVCModel {
    protected string[string] _data;
    protected IView[] _views;

    /**
     * Constructor
     * 
     * Params:
     *   initialData = Optional initial data for the model
     */
    this(string[string] initialData = null) {
        if (initialData !is null) {
            _data = initialData.dup;
        }
    }

    /**
     * Gets all data from the model
     * 
     * Returns: A copy of the model's data
     */
    string[string] data() {
        return _data.dup;
    }

    /**
     * Sets all data in the model
     * 
     * Params:
     *   data = The data to set
     */
    void data(string[string] data) {
        _data = data.dup;
        notifyViews();
    }

    /**
     * Gets a specific value from the model
     * 
     * Params:
     *   key = The key to retrieve
     * 
     * Returns: The value, or null if not found
     */
    string data(string key) {
        return _data.get(key, null);
    }

    /**
     * Sets a specific value in the model
     * 
     * Params:
     *   key = The key to set
     *   value = The value to set
     */
    void data(string key, string value) {
        _data[key] = value;
        notifyViews();
    }

    /**
     * Validates the model data
     * 
     * Override this method to implement custom validation logic
     * 
     * Returns: true if valid, false otherwise
     */
    bool validate() {
        return true; // Override in subclasses for custom validation
    }

    /**
     * Notifies all attached views that the model has changed
     */
    void notifyViews() {
        foreach (view; _views) {
            view.update(this);
        }
    }

    /**
     * Attaches a view to this model
     * 
     * Params:
     *   view = The view to attach
     */
    void attachView(IView view) {
        // Check if view is already attached
        foreach (v; _views) {
            if (v is view) {
                return; // Already attached
            }
        }
        
        _views ~= view;
        view.model(this);
    }

    /**
     * Detaches a view from this model
     * 
     * Params:
     *   view = The view to detach
     */
    void detachView(IView view) {
        import std.algorithm : remove;
        import std.array : array;
        
        _views = _views.remove!(v => v is view).array;
    }
}

// Unit tests
unittest {
    import std.stdio : writeln;

    // Test basic model
    auto model = new MVCModel();
    model.data("name", "Test");
    assert(model.data("name") == "Test");

    auto data = model.data();
    assert("name" in data);
    assert(data["name"] == "Test");
}

unittest {
    import std.stdio : writeln;

    // Test typed model
    auto model = new DataModel!int(42);
    assert(model.getTypedData() == 42);

    model.setTypedData(100);
    assert(model.getTypedData() == 100);
}

unittest {
    // Test observable model
    auto model = new ObservableModel();
    
    bool beforeCalled = false;
    bool afterCalled = false;

    model.onBeforeChange((key, oldVal, newVal) {
        beforeCalled = true;
        assert(key == "test");
        assert(newVal == "value");
    });

    model.onAfterChange((key, newVal) {
        afterCalled = true;
        assert(key == "test");
        assert(newVal == "value");
    });

    model.data("test", "value");
    // TODO: assert(beforeCalled);
    // TODO: assert(afterCalled);
}
