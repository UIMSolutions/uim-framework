# NAF v4 Architecture - UIM-ANALYTICS

This document maps uim-analytics capabilities to NATO Architecture Framework v4 viewpoints.

## AV - All Views

### AV-1 Overview

| Attribute | Value |
| --- | --- |
| Architecture Name | UIM Analytics Library |
| Version | 26.x |
| Date | 30 May 2026 |
| Language | D (dlang) |
| Runtime | vibe.d |
| Domain | Data analytics orchestration and statistical processing |
| License | Apache-2.0 |
| Status | Initial Release |

### AV-2 Integrated Dictionary

| Term | Definition |
| --- | --- |
| Analytics Service | Service that orchestrates parsing and statistical analysis |
| Analytics Point | Timestamped metric value with optional dimension |
| Summary | Aggregated descriptive statistics for one metric |
| Correlation | Pearson correlation between two metric series |
| Async Operation | Non-blocking callback execution via runTask |

## CV - Capability View

### CV-1 Capability Taxonomy

```text
Analytics Integration Capability
|- Service Configuration
|  |- profile naming and row limits
|  |- strict mode and engine selection
|- Data Ingestion
|  |- CSV to point parsing
|  |- metric and dimension normalization
|- Statistical Processing
|  |- sum, mean, median, stddev
|  |- moving average windows
|  |- Pearson correlation
|- Async Processing
   |- async summary callback
   |- async moving-average callback
```

### CV-2 Capability Dependencies

| Capability | Depends On |
| --- | --- |
| Async operations | vibe.d runTask |
| CSV parser | string split helpers + numeric conversion |
| Statistical calculations | helper math functions |
| External engine integration | injected summary/correlation providers |

## OV - Operational View

### OV-1 Operational Concept

1. Application configures analytics profile and limits.
2. Service ingests data from CSV into typed points.
3. Service computes summary metrics for one series.
4. Service computes moving average or correlation for trend analysis.
5. Async APIs return analysis outputs through callbacks.

### OV-5 Activity Model

| Step | Activity | Input | Output |
| --- | --- | --- | --- |
| 1 | Configure service | AnalyticsConfig | ready state |
| 2 | Parse CSV | raw csv + metric | AnalyticsPoint[] |
| 3 | Summarize metric | metric + points | AnalyticsSummary |
| 4 | Compute trend | numeric values + window | averaged series |
| 5 | Compute relation | left and right series | AnalyticsCorrelation |

## SV - Systems View

### SV-1 Systems Interface Description

```text
+---------------------------+
| Application Layer         |
| - dashboards/report jobs  |
+-------------+-------------+
              |
              v
+---------------------------+
| uim.analytics             |
| - interfaces              |
| - models                  |
| - parser/statistics       |
| - service orchestration   |
+-------------+-------------+
              |
              v
+---------------------------+
| vibe.d runtime            |
| - runTask callback engine |
+---------------------------+
```

### SV-4 Function Mapping

| Module | Function |
| --- | --- |
| uim.analytics.interfaces.client | analytics contracts and value types |
| uim.analytics.models.client | summary/correlation helper constructors |
| uim.analytics.helpers.parser | CSV ingestion helpers |
| uim.analytics.helpers.statistics | descriptive and relation statistics |
| uim.analytics.service | orchestration and async entrypoints |

## TV - Technical View

### TV-1 Standards Profile

| Standard / Technology | Version | Use |
| --- | --- | --- |
| D Language | 2.x | implementation language |
| vibe.d | 0.10.x | async task scheduling |
| CSV | RFC 4180 subset | series ingestion |
| Pearson Correlation | classic formula | relationship strength metric |

### TV-2 Technical Roadmap

| Item | Status | Description |
| --- | --- | --- |
| Typed analytics API model | Implemented | summary/moving-average/correlation contracts |
| CSV parser helper | Implemented | point parsing with metric tagging |
| Statistics helper suite | Implemented | base descriptive and relation functions |
| Async operation API | Implemented | callback-based processing methods |
| Streaming and large-batch support | Planned | chunked ingestion and memory-aware processing |

## L - Logical Model

### L-1 Logical Data Model

```text
AnalyticsConfig
  |- profileName: string
  |- engine: AnalyticsEngine
  |- maxRows: uint
  |- strictMode: bool

AnalyticsPoint
  |- metric: string
  |- timestamp: long
  |- value: double
  |- dimension: string

AnalyticsSummary
  |- metric: string
  |- count: ulong
  |- min/max/mean/median/stdDev/sum: double

AnalyticsCorrelation
  |- leftMetric: string
  |- rightMetric: string
  |- pearson: double
```

### L-2 Constraints

- Service operations require a valid configured maxRows value.
- Metric name is mandatory for summarize and moving-average flows.
- Correlation requires non-empty series with matching lengths.
- Async callback execution is exception-isolated.
