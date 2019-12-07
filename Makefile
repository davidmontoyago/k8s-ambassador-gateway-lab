templates:
	helm fetch \
		--repo https://kubernetes-charts.storage.googleapis.com \
		--untar --untardir ./charts ambassador
	helm template ambassador \
  		--values ./values/defaults.yaml \
  		--values ./values/values.yaml \
  		--output-dir ./manifests \
    	./charts/ambassador

deploy:
	make templates
	kubectl apply -f ./manifests/ambassador/namespace.yaml
	kubectl apply --recursive -f ./manifests/ambassador/templates

delete:
	kubectl delete --recursive -f ./manifests/ambassador/templates
