/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.engineering.units;

import std.math;

@safe:

/**
 * Unit conversion utilities and constants.
 */
class Units {
    enum double g = 9.80665;        // m/s^2
    enum double R = 8.314462618;    // J/(mol*K)

    // Length
    static double metersToFeet(double m) pure nothrow { return m * 3.280839895; }
    static double feetToMeters(double ft) pure nothrow { return ft / 3.280839895; }
    static double metersToInches(double m) pure nothrow { return m * 39.37007874; }
    static double inchesToMeters(double in_) pure nothrow { return in_ / 39.37007874; }

    // Mass
    static double kgToLbs(double kg) pure nothrow { return kg * 2.2046226218; }
    static double lbsToKg(double lbs) pure nothrow { return lbs / 2.2046226218; }

    // Force
    static double newtonToPoundForce(double n) pure nothrow { return n * 0.2248089439; }
    static double poundForceToNewton(double lbf) pure nothrow { return lbf / 0.2248089439; }

    // Pressure
    static double pascalToBar(double pa) pure nothrow { return pa * 1.0e-5; }
    static double barToPascal(double bar) pure nothrow { return bar * 1.0e5; }
    static double pascalToPsi(double pa) pure nothrow { return pa * 0.0001450377377; }
    static double psiToPascal(double psi) pure nothrow { return psi / 0.0001450377377; }

    // Temperature
    static double celsiusToKelvin(double c) pure nothrow { return c + 273.15; }
    static double kelvinToCelsius(double k) pure nothrow { return k - 273.15; }
    static double celsiusToFahrenheit(double c) pure nothrow { return c * 9.0 / 5.0 + 32.0; }
    static double fahrenheitToCelsius(double f) pure nothrow { return (f - 32.0) * 5.0 / 9.0; }

    // Angle
    static double degreesToRadians(double deg) pure nothrow { return deg * (PI / 180.0); }
    static double radiansToDegrees(double rad) pure nothrow { return rad * (180.0 / PI); }
}
