/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.errors.classes.errors.renderers.error;

import uim.errors;
mixin(ShowModule!());

@safe:

/**
 * Error Renderer.
 *
 * Captures and handles all unhandled errors. Displays helpful framework errors when debug is true.
 * When debug is false a ErrorRenderer will render 404 or 500 errors. If an uncaught error is thrown
 * and it is a type that ErrorHandler does not know about it will be treated as a 500 error.
 *
 * #### Using a subclass of ErrorRenderer
 */

class UIMErrorRenderer : UIMObject, IErrorRenderer {
  mixin(ErrorRendererThis!());

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    return true;
  }
  
  // Template to render 
  protected string _template = "";

  // The method corresponding to the Error this object is for.
  protected string method = "";

  // The error being handled.
  protected IError _error;

  // Controller instance.
  /*  protected IController controller; */

  // Render output for the provided error.
  string render(IError error, bool shouldDebug) {
    return null;
  }

  // Write output to the renderer`s output stream
  IErrorRenderer write(string outputText) {
    // writeln(outputText);
    return this;
  }

  Json[string] attributes() {
    return null;
  }

  /**
     * If set, this will be request used to create the controller that will render
     * the error.
     */
  /* protected IServerRequest _request; */

  /**
     * MapHelper of errors to http status codes.
     *
     * This can be customized for users that don"t want specific errors to throw 404 errors
     * or want their application errors to be automatically converted.
     *
     * @var array<string, int>
     * @psalm-var array<class-string<\Throwable>, int>
     */
  /* protected int[string] myErrorHttpCodes = [
        // Controller errors
        InvalidParameterError.classname: 404,
        MissingActionError.classname: 404,
        // Datasource errors
        PageOutOfBoundsError.classname: 404,
        RecordNotFounUIMError.classname: 404,
        // Http errors
        MissingControllerError.classname: 404,
        // Routing errors
        MissingRouteError.classname: 404,
    ]; */

  // Creates the controller to perform rendering on the error response.
  /* this(Throwable error, IServerRequest serverRequest = null) {
        _error = error;
        _request = serverRequest;
        _controller = _getController();
    } */

  /**
     * Get the controller instance to handle the error.
     * Override this method in subclasses to customize the controller used.
     * This method returns the built in `ErrorController` normally, or if an error is repeated
     * a bare controller will be used.
     */
  protected IErrorController _getController() {
    /* auto _request = _request;
        auto routerRequest = Router.getRequest();
        // Fallback to the request in the router or make a new one from
        // _SERVER
        if (_request.isNull) {
            _request = routerRequest ? routerRequest: ServerRequestFactory.fromGlobals();
        }

        // If the current request doesn"t have routing data, but we
        // found a request in the router context copy the params over
        if (_request.getParam("controller").isNull && routerRequest  !is null) {
            _request = _request.withAttribute("params", routerRequest.getAttribute("params"));
        }

        _errorOccured = false;
            IController controller;
        try {
            auto params = _request.getAttribute("params");
            params.set("controller", "Error");

            auto factory = new DControllerFactory(new UIMContainer());
            string myClass = factory.controllerClass(_request.withAttribute("params", params));

            if (myClass.isEmpty) {
                myClass = App.classname("Error", "Controller", "Controller");
            }

            auto controller = new myClass(_request);
            controller.startupProcess();
        } catch (Throwable throwable) {
            _errorOccured = true;
        }

        if (controller.isNull) {
            return new DController(_request);
        } */

    // Retry RequestHandler, as another aspect of startupProcess()
    // could have failed. Ignore any errors out of startup, as
    // there could be userland input data parsers.
    /* if (_errorOccured && controller.RequestHandler !is null) {
            try {
                myEvent = new DEvent("Controller.startup", controller);
                controller.RequestHandler.startup(myEvent);
            } catch (Throwable throwable) {
            }
        }

        return controller; */

    return null;
  }

  // Clear output buffers so error pages display properly.
  protected void clearOutput() {
    /*         if (hasAllValue(D_SAPI, ["cli", "Ddbg"])) {
            return;
        }
        while (ob_get_level()) {
            ob_end_clean();
        } */
  }

  // Renders the response for the error.
  /* IResponse render() {
        /* auto myError = _error;
        code = getHttpCode(myError);
        method = methodName(myError);
        myTemplate = templateName(myError, method, code);
        clearOutput();

        if (hasMethod(this, method)) {
            return _customMethod(method, myError);
        }

        auto myMessage = errorMessage(myError, code);
        auto myUrl = _controller.getRequest().getRequestTarget();
        auto response = _controller.getResponse();

        if (cast(UIMError)myError) {
            /** @psalm-suppress DeprecatedMethod * /
            foreach (/* (array) * /myError.responseHeader() as myKey: myValue) {
                response = response.withHeader(myKey, myValue);
            }
        }
        if (cast(HttpError)myError) {
            myError.getHeaders().byKeyValue.each!(kv => response = response.withHeader(kv.key, kv.value));
        }
        auto response = response.withStatus(code);
        auto viewVars = [
            "message": myMessage,
            "url": h(myUrl),
            "error": myError,
            "code": code,
        ];

        auto serialize = ["message", "url", "code"];
        if (Configure.hasKey("debug")) {
            trace = /* (array) * /Debugger.formatTrace(myError.getTrace(), [
                "format": "array",
                "args": false,
            ]);
            origin = [
                "file": myError.getFile() ?: "null",
                "line": myError.getLine() ?: "null",
            ];
            // Traces don"t include the origin file/line.
            trace.unshift(origin);
            viewVars.set("trace", trace);
            viewVars += origin;
            serialize ~= "file";
            serialize ~= "line";
        }

        _controller.set(viewVars);
        _controller.viewBuilder().setOption("serialize", serialize);

        if (cast(UIMError)myError && Configure.hasKey("debug")) {
            _controller.set(myError.getAttributes());
        }
        _controller.setResponse(response);

        return _outputMessage(myTemplate); * /
        return null; 
    } */

  // Render a custom error method/template.
  /* protected IResponse _customMethod(string methodToInvoke, Throwable myErrorToRender) {
        /* myResult = this.{method}(myError);
        _shutdown();

        return !myResult.isString
            ? myResult
            : _controller.getResponse().withStringBody(myResult); * /
        return null; 
    } */

  // Get method name
  protected string methodName(Throwable myError) {
    /* [, baseClass] = moduleSplit(get_class(myError));

        if (subString(baseClass, -9) == "Error") {
            baseClass = subString(baseClass, 0, -9);
        }

        // baseClass would be an empty string if the error class is \Error.
        _method = baseClass is null ? "error500" : Inflector.variable(baseClass);

        return _method; */
    return null;
  }

  // Get error message.
  protected string errorMessage(Throwable throwableError, int errorCode) {
    // auto myMessage = throwableError.message();

    /*         if (
            !Configure.read("debug") &&
            !(cast(HttpError)throwableError)
       ) {
            myMessage = errorCode < 500
                ? __d("uim", "Not Found")
                : __d("uim", "An Internal Error Has Occurred.");
        } */

    // return myMessage;
    return null;
  }

  // Get template for rendering error info.
  protected string templateName(Throwable throwableError, string methodName, int errorCode) {
    /*         if (cast(HttpError)throwableError || !Configure.read("debug")) {
            return _template = errorCode < 500 ? "error400" : "error500";
        }

        return cast(PDOError)throwableError
            ? "pdo_error"
            : methodName; */

    return null;
  }

  // Gets the appropriate http status code for error.
  protected int getHttpCode(Throwable throwableError) {
    /* return cast(HttpError)error
            ? throwableError.code()
            : _errorHttpCodesgetInteger(get_class(throwableError), 500); */

    return 0;
  }

  // Generate the response using the controller object.
  /* protected IResponse _outputMessage(string templateName) {
        try {
            _controller.render(templateName);

            return _shutdown();
        } catch (MissingTemplateError miisngTemplateExecution) {
            attributes = miisngTemplateExecution.getAttributes();
            return cast(MissingLayoutError)miisngTemplateExecution  ||
                attributes.getString("file").hasKey("error500")
                ? _outputMessageSafe("error500")
                : _outputMessage("error500");
        } catch (MissingPluginError missngPluginExecution) {
            attributes = missngPluginExecution.getAttributes();
            if (attributes.hasKey("plugin") && attributes["plugin"] == _controller.getPlugin()) {
                _controller.setPlugin(null);
            }

            return _outputMessageSafe("error500");
        } catch (Throwable throwable) {
            return _outputMessageSafe("error500");
        }
    } */

  /**
     * A safer way to render error messages, replaces all helpers, with basics
     * and doesn"t call component methods.
     */
  /* protected IResponse _outputMessageSafe(string templateToRender) {
        auto myBuilder = _controller.viewBuilder();
        myBuilder
            .setHelpers([], false)
            .setLayoutPath("")
            .setTemplatePath("Error");
        view = _controller.createView("View");

        auto response = _controller.getResponse()
            .withType("html")
            .withStringBody(view.render(templateToRender, "error"));
        _controller.setResponse(response);

        return response;
    } */

  /**
     * Run the shutdown events.
     *
     * Triggers the afterFilter and afterDispatch events.
     */
  /* protected IResponse _shutdown() {
        _controller.dispatchEvent("Controller.shutdown");

        return _controller.getResponse();
    } */

  // Returns an array that can be used to describe the internal state of this object.
  override Json[string] debugInfo(string[] showKeys = null, string[] hideKeys = null) {
    auto result = super.debugInfo(showKeys, hideKeys);
    result["template"] = _template.toJson;
    result["method"] = method.toJson;
    return result;
  }

}

/* Old code
/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
***************************************************************************************************************** /
module uim.errors.classes.errors.renderer;

import uim.errors;
mixin(ShowModule!());
@safe:


/**
 * Error Renderer.
 *
 * Captures and handles all unhandled errors. Displays helpful framework errors when debug is true.
 * When debug is false a ErrorRenderer will render 404 or 500 errors. If an uncaught error is thrown
 * and it is a type that ErrorHandler does not know about it will be treated as a 500 error.
 *
 * ### Implementing application specific error rendering
 *
 * You can implement application specific error handling by creating a subclass of
 * ErrorRenderer and configure it to be the `errorRenderer` in config/error.D
 *
 * #### Using a subclass of ErrorRenderer
 *
 * Using a subclass of ErrorRenderer gives you full control over how Errors are rendered, you
 * can configure your class in your config/app.D.
 * /
class UIMErrorRenderer { // }: IErrorRenderer
  this() {
    initialize();
  }

  /* override  * /
  bool initialize(Json[string] initData = null) {
    /* if (!super.initialize(initData)) {
            return false;
        } * /

    // _allMethods = [__traits(allMembers, DORMTable)];

    return true;
  }

  // The error being handled.
  protected Throwable myError;

  // Controller instance.
  // protected IErrorController controller;

  // Template to render for {@link uim.Core\errors.UIMError}
  protected string _template = "";

  // The method corresponding to the Error this object is for.
  protected string method = "";

  // If set, this will be request used to create the controller that will render the error.
  /* protected IServerRequest _request; * /

  /**
     * MapHelper of errors to http status codes.
     *
     * This can be customized for users that don"t want specific errors to throw 404 errors
     * or want their application errors to be automatically converted.
     *
     * @var array<string, int>
     * @psalm-var array<class-string<\Throwable>, int>
     * /
  protected int[string] myErrorHttpCodes; /*  = [
        // Controller errors
        InvalidParameterError.classname: 404,
        MissingActionError.classname: 404,
        // Datasource errors
        PageOutOfBoundsError.classname: 404,
        RecordNotFounUIMError.classname: 404,
        // Http errors
        MissingControllerError.classname: 404,
        // Routing errors
        MissingRouteError.classname: 404,
    ]; * /

  // Creates the controller to perform rendering on the error response.
  /* this(Throwable error, IServerRequest serverRequest = null) {
        _error = error;
        _request = serverRequest;
        _controller = _getController();
    } * /

  /**
     * Get the controller instance to handle the error.
     * Override this method in subclasses to customize the controller used.
     * This method returns the built in `ErrorController` normally, or if an error is repeated
     * a bare controller will be used.
     * /
  protected IErrorController _getController() {
/*     auto _request = this.request;
    auto routerRequest = Router.getRequest(); * /
    // Fallback to the request in the router or make a new one from
    // _SERVER
    /*         if (_request.isNull) {
            _request = routerRequest ?: ServerRequestFactory.fromGlobals();
        }
 * /
    // If the current request doesn"t have routing data, but we
    // found a request in the router context copy the params over
    /*         if (_request.getParam("controller").isNull && routerRequest  !is null) {
            _request = _request.withAttribute("params", routerRequest.getAttribute("params"));
        }

        auto myErrorOccured = false;
        try {
            auo params = _request.getAttribute("params");
            params["controller"] = "Error";

            auto factory = new DControllerFactory(new UIMContainer());
            auto myClass = factory.controllerClass(_request.withAttribute("params", params));

            if (!myClass) {
                /** @var string myClass * /
                myClass = App.classname("Error", "Controller", "Controller");
            }

            /** @var uim.controllers.Controller controller * /
            controller = new myClass(_request);
            controller.startupProcess();
        } catch (Throwable e) {
            myErrorOccured = true;
        }

        if (controller.isNull) {
            return new DController(_request);
        }

 * / // Retry RequestHandler, as another aspect of startupProcess()
    // could have failed. Ignore any errors out of startup, as
    // there could be userland input data parsers.
    /* if (myErrorOccured && controller.RequestHandler !is null) {
      try {
        myEvent = new DEvent("Controller.startup", controller);
        controller.RequestHandler.startup(myEvent);
      } catch (Throwable e) {
      }
    }

    return controller; * /
    return null; 
  }

  // Clear output buffers so error pages display properly.
  protected void clearOutput() {
    /* if (hasAllValue(D_SAPI, ["cli", "Ddbg"])) {
      return;
    }
    while (ob_get_level()) {
      ob_end_clean();
    } * /
  }

  // Renders the response for the error.
  // IResponse render() {
    /* auto error = this.error;
        auto code = getHttpCode(error);
        auto method = methodName(error);
        auto myTemplate = templateName(error, method, code);
        clearOutput();

        if (hasMethod(method)) {
            return _customMethod(method, error);
        }

        auto myMessage = errorMessage(error, code);
        auto myUrl = _controller.getRequest().getRequestTarget();
        auto response = _controller.getResponse(); * /

    /* if (cast(UIMError) error) {
            /** @psalm-suppress DeprecatedMethod * /
    /* foreach (myKey, myValue; /* (array) * /error.responseHeader()) {
                response = response.withHeader(myKey, myValue);
            } * /
        } * /
    /* if (cast(HttpError)error) {
            foreach (myName, myValue; error.getHeaders()) {
                response = response.withHeader(myName, myValue);
            }
        } * /
    /* auto response = response.withStatus(code);

    auto viewVars = [
      "message": myMessage,
      "url": h(myUrl),
      "error": error,
      "code": code,
    ];
    serialize = ["message", "url", "code"];

    isDebug = Configure.read("debug");
    if (isDebug) {
      trace =  /* (array) * / Debugger.formatTrace(error.getTrace(), [
            "format": "array",
            "args": false,
          ]);
      /*             origin = [
                "file": error.getFile() ?: "null",
                "line": error.getLine() ?: "null",
            ];
 * / // Traces don"t include the origin file/line.
      /*             trace.unshift(origin);
            viewVars.set("trace", trace);
            viewVars += origin;
            serialize ~= "file";
            serialize ~= "line";
 * /
    }
    _controller.set(viewVars);
    _controller.viewBuilder().setOption("serialize", serialize);

    if (cast(UIMError) error && isDebug) {
      _controller.set(error.getAttributes());
    }
    _controller.setResponse(response);

    return _outputMessage(myTemplate); * /
  // }

  // Render a custom error method/template.
  /* protected IResponse _customMethod(string methodName, Throwable errorToRender) {
    /*         auto myResult = this.{methodName}(errorToRender);
        _shutdown();
        if (!myResult.isString) { return result; }

        return _controller.getResponse().withStringBody(myResult);
 * /
    return null;
  }
 * /
  // Get method name
  protected string methodName(Throwable error) {
    /*         [, baseClass] = moduleSplit(get_class(error));

        if (subString(baseClass, -9) == "Error") {
            baseClass = subString(baseClass, 0, -9);
        }

        // baseClass would be an empty string if the error class is \Error.
        method = baseClass is null ? "error500" : Inflector.variable(baseClass);

        return _method = method; * /
    return null;
  }

  // Get error message.
  protected string errorMessage(Throwable error, int errorCode) {
    /*         myMessage = error.message();

        if (
            !Configure.read("debug") &&
            !(cast(HttpError)error)
       ) {
            myMessage = errorCode < 500
                ? __d("uim", "Not Found") 
                __d("uim", "An Internal Error Has Occurred.");
        }

        return myMessage; * /
    return null;
  }

  // Get template for rendering error info.
  protected string templateName(Throwable error, string methodName, int errorCode) {
    /*         if (cast(HttpError)error || !Configure.read("debug")) {
            return _template = errorCode < 500 ? "error400" : "error500";
        }

        if (cast(PDOError)error) {
            return _template = "pdo_error";
        }

        return _template = methodName; * /
    return null;
  }

  // Gets the appropriate http status code for error.
  protected int getHttpCode(Throwable error) {
    /* return cast(HttpError)error
            ? error.code()
            : _errorHttpCodes[get_class(error)] ?? 500; * /
    return 0;
  }

  // Generate the response using the controller object.
  /* protected IResponse _outputMessage(string templateToRender) {
        /*         try {
            _controller.render(templateToRender);

            return _shutdown();
        } catch (MissingTemplateError e) {
            attributes = e.getAttributes();
            if (
                cast(MissingLayoutError)e ||
                indexOf(attributes["file"], "error500") == true
           ) {
                return _outputMessageSafe("error500");
            }

            return _outputMessage("error500");
        } catch (MissingPluginError e) {
            attributes = e.getAttributes();
            if (attributes.hasKey("plugin") && attributes["plugin"] == _controller.getPlugin()) {
                _controller.setPlugin(null);
            }

            return _outputMessageSafe("error500");
        } catch (Throwable e) {
            return _outputMessageSafe("error500");
        } * /
        return null;
    } * /

  /**
     * A safer way to render error messages, replaces all helpers, with basics
     * and doesn"t call component methods.
     * /
  /* protected IResponse _outputMessageSafe(string templateToRender) {
        auto myBuilder = _controller.viewBuilder();
        myBuilder
            .setHelpers([], false)
            .setLayoutPath("")
            .setTemplatePath("Error");
        view = _controller.createView("View");

        auto response = _controller.getResponse()
            .withType("html")
            .withStringBody(view.render(templateToRender, "error"));
        _controller.setResponse(response);

        return response;
    } * /

  /**
     * Run the shutdown events.
     * Triggers the afterFilter and afterDispatch events.
     * /
  /* protected IResponse _shutdown() {
    _controller.dispatchEvent("Controller.shutdown");

    return _controller.getResponse();
  } * /

  // Returns an array that can be used to describe the internal state of this object.
Json[string] debugInfo(string[] showKeys = null, string[] hideKeys = null) {
    return super.debugInfo
      .set("error", _error)
      .set("request", _request)
      .set("controller", _controller)
      .set("template", _template)
      .set("method", _method);
  }
}

*/
