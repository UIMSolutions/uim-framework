/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.mvc.interfaces.model;

import uim.oop;

@safe:

/**
 * IModel - Interface for the Model component in MVC pattern
 * 
 * The Model represents the data and business logic of the application.
 * It is responsible for managing the data, logic and rules of the application.
 */
interface IModel {
    /**
     * Gets data from the model
     * 
     * Returns: The data managed by this model
     */
    string[string] getData();

    /**
     * Sets data in the model
     * 
     * Params:
     *   data = The data to set in the model
     */
    void setData(string[string] data);

    /**
     * Gets a specific value from the model by key
     * 
     * Params:
     *   key = The key to retrieve
     * 
     * Returns: The value associated with the key, or null if not found
     */
    string get(string key);

    /**
     * Sets a specific value in the model
     * 
     * Params:
     *   key = The key to set
     *   value = The value to associate with the key
     */
    void set(string key, string value);

    /**
     * Validates the model data
     * 
     * Returns: true if the model data is valid, false otherwise
     */
    bool validate();

    /**
     * Notifies all attached views that the model has changed
     */
    void notifyViews();

    /**
     * Attaches a view to this model
     * 
     * Params:
     *   view = The view to attach
     */
    void attachView(IView view);

    /**
     * Detaches a view from this model
     * 
     * Params:
     *   view = The view to detach
     */
    void detachView(IView view);
}