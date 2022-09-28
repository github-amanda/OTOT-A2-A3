echo Appyling metrics server...
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

echo Opening metrics-server file...
kubectl -nkube-system edit deploy/metrics-server

# Add --kubelet-insecure-tls flag

echo Restarting deployment...
kubectl -nkube-system rollout restart deploy/metrics-server 

echo Applying load...
curl localhost --silent -o /dev/null 
# Refresh localhost multiple times to apply load

echo Applying HPA...
kubectl apply -f k8s/manifests/k8s/backend-hpa.yaml --context kind-kind-1
kubectl get po
kubectl describe hpa

echo Viewing nodes...
kubectl get nodes -L topology.kubernetes.io/zone

echo Creating zone-aware deployment...
kubectl apply -f k8s/manifests/k8s/backend-zone-aware.yaml --context kind-kind-1
kubectl get deployment/backend-zone-aware --watch

echo Creating zone-aware service...
kubectl apply -f k8s/manifests/k8s/backend-service-zone-aware.yaml --context kind-kind-1

echo Checking service...
kubectl get svc 

echo Deleting ingress...
kubectl delete ingress backend-ingress

echo Creating zone-aware ingress... 
kubectl apply -f k8s/manifests/k8s/backend-ingress-zone-aware.yaml --context kind-kind-1

echo Checking zone-aware ingress...
kubectl get ingress --watch

echo Checking pods...
kubectl get po -lapp=backend-zone-aware -owide --sort-by=.spec.nodeName
