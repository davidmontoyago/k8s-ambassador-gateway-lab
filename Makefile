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

deploy:
	kubectl create secret tls ambassador-cert --cert=./certs/cert.pem --key=./certs/key.pem \
		--dry-run -o=yaml | kubectl apply -f -
	kubectl apply --recursive -f ./manifests/ambassador/templates
	kubectl apply --recursive -f ./manifests/ambassador/config
	kubectl apply --recursive -f ./manifests/httpbin

delete:
	kubectl delete --recursive -f ./manifests/ambassador/templates

diag:
	open "https://${AMBASSADOR_HTTPS_HOST}/ambassador/v0/diag/"

fakecerts:
	openssl genrsa -out ./certs/key.pem 2048
	openssl req -new -x509 -key ./certs/key.pem -out ./certs/cert.pem -days 365 -x509 -subj '/CN=localhost'