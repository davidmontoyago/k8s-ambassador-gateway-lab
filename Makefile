# minikube service list to get these
AMBASSADOR_HTTP_HOST="192.168.64.2:31630"
AMBASSADOR_HTTPS_HOST="192.168.64.2:30783"

templates:
	helm fetch \
		--repo https://kubernetes-charts.storage.googleapis.com \
		--untar --untardir ./charts ambassador
	helm template \
		--name ambassador \
  		--values ./values/defaults.yaml \
  		--values ./values/values.yaml \
  		--output-dir ./manifests \
    	./charts/ambassador
	
samples:
    # TODO clone & make package sample grpc app

deploy:
	kubectl create secret tls gateway-tls-keys --cert=./certs/cert.pem --key=./certs/key.pem \
		--dry-run -o=yaml | kubectl apply -f -
	
	kubectl create secret tls upstream-api-tls-keys --cert=./certs/upstream-api-cert.pem --key=./certs/upstream-api-key.pem \
		--dry-run -o=yaml | kubectl apply -f -
	
	kubectl apply --recursive -f ./manifests/ambassador/templates
	kubectl apply --recursive -f ./manifests/ambassador/config
	kubectl apply --recursive -f ./manifests/sample-apps/httpbin
	kubectl apply --recursive -f ./manifests/sample-apps/grpc-tls-hello-world

delete:
	kubectl delete --recursive --ignore-not-found \
		 -f ./manifests/sample-apps/httpbin \
		 -f ./manifests/sample-apps/grpc-tls-hello-world \
		 -f ./manifests/ambassador/config \
		 -f ./manifests/ambassador/templates >/dev/null

diag:
	open "https://${AMBASSADOR_HTTPS_HOST}/ambassador/v0/diag/"

fakecerts:
	openssl genrsa -out ./certs/key.pem 2048
	openssl req -new -x509 -key ./certs/key.pem -out ./certs/cert.pem -days 365 -x509 -subj '/CN=localhost'
	
	openssl genrsa -out ./certs/upstream-api-key.pem 2048
	openssl req -new -x509 -key ./certs/upstream-api-key.pem -out ./certs/upstream-api-cert.pem -days 365 -x509 -subj '/CN=localhost'