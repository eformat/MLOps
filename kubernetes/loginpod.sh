
export POD=$(kubectl get pods -n=mlops --no-headers | awk '{print $1}')
kubectl exec -it -n=mlops $POD -- /bin/bash

