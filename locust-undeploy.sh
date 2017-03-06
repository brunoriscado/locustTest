#!/bin/bash

while getopts ":k:" o; do
    case "${o}" in
        k) k=${OPTARG}
            ;;
        \?) echo "Unknow option"
            exit 1
            ;;
    esac
done

kubectl --kubeconfig=${k} delete namespace testing