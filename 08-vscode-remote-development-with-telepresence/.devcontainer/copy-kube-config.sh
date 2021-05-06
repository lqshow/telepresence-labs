#!/usr/bin/env bash

# Copies localhost's ~/.kube/config file into the container and swap out localhost
# for host.docker.internal whenever a new shell starts to keep them in sync.
if [ "$SYNC_LOCALHOST_KUBECONFIG" = "true" ] && [ -d "/root/.kube-localhost" ]; then
    mkdir -p $HOME/.kube
    cp -r /root/.kube-localhost/gen-config $HOME/.kube/config
    KUBECONFIG=$HOME/.kube/config
fi