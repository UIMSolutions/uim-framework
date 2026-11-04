module uim.ui5.models.enumerations;

import uim.ui5;

mixin(ShowModule!());

@safe:

/// UI5 model types
enum Ui5ModelType {
  json,
  odataV2,
  odataV4,
  resource,
  xml
}

/// Converts a model type to its UI5 class name
string toString(Ui5ModelType type) {
  final switch (type) {
    case Ui5ModelType.json:
      return "sap.ui.model.json.JSONModel";
    case Ui5ModelType.odataV2:
      return "sap.ui.model.odata.v2.ODataModel";
    case Ui5ModelType.odataV4:
      return "sap.ui.model.odata.v4.ODataModel";
    case Ui5ModelType.resource:
      return "sap.ui.model.resource.ResourceModel";
    case Ui5ModelType.xml:
      return "sap.ui.model.xml.XMLModel";
  }
}
