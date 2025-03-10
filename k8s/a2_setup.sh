echo Creating cluster...
kind create cluster --name kind-1 --config k8s/kind/cluster-config.yaml

echo Verifying cluster...
kubectl get nodes
kubectl cluster-info

echo Creating deployment...
kubectl apply -f k8s/manifests/k8s/backend-deployment.yaml --context kind-kind-1

echo Verifying deployment...
kubectl get deployment/backend --watch
kubectl get po -lapp=backend --watch 
# Wait 
echo Creating ingress controller...
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

echo Checking the deployment of ingress controller...
kubectl -n ingress-nginx get deploy -w
# Wait

echo Applying a service... 
kubectl apply -f k8s/manifests/k8s/backend-service.yaml --context kind-kind-1

echo Checking service...
kubectl get svc 

echo Applying an ingress object...
kubectl apply -f k8s/manifests/k8s/backend-ingress.yaml --context kind-kind-1

echo Checking ingress object...
kubectl get ingress
# Wait 

echo Check if image is running on localhost...
curl localhost:80
