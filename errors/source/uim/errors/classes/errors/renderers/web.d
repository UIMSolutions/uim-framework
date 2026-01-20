/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.errors.classes.errors.renderers.web;

import uim.errors;
mixin(ShowModule!());
@safe:

class DWebErrorRenderer : UIMErrorRenderer { 
  mixin(ErrorRendererThis!("Web"));

  /**
 * Web Error Renderer.
 *
 * Captures and handles all unhandled errors. Displays helpful framework errors when debug is true.
 * When debug is false, WebErrorRenderer will render 404 or 500 errors. If an uncaught error is thrown
 * and it is a type that WebErrorHandler does not know about it will be treated as a 500 error.
 *
 * ### Implementing application specific error rendering
 *
 * You can implement application specific error handling by creating a subclass of
 * WebErrorRenderer and configure it to be the `errorRenderer` in config/error.d
 *
 * #### Using a subclass of WebErrorRenderer
 *
 * Using a subclass of WebErrorRenderer gives you full control over how Errors are rendered, you
 * can configure your class in your config/app.d.
 */

  /**
     * Creates the controller to perform rendering on the error response.
     * Params:
     * \Throwable error Error.
     * instead of creating a new one.
     */
  /* this(Throwable error, IServerRequest serverRequest = null) {
        _error = error;
        _request = serverRequest;
        _controller = _getController();
    } */

  // Controller instance.
  protected IErrorController controller;

  // Template to render for {@link \UIM\Core\Error\UIMError}
  protected string _template = "";

  // The method corresponding to the Error this object is for.
  protected string methodName = "";

  /**
     * The error being handled.
     *
     * @var \Throwable
     */
  protected Throwable error;

  /**
     * If set, this will be request used to create the controller that will render
     * the error.
     *
     * @var \UIM\Http\ServerRequest|null
     */
  /* protected IServerRequest serverRequest; */

  /**
     * MapHelper of errors to http status codes.
     *
     * This can be customized for users that don`t want specific errors to throw 404 errors
     * or want their application errors to be automatically converted.
     *
     * @var array<string, int>
     * @psalm-var array<class-string<\Throwable>, int>
     */
  protected Json[string] errorHttpCodes = null; 
  /* [
    // Controller errors
    /* InvalidParameterError.classname: 404,
    MissingActionError.classname: 404,
    // Datasource errors
    PageOutOfBoundsError.classname: 404,
    RecordNotFounUIMError.classname: 404,
    // Http errors
    MissingControllerError.classname: 404,
    // Routing errors
    MissingRouteError.classname: 404, * /
  ]; */

  /**
     * Get the controller instance to handle the error.
     * Override this method in subclasses to customize the controller used.
     * This method returns the built in `ErrorController` normally, or if an error is repeated
     * a bare controller will be used.
     */
  override protected IErrorController _getController() {
    /* request = _request;
    routerRequest = Router.getRequest();
    // Fallback to the request in the router or make a new one from
    // _SERVER
    if (request.isNull) {
      request = routerRequest ? routerRequest : ServerRequestFactory.fromGlobals();
    }
    // If the current request doesn`t have routing data, but we
    // found a request in the router context copy the params over
    if (request.getParam("controller").isNull && routerRequest !is null) {
      request = request.withAttribute("params", routerRequest.getAttribute("params"));
    }
    try {
      params = request.getAttribute("params");
      params.set("controller", "Error");

      auto factory = new DControllerFactory(new UIMContainer());
      // Check including plugin + prefix
      auto classname = factory.controllerClass(request.withAttribute("params", params));
      if (!classname && !params.isEmpty("prefix") && !params.isEmpty("plugin")) {
        params.remove("prefix");
        // Fallback to only plugin
        classname = factory.controllerClass(request.withAttribute("params", params));
      }
      if (!classname) {
        // Fallback to app/core provided controller.
        classname = App.classname("Error", "Controller", "Controller");
      }
      assert(isSubclass_of(classname, Controller.classname));
      controller = new classname(request);
      controller.startupProcess();
    } catch (Throwable anError) {
    }

    return controller is null
      ? new DController(request) : controller; */

    return null;
  }

  // Clear output buffers so error pages display properly.
  override protected void clearOutput() {
    /* if (isIn(UIM_SAPI, ["cli", "Ddbg"])) {
      return;
    } */
/*     while (ob_get_level()) {
      ob_end_clean();
    } */
  }

  // Renders the response for the error.
  /* IResponse render() {
        /* auto error = _error;
        auto code = getHttpCode(error);
        auto method = methodName(error);
        auto templateText = templateName(error, method, code);
        clearOutput();

        if (hasMethod(this, method)) {
            return _customMethod(method, error);
        }
        string message = errorMessage(error, code);
        auto url = _controller.getRequest().getRequestTarget();

        auto response = _controller.getResponse();
        if (cast(HttpError) error) {
            error.getHeaders().byKeyValue
                .each!(nameValue => response = response.withHeader(nameValue.name, nameValue.value));
        }
        response = response.withStatus(code);

        auto errors = [error];
        auto previous = error.getPrevious();
        while (!previous.isNull) {
            errors ~= previous;
            previous = previous.getPrevious();
        }
        
        auto viewVars = [
            "message": message,
            "url": htmlAttributeEscape(url),
            "error": error,
            "errors": errors,
            "code": code,
        ];
        
        auto serialize = ["message", "url", "code"];
        auto isDebug = configuration.getEntry("debug");
        if (isDebug) {
            trace =/*  (array) * / Debugger.formatTrace(error.getTrace(), [
                    "format": "array",
                    "args": true.toJson,
                ]);
            origin = [
                "file": error.getFile().ifEmpty("null"),
                "line": error.getLine().ifEmpty("null"),
            ];
            // Traces don`t include the origin file/line.
            trace.unshift(origin);
            viewVars.set("trace", trace);
            viewVars += origin;
            serialize ~= "file";
            serialize ~= "line";
        }
        _controller.set(viewVars);
        _controller.viewBuilder().setOption("serialize", serialize);

        if (cast(UIMError) error && isDebug) {
            _controller.set(error.getAttributes());
        }
        _controller.setResponse(response);

        return _outputMessage(template); * / 
        return null;
    } */

  // Emit the response content
  alias write = UIMErrorRenderer.write;
  void write(string outputText) {
    writeln(outputText);
  }

  /* void write(IResponse outputResponse) {
        auto emitter = new DResponseEmitter();
        emitter.emit(outputResponse);
    } */

  // Render a custom error method/template.
  /* protected IResponse _customMethod(string methodName, Throwable errorToRender) {
        /*         auto result = this.{
            methodName
        }
        (errorToRender);
        _shutdown();
        if (isString(result)) {
            result = _controller.getResponse().withStringBody(result);
        }
        return result; * /
        return null;
    } */

  // Get method name
  /* override */ /* protected string methodName(Throwable error) {
    /* [, baseClass] = namespaceSplit(error.classname);

        if (baseClass.endsWith("Error")) {
            baseClass = subString(baseClass, 0, -9);
        }
        // baseClass would be an empty string if the error class is \Error.
        method = baseClass is null ? "error500" : Inflector.variable(baseClass);

        return _method = method; * /
    return null;
  } */

  // Get error message.
  override protected string errorMessage(Throwable error, int errorCode) {
    /* string result = error.message();

        if (
            !configuration.hasEntry("debug") &&
            !(cast(HttpError) error)
            ) {
            result = code < 500
                ? __d("uim", "Not Found") : __d("uim", "An Internal Error Has Occurred.");
        }
    }

    return result; */
    return null;
  }

  /**
     * Get template for rendering error info.
     * Params:
     * \Throwable error Error instance.
     */
   override protected string templateName(Throwable error, string methodName, int errorCode) {
    /* if (cast(HttpError) error || !configuration.hasEntry("debug")) {
        return _template = errorCode < 500 ? "error400' : 'error500";
    }

    _template = cast(PDOError) error
        ? "pdo_error" : methodName;

    return _template; */
    return null;
  }

  // Gets the appropriate http status code for error.
  override protected int getHttpCode(Throwable error) {
    /* if (cast(HttpError) error) {
            return error.code();
        }
        return _errorHttpCodes[error.classname] ?  ? 500; */
    return 0;
  }

  // Generate the response using the controller object.
  /* protected IResponse _outputMessage(string templateToRender) {
    /* try {
        _controller.render(templateToRender);

        return _shutdown();
    } catch (MissingTemplateError anError) {
        attributes = anError.getAttributes();
        if (
            cast(MissingLayoutError) anError ||
            attributes.getString("file").contains("error500")
            ) {
            return _outputMessageSafe("error500");
        }
        return _outputMessage("error500");
    } catch (MissingPluginError anError) {
        attributes = anError.getAttributes();
        if (attributes.getString("plugin") == _controller.pluginName) {
            _controller.setPlugin(null);
        }
        return _outputMessageSafe("error500");
    } catch (Throwable outer) {
        try {
            return _outputMessageSafe("error500");
        } catch (Throwable anInner) {
            throw outer;
        }
    } * /
    return null;
  } */

  /**
     * A safer way to render error messages, replaces all helpers, with basics
     * and doesn`t call component methods.
     * Params:
     * string _template The template to render.
     */
  /* protected IResponse _outputMessageSafe(string templateText) {
    auto builder = _controller.viewBuilder();
    builder
      .setHelpers([])
      .setLayoutPath("")
      .setTemplatePath("Error");

    auto view = _controller.createView("View");
    auto response = _controller.getResponse()
      .withType("html")
      .withStringBody(view.render(templateText, "error"));
    _controller.setResponse(response);

    return response;
  } */

  /**
     * Run the shutdown events.
     * Triggers the afterFilter and afterDispatch events.
     */
  /* protected IResponse _shutdown() {
        _controller.dispatchEvent("Controller.shutdown");

        return _controller.getResponse();
    } */

  /**
     * Returns an array that can be used to describe the internal state of this
     * object.
     */
/*   Json[string] debugInfo(string[] showKeys = null, string[] hideKeys = null) {
    return super.debugInfo(showKeys, hideKeys)
      .set("error", _error)
      .set("request", _request)
      .set("controller", _controller)
      .set("template", _template)
      .set("method", _method);
  } */
}
mixin(ErrorRendererCalls!("Web"));
