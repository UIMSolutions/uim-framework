/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.engineering.thermodynamics;

import std.math;
import uim.engineering.units;

@safe:

/**
 * Thermodynamics utilities.
 */
class Thermodynamics {
    static double idealGasPressure(double n, double temperatureK, double volume) pure nothrow {
        return (n * Units.R * temperatureK) / volume;
    }

    static double idealGasTemperature(double pressure, double volume, double n) pure nothrow {
        return (pressure * volume) / (n * Units.R);
    }

    static double idealGasVolume(double pressure, double n, double temperatureK) pure nothrow {
        return (n * Units.R * temperatureK) / pressure;
    }

    static double heatEnergy(double mass, double specificHeat, double deltaT) pure nothrow {
        return mass * specificHeat * deltaT;
    }

    static double carnotEfficiency(double hotK, double coldK) pure nothrow {
        return 1.0 - (coldK / hotK);
    }

    static double conductionHeat(double k, double area, double deltaT, double thickness) pure nothrow {
        return (k * area * deltaT) / thickness;
    }
}
