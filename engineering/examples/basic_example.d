#!/usr/bin/env dub
/+ dub.sdl:
name "engineering_basic_example"
description "Basic usage example for uim-engineering"
dependency "uim-framework:engineering" version="*"
+/
module engineering.examples.basic_example;

import std.stdio;
import uim.engineering;

void main() {
    writeln("uim-engineering: basic example");

    auto energy = Mechanics.kineticEnergy(1200.0, 27.0);
    auto stress = Materials.stress(20000.0, 0.01);
    auto pressure = Thermodynamics.idealGasPressure(1.0, 298.15, 0.024);
    auto re = Fluids.reynoldsNumber(1000.0, 2.0, 0.05, 0.001);
    auto voltage = Electrical.voltage(2.0, 10.0);
    auto inertia = Structural.momentOfInertiaRect(0.2, 0.4);

    writeln("Kinetic energy: ", energy, " J");






}    writeln("Rectangular inertia: ", inertia, " m^4");    writeln("Voltage: ", voltage, " V");    writeln("Reynolds number: ", re);    writeln("Ideal gas pressure: ", pressure, " Pa");    writeln("Stress: ", stress, " Pa");