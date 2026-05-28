# UIM-GIS UML Description

## Overview

The UIM-GIS library provides a compact geospatial architecture for D applications using vibe.d runtime patterns. It includes feature modeling, extent-based querying, and asynchronous stream callbacks.

## Core Types

```plantuml
@startuml GIS_Core

enum GISGeometryType {
  point
  lineString
  polygon
  multiPoint
  multiLineString
  multiPolygon
  geometryCollection
}

struct GISPoint {
  + x: double
  + y: double
  + z: double
}

struct GISExtent {
  + minX: double
  + minY: double
  + maxX: double
  + maxY: double
}

interface IGISFeature {
  + id(): string
  + geometryType(): GISGeometryType
  + coordinates(): GISPoint[]
  + properties(): string[string]
  + extent(): GISExtent
}

interface IGISClient {
  + connect(): bool
  + disconnect(): bool
  + addFeature(feature: IGISFeature): bool
  + queryByExtent(extent: GISExtent): IGISFeature[]
  + queryByProperty(key: string, value: string): IGISFeature[]
  + streamByExtent(extent: GISExtent, handler: GISFeatureHandler): bool
}

class UIMGISFeature
class UIMGISClient

UIMGISFeature ..|> IGISFeature
UIMGISClient ..|> IGISClient
UIMGISClient --> UIMGISFeature : manages

@enduml
```

## Helper Layer

```plantuml
@startuml GIS_Helpers

class GeoHelpers {
  + gisExtentFromCoordinates(coords: GISPoint[]): GISExtent
  + gisExtentContainsPoint(extent: GISExtent, point: GISPoint): bool
  + gisExtentIntersects(a: GISExtent, b: GISExtent): bool
}

UIMGISFeature --> GeoHelpers : extent calc
UIMGISClient --> GeoHelpers : spatial query

@enduml
```

## Sequence

```plantuml
@startuml GIS_Sequence

actor Application
participant Client as "UIMGISClient"
participant Task as "vibe.d runTask"
participant Handler as "GISFeatureHandler"

Application -> Client: connect()
Application -> Client: addFeature(feature)
Application -> Client: queryByExtent(extent)
Client --> Application: matching features

Application -> Client: streamByExtent(extent, handler)
Client -> Task: runTask(callback)
Task -> Handler: on feature

@enduml
```
