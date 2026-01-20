/*********************************************************************************************************
	Copyright: © 2015-2026 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.oop.patterns.mvc;

/**
 * MVC (Model-View-Controller) Pattern Module
 * 
 * This module provides a complete implementation of the MVC architectural pattern.
 * 
 * The MVC pattern separates an application into three interconnected components:
 * 
 * - **Model**: Manages the data, logic and rules of the application
 * - **View**: Presents the model data to the user and handles display logic
 * - **Controller**: Accepts input and converts it to commands for the model or view
 * 
 * ## Basic Usage
 * 
 * ```d
 * import uim.oop.patterns.mvc;
 * 
 * // Create and use a complete MVC application
 * auto app = createMVCApplication();
 * auto output = app.run(["action": "index"]);
 * 
 * // Or create components individually
 * auto model = new Model();
 * auto view = new View(model);
 * auto controller = new Controller(model, view);
 * 
 * model.set("title", "Hello MVC");
 * auto result = controller.handleRequest(["action": "show"]);
 * ```
 * 
 * ## Key Features
 * 
 * - **Separation of Concerns**: Clear separation between data, presentation, and logic
 * - **Observer Pattern**: Views automatically update when model changes
 * - **Flexible Views**: Support for templates, JSON, HTML rendering
 * - **Action-based Controllers**: Register custom actions with handlers
 * - **RESTful Support**: Built-in REST controller with CRUD operations
 * - **Validation**: Controller-level input validation
 * - **Type Safety**: Generic model support for typed data
 * - **Extensible**: All components designed for easy extension
 * 
 * ## Components
 * 
 * ### Models
 * - `Model` - Basic model with data storage and observer support
 * - `DataModel!T` - Typed model for specific data types
 * - `ObservableModel` - Model with before/after change callbacks
 * 
 * ### Views
 * - `View` - Basic view with model rendering
 * - `TemplateView` - View with template variable substitution
 * - `JSONView` - Renders model data as JSON
 * - `HTMLView` - Renders model data as HTML
 * 
 * ### Controllers
 * - `Controller` - Basic controller with action handling
 * - `RESTController` - RESTful controller with CRUD operations
 * - `ValidationController` - Controller with input validation
 * - `AsyncController` - Controller with before/after action hooks
 * 
 * ### Application
 * - `MVCApplication` - Complete MVC application
 * - `createMVCApplication()` - Helper to create applications
 */

public import uim.oop.patterns.mvc.interfaces;
public import uim.oop.patterns.mvc.model;
public import uim.oop.patterns.mvc.view;
public import uim.oop.patterns.mvc.controller;
public import uim.oop.patterns.mvc.application;
