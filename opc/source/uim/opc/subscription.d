/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.opc.subscription;

import uim.opc;

mixin(ShowModule!());

@safe:

class UIMOpcMonitoredItem : UIMObject, IMonitoredItem {
  private uint                _clientHandle;
  private OpcNodeId           _nodeId;
  private OpcAttribute        _attributeId;
  private MonitoringMode      _mode;
  private MonitoringParameters _params;
  private DataChangeCallback  _callback;

  private static uint _nextHandle = 1;

  this(OpcNodeId nodeId, OpcAttribute attributeId, MonitoringParameters params) {
    _clientHandle = _nextHandle++;
    _nodeId       = nodeId;
    _attributeId  = attributeId;
    _params       = params;
    _mode         = MonitoringMode.reporting;
  }

  uint                 clientHandle()   { return _clientHandle; }
  OpcNodeId            nodeId()         { return _nodeId;       }
  OpcAttribute         attributeId()    { return _attributeId;  }
  MonitoringMode       monitoringMode() { return _mode;         }
  MonitoringParameters parameters()     { return _params;       }

  OpcStatus setCallback(DataChangeCallback cb) {
    _callback = cb;
    return opcGoodStatus();
  }

  OpcStatus setMonitoringMode(MonitoringMode mode) {
    _mode = mode;
    return opcGoodStatus();
  }

  // Internal: fire callback if set
  void fireDataChange(OpcDataValue value) {
    if (_callback !is null && _mode == MonitoringMode.reporting) {
      _callback(_nodeId, value);
    }
  }
}

class UIMOpcSubscription : UIMObject, IOpcSubscription {
  private uint   _subscriptionId;
  private double _publishingIntervalMs;
  private bool   _publishingEnabled;

  private UIMOpcMonitoredItem[] _items;

  private static uint _nextSubId = 1;

  this(double publishingIntervalMs = 1000.0) {
    _subscriptionId       = _nextSubId++;
    _publishingIntervalMs = publishingIntervalMs;
    _publishingEnabled    = true;
  }

  uint   subscriptionId()       { return _subscriptionId;       }
  double publishingIntervalMs() { return _publishingIntervalMs; }
  bool   publishingEnabled()    { return _publishingEnabled;    }

  OpcStatus setPublishingEnabled(bool enabled) {
    _publishingEnabled = enabled;
    return opcGoodStatus();
  }

  IMonitoredItem monitor(OpcNodeId nodeId, OpcAttribute attr, MonitoringParameters params) {
    auto item = new UIMOpcMonitoredItem(nodeId, attr, params);
    _items ~= item;
    return item;
  }

  OpcStatus removeMonitoredItem(uint clientHandle) {
    foreach (i, item; _items) {
      if (item.clientHandle == clientHandle) {
        _items = _items[0 .. i] ~ _items[i + 1 .. $];
        return opcGoodStatus();
      }
    }
    return opcBadStatus(OpcStatusCode.badMonitoredItemIdInvalid, "Monitored item not found");
  }

  IMonitoredItem[] monitoredItems() {
    IMonitoredItem[] result;
    foreach (item; _items) result ~= item;
    return result;
  }

  // Internal: notify all matching monitored items of a data change
  void notifyDataChange(OpcNodeId nodeId, OpcDataValue value) {
    foreach (item; _items) {
      if (item.nodeId == nodeId) {
        item.fireDataChange(value);
      }
    }
  }

  unittest {
    auto sub = new UIMOpcSubscription(500.0);
    assert(sub.publishingIntervalMs == 500.0);
    assert(sub.publishingEnabled);

    auto params = MonitoringParameters(200.0, 10, true);
    auto item = sub.monitor(OpcNodeId.numeric(0, 1001), OpcAttribute.value, params);
    assert(item !is null);
    assert(sub.monitoredItems.length == 1);

    bool fired;
    item.setCallback((OpcNodeId nid, OpcDataValue dv) {
      fired = true;
    });

    // simulate data change
    auto dv = OpcDataValue(OpcVariant.int32(99), opcGoodStatus(), 0, 0);
    (cast(UIMOpcMonitoredItem) item).fireDataChange(dv);
    assert(fired);

    auto st = sub.removeMonitoredItem(item.clientHandle);
    assert(st.good);
    assert(sub.monitoredItems.length == 0);
  }
}

auto OpcSubscription(double publishingIntervalMs = 1000.0) {
  return new UIMOpcSubscription(publishingIntervalMs);
}
