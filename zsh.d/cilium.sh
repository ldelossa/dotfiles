#!/bin/bash

# build and push the cilium dev agent image to
# a local repository at localhost:5000
function cilium-agent-push {
    if [ -z "${1}" ]; then
        echo "tag not provided"
        return
    fi
    cd /home/louis/git/gopath/src/github.com/cilium/cilium
    make dev-docker-image && \
        docker tag quay.io/cilium/cilium-dev:latest localhost:5000/cilium/cilium-dev:$1 \
        && docker push localhost:5000/cilium/cilium-dev:$1
    cd -
}

# build and push the cilium generic operator image to
# a local repository at localhost:5000
function cilium-operator-push {
    if [ -z "${1}" ]; then
        echo "tag not provided"
        return
    fi
    cd /home/louis/git/gopath/src/github.com/cilium/cilium
    make docker-operator-images-all && \
        docker tag quay.io/cilium/operator-generic:latest localhost:5000/cilium/operator-generic:$1 \
        && docker push localhost:5000/cilium/operator-generic:$1
    cd -
}

# build and push the cilium dev agent image to
# a local repository at localhost:5000
function cilium-agent-push-local {
    if [ -z "${1}" ]; then
        echo "tag not provided"
        return
    fi
    make dev-docker-image && \
        docker tag quay.io/cilium/cilium-dev:latest localhost:5000/cilium/cilium-dev:$1 \
        && docker push localhost:5000/cilium/cilium-dev:$1
}

# build and push the cilium generic operator image to
# a local repository at localhost:5000
function cilium-operator-push-local {
    if [ -z "${1}" ]; then
        echo "tag not provided"
        return
    fi
    make docker-operator-images-all && \
        docker tag quay.io/cilium/operator-generic:latest localhost:5000/cilium/operator-generic:$1 \
        && docker push localhost:5000/cilium/operator-generic:$1
}

# cilium helm install will install Cilium to the cluster kubectl
# points to utilizing any helm templates built from the current 
# checked out Cilium branch.
cilium-helm-install(){
    if [ -z "${1}" ]; then
        echo "tag not provided"
        return
    fi
    ciliumVersion=${1}
    cd /home/louis/git/gopath/src/github.com/cilium/cilium/install/kubernetes
    CILIUM_CI_TAG="${1}"
    helm template cilium ./cilium \
      --namespace kube-system \
      --set debug.enabled=true \
      --set image.repository=localhost:5000/cilium/cilium-dev \
      --set image.tag=$CILIUM_CI_TAG \
      --set operator.image.repository=localhost:5000/cilium/operator \
      --set operator.image.suffix="" \
      --set operator.image.tag=$CILIUM_CI_TAG | tee /tmp/cilium.yaml
    kubectl apply -f /tmp/cilium.yaml
    cd -
}

# cilium buid and deploy will build the agent and operator, push to a kind repo
# and install cilium via helm.
cilium-build-and-deploy() {
    if [ -z "${1}" ]; then
        echo "tag not provided"
        return
    fi
    cilium-agent-push ${1} && cilium-operator-push ${1} && cilium-helm-install ${1}
}
