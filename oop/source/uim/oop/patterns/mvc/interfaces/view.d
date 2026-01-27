/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.mvc.interfaces.view;

import uim.oop;

@safe:

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