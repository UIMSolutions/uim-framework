/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.statistics.streaming.quantile;

import uim.statistics.interfaces.quantile;
import uim.statistics.interfaces.dataset : Sample;
import std.algorithm : clamp;

/// P2 online quantile estimator (simplified, single quantile).
class P2Quantile : IQuantileEstimator {
    private double _q = 0.5; // target quantile
    private bool _initialized = false;
    private double[5] _markerHeights;
    private double[5] _markerPositions;
    private double[5] _desiredPositions;
    private double[5] _increments;
    private size_t _count;

    this(double q = 0.5) @safe { target(q); }

    void target(double q) @safe {
        _q = clamp(q, 0.0001, 0.9999);
    }

    void reset() @safe {
        _initialized = false;
        _count = 0;
    }

    void add(Sample s) @safe {
        double x = s.value;
        if (!_initialized) {
            _init(x);
            return;
        }

        // Update marker heights and positions (simplified for single quantile)
        size_t k;
        if (x < _markerHeights[0]) { _markerHeights[0] = x; k = 0; }
        else if (x < _markerHeights[1]) { k = 0; }
        else if (x < _markerHeights[2]) { k = 1; }
        else if (x < _markerHeights[3]) { k = 2; }
        else if (x < _markerHeights[4]) { k = 3; }
        else { _markerHeights[4] = x; k = 3; }

        // Increment positions
        _markerPositions[0] += 0;
        _markerPositions[1] += 1;
        _markerPositions[2] += _q * 2;
        _markerPositions[3] += 1 + _q;
        _markerPositions[4] += 1;

        // Desired positions
        _desiredPositions[0] += 0;
        _desiredPositions[1] += _q / 2;
        _desiredPositions[2] += _q;
        _desiredPositions[3] += (1 + _q) / 2;
        _desiredPositions[4] += 1;

        // Adjust heights
        foreach (i; 1 .. 4) {
            double d = _desiredPositions[i] - _markerPositions[i];
            if ((d >= 1 && _markerPositions[i + 1] - _markerPositions[i] > 1) ||
                (d <= -1 && _markerPositions[i] - _markerPositions[i - 1] > 1)) {
                int sign = d >= 0 ? 1 : -1;
                double hp = _parabolic(i, sign);
                double hl = _linear(i, sign);
                if (_markerHeights[i - 1] < hp && hp < _markerHeights[i + 1]) {
                    _markerHeights[i] = hp;
                } else {
                    _markerHeights[i] = hl;
                }
                _markerPositions[i] += sign;
            }
        }

        _count++;
    }

    double quantile() const @safe {
        return _markerHeights[2];
    }

    private void _init(double x) @safe {
        // First observation initializes all markers
        foreach (i; 0 .. 5) {
            _markerHeights[i] = x;
            _markerPositions[i] = i + 1;
            _desiredPositions[i] = i + 1;
        }
        _increments = [0, _q / 2, _q, (1 + _q) / 2, 1];
        _initialized = true;
        _count = 1;
    }

    private double _parabolic(size_t i, int d) @safe {
        double p = _markerHeights[i] + d / (_markerPositions[i + 1] - _markerPositions[i - 1]) * (
            (_markerPositions[i] - _markerPositions[i - 1] + d) * (_markerHeights[i + 1] - _markerHeights[i]) / (_markerPositions[i + 1] - _markerPositions[i]) +
            (_markerPositions[i + 1] - _markerPositions[i] - d) * (_markerHeights[i] - _markerHeights[i - 1]) / (_markerPositions[i] - _markerPositions[i - 1])
        );
        return p;
    }

    private double _linear(size_t i, int d) @safe {
        return _markerHeights[i] + d * (_markerHeights[i + d] - _markerHeights[i]) / (_markerPositions[i + d] - _markerPositions[i]);
    }
}
