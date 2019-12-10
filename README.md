# k8s-ambassador-gateway-lab

Experiments with Ambassador in k8s.

An edge gateway can broker connections across network boundaries while supporting cross-functional concerns like:

- Traffic Control
- Auth / TLS / mTLS
- Rate Limiting
- Network Observability
- Route Management
- Request/Response Caching

### Experiments

- TLS termination
- gzip compression
- Canary routing

### TODO

- gRPC experiment

### Pre-requisites

- Helm2
- minikube

### Getting Started

```
make deploy
```

```
curl -i -k https://192.168.64.2:30783/httpbin/get
```