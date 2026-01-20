/*********************************************************************************************************
	Copyright: © 2015-2026 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.oop.patterns.mvc.model;

import uim.oop;

@safe:

/**
 * Model - Base implementation of the Model component in MVC pattern
 * 
 * This class provides a basic implementation of IModel with support for:
 * - Data storage and retrieval
 * - Observer pattern for view notifications
 * - Validation hooks
 */
class Model : IModel {
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
    string[string] getData() {
        return _data.dup;
    }

    /**
     * Sets all data in the model
     * 
     * Params:
     *   data = The data to set
     */
    void setData(string[string] data) {
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
    string get(string key) {
        return _data.get(key, null);
    }

    /**
     * Sets a specific value in the model
     * 
     * Params:
     *   key = The key to set
     *   value = The value to set
     */
    void set(string key, string value) {
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
        view.setModel(this);
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

/**
 * DataModel - Enhanced model with typed data support
 * 
 * This is a more advanced model that supports various data operations
 */
class DataModel(T) : Model {
    protected T _typedData;

    this() {
        super();
    }

    this(T initialData) {
        super();
        _typedData = initialData;
    }

    /**
     * Gets the typed data
     * 
     * Returns: The typed data stored in this model
     */
    T getTypedData() {
        return _typedData;
    }

    /**
     * Sets the typed data
     * 
     * Params:
     *   data = The typed data to set
     */
    void setTypedData(T data) {
        _typedData = data;
        notifyViews();
    }
}

/**
 * ObservableModel - Model with additional event support
 * 
 * Extends the base model with before/after change callbacks
 */
class ObservableModel : Model {
    alias BeforeChangeCallback = void delegate(string key, string oldValue, string newValue);
    alias AfterChangeCallback = void delegate(string key, string newValue);

    protected BeforeChangeCallback[] _beforeChangeCallbacks;
    protected AfterChangeCallback[] _afterChangeCallbacks;

    this(string[string] initialData = null) {
        super(initialData);
    }

    /**
     * Registers a before change callback
     * 
     * Params:
     *   callback = The callback to register
     */
    void onBeforeChange(BeforeChangeCallback callback) {
        _beforeChangeCallbacks ~= callback;
    }

    /**
     * Registers an after change callback
     * 
     * Params:
     *   callback = The callback to register
     */
    void onAfterChange(AfterChangeCallback callback) {
        _afterChangeCallbacks ~= callback;
    }

    /**
     * Sets a value with callback support
     * 
     * Params:
     *   key = The key to set
     *   value = The value to set
     */
    override void set(string key, string value) {
        string oldValue = get(key);

        // Call before change callbacks
        foreach (callback; _beforeChangeCallbacks) {
            callback(key, oldValue, value);
        }

        // Set the value
        _data[key] = value;

        // Call after change callbacks
        foreach (callback; _afterChangeCallbacks) {
            callback(key, value);
        }

        notifyViews();
    }
}

// Unit tests
unittest {
    import std.stdio : writeln;

    // Test basic model
    auto model = new Model();
    model.set("name", "Test");
    assert(model.get("name") == "Test");

    auto data = model.getData();
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

    model.set("test", "value");
    assert(beforeCalled);
    assert(afterCalled);
}
