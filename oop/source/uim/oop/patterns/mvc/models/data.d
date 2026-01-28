module uim.oop.patterns.mvc.models.data;

import uim.oop;

@safe:

/**
 * DataModel - Enhanced model with typed data support
 * 
 * This is a more advanced model that supports various data operations
 */
class DataModel(T) : MVCModel {
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