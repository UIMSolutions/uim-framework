/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.mvc.interfaces.application;

import uim.oop;

@safe:

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
    IMVCModel model();

    /**
     * Gets the view of the application
     * 
     * Returns: The application view
     */
    IView view();

    /**
     * Gets the controller of the application
     * 
     * Returns: The application controller
     */
    IController controller();
}
