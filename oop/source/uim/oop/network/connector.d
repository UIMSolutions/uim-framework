/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.network.connector;

import uim.oop;

mixin(ShowModule!());

@safe:

/// Interface for connecting to an external system, providing methods for connection management, data exchange, and status monitoring.
interface IConnector {
    /// A name for messages
    string name();

    /// Connects to the external system
    /// Throws: Exception if the connection fails
    void connect();

    /// Disconnects from the external system
    /// Throws: Exception if the disconnection fails
    void disconnect();

    /// Checks if the connection to the external system is active
    /// Returns: true if connected, false otherwise
    bool isConnected();

    /// Sends data to the external system
    /// Throws: Exception if sending fails
    void send(string data);

    /// Receives data from the external system
    /// Throws: Exception if receiving fails
    string receive();

    /// Checks if the external system is available
    /// Returns: true if available, false otherwise
    bool isAvailable();

    /// Sends a ping to the external system to check its responsiveness
    /// Returns: true if the system responds, false otherwise
    bool ping();

    /// Retrieves the last error encountered with the external system
    /// Returns: A string describing the last error, or an empty string if no error occurred
    string lastError();

    /// Clears the last error encountered with the external system
    /// Throws: Exception if clearing the error fails
    void clearLastError();

    /// Retrieves the status of the external system
    /// Returns: A string describing the current status, or an empty string if the status is unknown
    string status();

    /// Retrieves general information about the external system
    /// Returns: A Json object containing the information
    Json info();
}
