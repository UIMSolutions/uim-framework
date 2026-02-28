# Library 📚 uim-services

Updated on 1. February 2026


[![uim-services](https://github.com/UIMSolutions/uim-framework/actions/workflows/uim-services.yml/badge.svg)](https://github.com/UIMSolutions/uim-framework/actions/workflows/uim-services.yml) [![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## Overview

`uim-services` is a D language service library with a lightweight `vibe.d` HTTP API runtime.

The package now provides:

- optimized service and configuration classes
- explicit, lower-overhead imports in helpers
- a `vibe.d` API module (`uim.services.vibeservice`)
- an executable target for containerized service runtime
- Podman and Kubernetes assets for deployment

## Build the Library

From repository root:

```bash
dub build :services
```

## Run the `vibe.d` Service API

From repository root:

```bash
dub run :services -c service
```

Environment variables:

- `HOST` (default: `0.0.0.0`)
- `PORT` (default: `8080`)
- `BASE_PATH` (default: `/api/v1`)
- `SERVICE_NAME` (default: `uim-services`)
- `SERVICE_DESCRIPTION`
- `SERVICE_VERSION`
- `SERVICE_AUTHOR`
- `SERVICE_LICENSE`

Endpoints:

- `GET /health`
- `GET /api/v1/service`
- `POST /api/v1/service/start`
- `POST /api/v1/service/stop`

## Build with Podman

From repository root:

```bash
podman build -f services/Containerfile -t uim-services:latest .
```

Run locally:

```bash
podman run --rm -p 8080:8080 \
	-e HOST=0.0.0.0 \
	-e PORT=8080 \
	-e BASE_PATH=/api/v1 \
	uim-services:latest
```

## Deploy to Kubernetes

Apply manifests:

```bash
kubectl apply -f services/k8s/uim-services.yaml
```

Check rollout:

```bash
kubectl rollout status deploy/uim-services
kubectl get pods -l app=uim-services
kubectl get svc uim-services
```

If needed, set your own image before apply:

```bash
kubectl set image deploy/uim-services uim-services=<your-registry>/uim-services:latest
```
