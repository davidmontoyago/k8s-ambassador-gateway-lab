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

- TLS termination at gateway
- gzip compression
- Canary routing
- gRPC over TLS

### TODO

- gRPC Ring hash LB

### Pre-requisites

- Helm2
- minikube

### Getting Started

```
# helm template ambassador
make templates

# deploy ambassador and sample apps
make deploy

# curl httpbin app
curl -i -k https://192.168.64.2:30135/httpbin/get

# run grpc client - requires ambassador gateway cert
# fails to mount ./certs with minikube's docker daemon - use host's docker instead
eval "$(docker-machine env -u)"
docker run -it --rm -v `pwd`/certs/:/certs/ -e mode=client -e server_host=192.168.64.2 -e server_port=30135 -e CERT_PEM=/certs/cert.pem tls-grpc-app:latest
```
