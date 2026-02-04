/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.engineering.web;

import vibe.d;
import std.json;
import std.algorithm;
import std.array;
import uim.engineering.units;
import uim.engineering.mechanics;
import uim.engineering.materials;
import uim.engineering.thermodynamics;
import uim.engineering.fluids;
import uim.engineering.electrical;
import uim.engineering.structural;

@safe:

/**
 * REST API endpoints for engineering calculations.
 */
@rootPath("/api/engineering")
class EngineeringAPI {

    @method(HTTPMethod.GET)
    @path("/health")
    void health(HTTPServerResponse res) {
        res.writeJsonBody(["status": "ok", "service": "uim-engineering"]);
    }

    @method(HTTPMethod.POST)
    @path("/units/convert")
    void unitConvert(HTTPServerRequest req, HTTPServerResponse res) {
        auto json = req.json;
        if ("type" !in json || "value" !in json) {
            res.statusCode = 400;
            res.writeJsonBody(["error": "Missing 'type' or 'value' field"]);
            return;
        }

        string convType = json["type"].get!string;
        double value = json["value"].get!double;
        double result;

        final switch (convType) {
            case "m_to_ft": result = Units.metersToFeet(value); break;
            case "ft_to_m": result = Units.feetToMeters(value); break;
            case "c_to_k": result = Units.celsiusToKelvin(value); break;
            case "k_to_c": result = Units.kelvinToCelsius(value); break;
            case "pa_to_bar": result = Units.pascalToBar(value); break;
            case "bar_to_pa": result = Units.barToPascal(value); break;
            default:
                res.statusCode = 400;
                res.writeJsonBody(["error": "Unsupported conversion type"]);
                return;
        }

        JSONValue outJson;
        outJson["result"] = result;
        outJson["type"] = convType;
        res.writeJsonBody(outJson);
    }

    @method(HTTPMethod.POST)
    @path("/mechanics/kinetic")
    void kineticEnergy(HTTPServerRequest req, HTTPServerResponse res) {
        auto json = req.json;
        if ("mass" !in json || "velocity" !in json) {
            res.statusCode = 400;
            res.writeJsonBody(["error": "Missing 'mass' or 'velocity' field"]);
            return;
        }

        double mass = json["mass"].get!double;
        double velocity = json["velocity"].get!double;
        double energy = Mechanics.kineticEnergy(mass, velocity);

        JSONValue outJson;
        outJson["energy"] = energy;
        res.writeJsonBody(outJson);
    }

    @method(HTTPMethod.POST)
    @path("/materials/stress")
    void stressCalc(HTTPServerRequest req, HTTPServerResponse res) {
        auto json = req.json;
        if ("force" !in json || "area" !in json) {
            res.statusCode = 400;
            res.writeJsonBody(["error": "Missing 'force' or 'area' field"]);
            return;
        }

        double force = json["force"].get!double;
        double area = json["area"].get!double;
        double stress = Materials.stress(force, area);

        JSONValue outJson;
        outJson["stress"] = stress;
        res.writeJsonBody(outJson);
    }

    @method(HTTPMethod.POST)
    @path("/fluids/reynolds")
    void reynoldsCalc(HTTPServerRequest req, HTTPServerResponse res) {
        auto json = req.json;
        if ("rho" !in json || "v" !in json || "L" !in json || "mu" !in json) {
            res.statusCode = 400;
            res.writeJsonBody(["error": "Missing 'rho', 'v', 'L', or 'mu' field"]);
            return;
        }

        double rho = json["rho"].get!double;
        double v = json["v"].get!double;
        double L = json["L"].get!double;
        double mu = json["mu"].get!double;
        double re = Fluids.reynoldsNumber(rho, v, L, mu);

        JSONValue outJson;
        outJson["reynolds"] = re;
        res.writeJsonBody(outJson);
    }

    @method(HTTPMethod.POST)
    @path("/electrical/ohms")
    void ohmsLaw(HTTPServerRequest req, HTTPServerResponse res) {
        auto json = req.json;
        if ("current" !in json || "resistance" !in json) {
            res.statusCode = 400;
            res.writeJsonBody(["error": "Missing 'current' or 'resistance' field"]);
            return;
        }

        double current = json["current"].get!double;
        double resistance = json["resistance"].get!double;
        double voltage = Electrical.voltage(current, resistance);

        JSONValue outJson;
        outJson["voltage"] = voltage;
        res.writeJsonBody(outJson);
    }

    @method(HTTPMethod.POST)
    @path("/structural/bending")
    void bendingStressCalc(HTTPServerRequest req, HTTPServerResponse res) {
        auto json = req.json;
        if ("moment" !in json || "c" !in json || "I" !in json) {
            res.statusCode = 400;
            res.writeJsonBody(["error": "Missing 'moment', 'c', or 'I' field"]);
            return;
        }

        double moment = json["moment"].get!double;
        double c = json["c"].get!double;
        double I = json["I"].get!double;
        double stress = Structural.bendingStress(moment, c, I);

        JSONValue outJson;
        outJson["stress"] = stress;
        res.writeJsonBody(outJson);
    }
}
