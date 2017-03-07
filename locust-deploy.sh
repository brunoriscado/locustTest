#!/bin/bash

#-h host
#-p port
#-k kubeconfig
#-i locust-task image tag
#-s http/https
while getopts ":h:k:i:w:" o; do
    case "${o}" in
        h) h=${OPTARG}
            ;;
        k) k=${OPTARG}
            ;;
        i) i=${OPTARG}
            ;;
        \?) echo "Unknow option"
            exit 1
            ;;
    esac
done

export target_host=$h
export image_version=$i

echo "host: ${target_host}"
echo "kubeconfig: ${k}"
echo "image_version: ${i}"

#TODO - should loop any file in template
perl -p -e 's/\$\{([^}]+)\}/defined $ENV{$1} ? $ENV{$1} : $&/eg; s/\$\{([^}]+)\}//eg' locust-yml/templates/locust-master-controller.yml.tp > locust-yml/yml/locust-master-controller.yml
perl -p -e 's/\$\{([^}]+)\}/defined $ENV{$1} ? $ENV{$1} : $&/eg; s/\$\{([^}]+)\}//eg' locust-yml/templates/locust-master-service.yml.tp > locust-yml/yml/locust-master-service.yml
perl -p -e 's/\$\{([^}]+)\}/defined $ENV{$1} ? $ENV{$1} : $&/eg; s/\$\{([^}]+)\}//eg' locust-yml/templates/locust-worker-controller.yml.tp > locust-yml/yml/locust-worker-controller.yml
perl -p -e 's/\$\{([^}]+)\}/defined $ENV{$1} ? $ENV{$1} : $&/eg; s/\$\{([^}]+)\}//eg' locust-yml/templates/testing-namespace.yml.tp > locust-yml/yml/testing-namespace.yml

kubectl --kubeconfig="${k}" delete services locust-master --namespace=testing
kubectl --kubeconfig="${k}" delete rc locust-master --namespace=testing
kubectl --kubeconfig="${k}" delete rc locust-worker --namespace=testing
kubectl --kubeconfig="${k}" delete namespace testing

kubectl --kubeconfig="${k}" apply -f 'locust-yml/yml/testing-namespace.yml' --namespace=testing
kubectl --kubeconfig="${k}" apply -f 'locust-yml/yml/' --namespace=testing

echo $(kubectl --kubeconfig="${k}" describe services locust-master --namespace=testing)