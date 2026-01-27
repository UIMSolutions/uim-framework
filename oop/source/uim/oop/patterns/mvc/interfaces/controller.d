/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.mvc.interfaces.controller;

import uim.oop;

@safe:


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