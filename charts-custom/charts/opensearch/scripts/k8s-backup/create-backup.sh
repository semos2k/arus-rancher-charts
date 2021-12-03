#!/bin/bash

ns=efk
resources=( cm sc pv pvc po secrets sa svc controllerrevisions deploy rs sts deploy rs pods ingress)

mkdir $1

for rs in "${resources[@]}"; do
    kubectl -n ${ns} get $rs -o yaml > $1/$rs.yml
done
