#!/bin/bash

# build and push the cilium dev agent image to
# a local repository at localhost:5000
function cilium-agent-push {
    cd ~/git/go/cilium
    make dev-docker-image && \
        docker tag quay.io/cilium/cilium-dev:latest localhost:5000/cilium/cilium-dev:$1 \
        && docker push localhost:5000/cilium/cilium-dev:$1
    cd -
}

# build and push the cilium generic operator image to
# a local repository at localhost:5000
function cilium-operator-push {
    cd ~/git/go/cilium
    make docker-operator-images-all && \
        docker tag quay.io/cilium/operator-generic:latest localhost:5000/cilium/operator-generic:$1 \
        && docker push localhost:5000/cilium/operator-generic:$1
    cd -
}
