/*********************************************************************************************************
	Copyright: © 2015-2026 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.oop.patterns.mvc.interfaces;

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

/**
 * IView - Interface for the View component in MVC pattern
 * 
 * The View is responsible for presenting the model data to the user
 * and receiving user input. It should not contain business logic.
 */
interface IView {
    /**
     * Renders the view with the current model data
     * 
     * Returns: The rendered output as a string
     */
    string render();

    /**
     * Updates the view when the model changes
     * 
     * Params:
     *   model = The model that has changed
     */
    void update(IModel model);

    /**
     * Sets the controller for this view
     * 
     * Params:
     *   controller = The controller to associate with this view
     */
    void setController(IController controller);

    /**
     * Gets the controller associated with this view
     * 
     * Returns: The associated controller
     */
    IController getController();

    /**
     * Gets the model associated with this view
     * 
     * Returns: The associated model
     */
    IModel getModel();

    /**
     * Sets the model for this view
     * 
     * Params:
     *   model = The model to associate with this view
     */
    void setModel(IModel model);
}

/**
 * IController - Interface for the Controller component in MVC pattern
 * 
 * The Controller acts as an intermediary between Model and View.
 * It processes user input, updates the model, and selects views.
 */
interface IController {
    /**
     * Handles user input/request
     * 
     * Params:
     *   input = The user input to process
     * 
     * Returns: The response after processing the input
     */
    string handleRequest(string[string] input);

    /**
     * Sets the model for this controller
     * 
     * Params:
     *   model = The model to control
     */
    void setModel(IModel model);

    /**
     * Gets the model controlled by this controller
     * 
     * Returns: The associated model
     */
    IModel getModel();

    /**
     * Sets the view for this controller
     * 
     * Params:
     *   view = The view to control
     */
    void setView(IView view);

    /**
     * Gets the view controlled by this controller
     * 
     * Returns: The associated view
     */
    IView getView();

    /**
     * Executes an action
     * 
     * Params:
     *   action = The name of the action to execute
     *   params = Parameters for the action
     * 
     * Returns: The result of the action
     */
    string executeAction(string action, string[string] params = null);
}

/**
 * IMVCApplication - Interface for MVC application
 * 
 * Represents a complete MVC application with model, view, and controller
 */
interface IMVCApplication {
    /**
     * Initializes the MVC application
     */
    void initialize();

    /**
     * Runs the application with the given input
     * 
     * Params:
     *   input = The input to process
     * 
     * Returns: The output from the application
     */
    string run(string[string] input);

    /**
     * Gets the model of the application
     * 
     * Returns: The application model
     */
    IModel getModel();

    /**
     * Gets the view of the application
     * 
     * Returns: The application view
     */
    IView getView();

    /**
     * Gets the controller of the application
     * 
     * Returns: The application controller
     */
    IController getController();
}
