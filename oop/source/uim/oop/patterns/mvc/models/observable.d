module uim.oop.patterns.mvc.models.observable;

import uim.oop;

@safe:

/**
 * ObservableModel - Model with additional event support
 * 
 * Extends the base model with before/after change callbacks
 */
class ObservableModel : MVCModel {
    alias BeforeChangeCallback = void delegate(string key, string olUIMValue, string newValue);
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
    override void data(string key, string value) {
        string olUIMValue = _data[key];

        // Call before change callbacks
        foreach (callback; _beforeChangeCallbacks) {
            callback(key, olUIMValue, value);
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