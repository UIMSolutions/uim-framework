/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.opc.interfaces.subscription;

import uim.opc.types.status;
import uim.opc.types.variant;
import uim.opc.interfaces.node;

@safe:

// Monitoring mode
enum MonitoringMode : uint {
  disabled  = 0,
  sampling  = 1,
  reporting = 2,
}

// Parameters for a monitored item
struct MonitoringParameters {
  double samplingIntervalMs = 1000.0;
  uint   queueSize          = 1;
  bool   discardOldest      = true;
}

// Data value snapshot with status and timestamp
struct OpcDataValue {
  OpcVariant    value;
  OpcStatus     status;
  long          sourceTimestampMs = 0;  // milliseconds since Unix epoch
  long          serverTimestampMs = 0;

  bool good()     const nothrow { return status.good();      }
  bool bad()      const nothrow { return status.bad();       }
  bool uncertain() const nothrow { return status.uncertain(); }
}

// Callback fired when a monitored item reports a data change
alias DataChangeCallback = void delegate(OpcNodeId nodeId, OpcDataValue value) @safe;

// Single monitored item contract
interface IMonitoredItem {
  uint                clientHandle()  @safe;
  OpcNodeId           nodeId()        @safe;
  OpcAttribute        attributeId()   @safe;
  MonitoringMode      monitoringMode() @safe;
  MonitoringParameters parameters()   @safe;
  OpcStatus           setCallback(DataChangeCallback cb) @safe;
  OpcStatus           setMonitoringMode(MonitoringMode mode) @safe;
}

// Subscription contract
interface IOpcSubscription {
  uint       subscriptionId()                          @safe;
  double     publishingIntervalMs()                    @safe;
  bool       publishingEnabled()                       @safe;
  OpcStatus  setPublishingEnabled(bool enabled)        @safe;
  IMonitoredItem monitor(OpcNodeId nodeId,
                         OpcAttribute attr,
                         MonitoringParameters params)  @safe;
  OpcStatus  removeMonitoredItem(uint clientHandle)    @safe;
  IMonitoredItem[] monitoredItems()                    @safe;
}
