# UIM-ANALYTICS UML Description

## Overview

The UIM-ANALYTICS library provides a compact architecture for analytics workflows in D. It combines typed service contracts, parser/statistics helpers, model constructors, and async orchestration using vibe.d.

## Core Types

```plantuml
@startuml ANALYTICS_Core

enum AnalyticsEngine {
  inMemory
  custom
}

struct AnalyticsConfig {
  + profileName: string
  + engine: AnalyticsEngine
  + maxRows: uint
  + strictMode: bool
}

struct AnalyticsPoint {
  + metric: string
  + timestamp: long
  + value: double
  + dimension: string
}

struct AnalyticsSummary {
  + success: bool
  + metric: string
  + count: ulong
  + min: double
  + max: double
  + mean: double
  + median: double
  + stdDev: double
  + sum: double
}

struct AnalyticsCorrelation {
  + success: bool
  + leftMetric: string
  + rightMetric: string
  + pearson: double
}

interface IAnalyticsService {
  + configure(config: AnalyticsConfig): bool
  + summarize(metric: string, points: AnalyticsPoint[]): AnalyticsSummary
  + movingAverage(metric: string, values: double[], windowSize: size_t): double[]
  + correlation(leftMetric: string, rightMetric: string, left: double[], right: double[]): AnalyticsCorrelation
  + summarizeAsync(metric: string, points: AnalyticsPoint[], handler: AnalyticsSummaryHandler): bool
  + movingAverageAsync(metric: string, values: double[], windowSize: size_t, handler: AnalyticsSeriesHandler): bool
}

class UIMAnalyticsService

UIMAnalyticsService ..|> IAnalyticsService

@enduml
```

## Helper Layer

```plantuml
@startuml ANALYTICS_Helpers

class ParserHelpers {
  + analyticsParseCsvSeries(csvContent: string, metric: string, separator: char): AnalyticsPoint[]
}

class StatisticsHelpers {
  + analyticsSum(values: double[]): double
  + analyticsMean(values: double[]): double
  + analyticsMedian(values: double[]): double
  + analyticsStdDev(values: double[]): double
  + analyticsMovingAverage(values: double[], windowSize: size_t): double[]
  + analyticsPearson(left: double[], right: double[]): double
}

UIMAnalyticsService --> ParserHelpers : parse CSV
UIMAnalyticsService --> StatisticsHelpers : compute metrics

@enduml
```

## Sequence

```plantuml
@startuml ANALYTICS_Sequence

actor Application
participant Service as "UIMAnalyticsService"
participant Parser as "ParserHelpers"
participant Stats as "StatisticsHelpers"
participant Task as "vibe.d runTask"
participant Handler as "AnalyticsSummaryHandler"

Application -> Service: configure(config)
Application -> Service: parseCsvSeries(csv, "sales")
Service -> Parser: parse CSV
Parser --> Service: AnalyticsPoint[]
Service --> Application: AnalyticsPoint[]

Application -> Service: summarize("sales", points)
Service -> Stats: mean/median/stddev/sum
Stats --> Service: numeric results
Service --> Application: AnalyticsSummary

Application -> Service: summarizeAsync("sales", points, handler)
Service -> Task: runTask(callback)
Task -> Handler: callback(summary)

@enduml
```
