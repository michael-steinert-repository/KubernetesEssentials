#!/usr/bin/env bash

set -e

kubectl create \
  --namespace websites \
  secret docker-registry \
  docker-hub \
  --docker-server=... \
  --docker-username=... \
  --docker-password=... \
