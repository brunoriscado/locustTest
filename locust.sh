#!/bin/bash

#-c command (ex: start/stop)
#-u locust_count / users
#-r hatch_rate / requests per second

#
while getopts ":c:u:r:" o; do
    case "${o}" in
        c) c=${OPTARG}
            ;;
        u) u=${OPTARG}
            ;;
        r) r=${OPTARG}
            ;;
        \?) echo "Unknow option"
            exit 1
            ;;
    esac
done

ip=$(minikube ip)
port=$(kubectl describe services locust-master --namespace=testing | egrep "NodePort.*loc-master-web" | awk '{print $3}' | awk -F"/" '{print $1}')

if [[ "${c}" == "start" ]]; then
    curl -XPOST -d "locust_count=${u}&hatch_rate=${r}" "${ip}:${port}/swarm"
elif [[ "${c}" == "stop" ]]; then
    curl -XGET "${ip}:${port}/stop"
elif [[ "${c}" == "stats-requests-json" ]]; then
    curl -XGET "${ip}:${port}/stats/requests" | python -mjson.tool
elif [[ "${c}" == "stats-requests-csv" ]]; then
    curl -XGET "${ip}:${port}/stats/requests/csv"
elif [[ "${c}" == "stats-distribution" ]]; then
    curl -XGET "${ip}:${port}/stats/distribution/csv"
elif [[ "${c}" == "exceptions" ]]; then
    curl -XGET "${ip}:${port}/exceptions" | python -mjson.tool
fi