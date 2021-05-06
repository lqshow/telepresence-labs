#!/usr/bin/env bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  bin="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$bin/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
bin="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
cd $bin

source /usr/local/share/copy-kube-config.sh

# Setting ssh config
mkdir -p /root/.ssh && cp -r /root/.ssh-localhost/* /root/.ssh && chmod 700 /root/.ssh && chmod 600 /root/.ssh/*

# Setting the namespace preference
namespace="default"
if [[ $KUBERNETES_NAMESPACE ]]; then
  namespace=${KUBERNETES_NAMESPACE}
fi

kubectl config set-context --current --namespace=${namespace}

# Used for access kubernetes cluster
ln -s /tmp/known/var/run/secrets /var/run/secrets

# Debug your Kubernetes service locally, using your favorite debugging tool.
telepresence --mount=/tmp/known \
    --deployment telepresence-k8s-0-109 \
    --namespace ${namespace} \
    --run zsh
