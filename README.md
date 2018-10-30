Usage examples:

To run locally a kubernetes cluster is required so install Minikube: https://kubernetes.io/docs/getting-started-guides/minikube/

```
#To start the cluster:
minikube start 

#To deploy the pods/services
#-h host
#-k kubeconfig location
#-i docker image version
./locust-deploy.sh -h [hostname] -p 80 -k /home/bruno/.kube/config -i 1.3


#Start swarm tests
./locust.sh -c start -u 50 -r 50

#Get test requests json stats
./locust.sh -c stats-requests-json

#get test requests csv stats
./locust.sh -c stats-requests-csv

#get test requests distribution
./locust.sh -c stats-distribution

#get test request execution exception
./locust.sh -c exceptions

#stop test
./locust.sh -c stop

#undeploy locust pods/services
./locust-undeploy.sh -k /home/bruno/.kube/config
```
