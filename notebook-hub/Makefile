init:
	helm repo add jupyterhub https://jupyterhub.github.io/helm-chart/
	helm repo update

deploy-minimal:
	helm upgrade --cleanup-on-fail --install jhub jupyterhub/jupyterhub \
	--namespace jupyter  \
	--version=0.9.0 \
	--values jhub-config-minimal.yaml

deploy-ingress:
	helm repo add stable https://kubernetes-charts.storage.googleapis.com/
	helm repo add stable https://charts.helm.sh/stable
	helm repo update
	helm install stable/nginx-ingress -n nginx-ingress --namespace ingress-controller --generate-name