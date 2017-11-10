sudo minikube stop

sudo minikube start \
  --vm-driver=none \
  --feature-gates=Accelerators=true 

sudo mv /root/.kube $HOME/.kube # this will write over any previous configuration
sudo chown -R $USER $HOME/.kube
sudo chgrp -R $USER $HOME/.kube

sudo mv /root/.minikube $HOME/.minikube # this will write over any previous configuration
sudo chown -R $USER $HOME/.minikube
sudo chgrp -R $USER $HOME/.minikube

minikube status
export CHANGE_MINIKUBE_NONE_USER=true