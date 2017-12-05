#!/bin/bash
kubectl create clusterrolebinding prometheus --clusterrole=cluster-admin --user=system:serviceaccount:default:prometheus
