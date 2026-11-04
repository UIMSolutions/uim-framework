module uim.ui5.html.enumerations;

import uim.ui5;

mixin(ShowModule!());

@safe:

/// The UI5 distribution variant
enum Ui5Variant {
  openui5,
  sapui5
}

/// Well-known UI5 themes
enum Ui5Theme {
  sapHorizon,
  sapHorizonDark,
  sapFiori3,
  sapFiori3Dark,
  sapBelize,
  sapBelizeDeep,
  sapQuartzLight,
  sapQuartzDark
}

/// Converts a theme to its technical name, e.g. Ui5Theme.sapHorizon -> "sap_horizon"
string toString(Ui5Theme theme) {
  final switch (theme) {
    case Ui5Theme.sapHorizon:
      return "sap_horizon";
    case Ui5Theme.sapHorizonDark:
      return "sap_horizon_dark";
    case Ui5Theme.sapFiori3:
      return "sap_fiori_3";
    case Ui5Theme.sapFiori3Dark:
      return "sap_fiori_3_dark";
    case Ui5Theme.sapBelize:
      return "sap_belize";
    case Ui5Theme.sapBelizeDeep:
      return "sap_belize_deep";
    case Ui5Theme.sapQuartzLight:
      return "sap_quartz_light";
    case Ui5Theme.sapQuartzDark:
      return "sap_quartz_dark";
  }
}