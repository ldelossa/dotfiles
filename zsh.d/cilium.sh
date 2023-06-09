#!/bin/bash

alias cilium-backport='docker run -e GITHUB_TOKEN=$(cat ~/Dropbox/Docs/GithubToken-Isovalent-TopHat) -v $(pwd):/cilium -v "$HOME/.ssh":/home/user/.ssh \
      -w /cilium -it cilium-backport /bin/bash'

# CILIUM_SRC is the environment variable pointing to Cilium's source code, if
# it does not exist we default it to GoPath.
SRC=${CILIUM_SRC:-$GOPATH/src/github.com/cilium/cilium}

export CIL_AGENT_LABEL="app.kubernetes.io/name=cilium-agent"

export CIL_OP_LABEL="app.kubernetes.io/name=cilium-operator"

# below functions run in a sub-shell to avoid any conflicts of changes in the
# parent shell issuing these functions.

# build and push the cilium dev agent image to a local repository at 
# localhost:5000
cilium-agent-push () {
    (   
        set -e
        if [ -z "${1}" ]
        then
            echo "tag not provided"
            false
        fi
        printf "%0.s\e[34m=" {1..$COLUMNS}
        echo "\e[34mBuiling and pushing Cilium agent to localhost:5000/cilium"
        echo "\e[34mUsing $SRC for Cilium's repository"
        echo "\e[34mIf incorrect, set CILIUM_SRC env var to Cilium's source code"
        printf "%0.s\e[34m=" {1..$COLUMNS}
        cd $SRC 
        DOCKER_FLAGS=--push DOCKER_IMAGE_TAG=${1} DOCKER_DEV_ACCOUNT=localhost:5000/cilium make dev-docker-image
    )
}

# build and push the cilium generic operator image to
# a local repository at localhost:5000
function cilium-operator-push {
    (
        set -e
        if [ -z "${1}" ]; then
            echo "tag not provided"
            false
        fi
        printf "%0.s\e[34m=" {1..$COLUMNS}
        echo "\e[34mBuiling and pushing Cilium operator (generic) to localhost:5000/cilium"
        echo "\e[34mUsing $SRC for Cilium's repository"
        echo "\e[34mIf incorrect, set CILIUM_SRC env var to Cilium's source code"
        printf "%0.s\e[34m=" {1..$COLUMNS}
        cd $SRC 
        DOCKER_FLAGS=--push DOCKER_IMAGE_TAG=${1} DOCKER_DEV_ACCOUNT=localhost:5000/cilium make docker-operator-generic-image
    )
}

# cilium helm install will install Cilium to the cluster kubectl points to 
# utilizing any helm templates built from the current checked out Cilium branch.
cilium-helm-install(){
    (
        set -e
        if [ -z "${1}" ]; then
            echo "tag not provided"
            false
        fi
        printf "%0.s\e[34m=" {1..$COLUMNS}
        echo "\e[34mInstalling Cilium to cluster that kubectl currently points to"
        echo "\e[34mHelm templates will be written to /tmp/cilium.yaml"
        echo "\e[34mUsing $SRC for Cilium's repository"
        echo "\e[34mIf incorrect, set CILIUM_SRC env var to Cilium's source code"
        printf "%0.s\e[34m=" {1..$COLUMNS}
        ciliumVersion=${1}
        cd $SRC/install/kubernetes
        CILIUM_CI_TAG="${1}"
        helm template cilium ./cilium \
          --namespace kube-system \
          --set debug.enabled=true \
          --set image.repository=localhost:5000/cilium/cilium-dev \
          --set image.tag=$CILIUM_CI_TAG \
          --set operator.image.repository=localhost:5000/cilium/operator \
          --set operator.image.suffix="" \
          --set operator.image.tag=$CILIUM_CI_TAG > /tmp/cilium.yaml
        kubectl apply -f /tmp/cilium.yaml
    )
}

# cilium buid and deploy will build the agent and operator, push to a kind repo
# and install cilium via helm.
cilium-build-and-deploy() {
    (
        set -e
        if [ -z "${1}" ]; then
            echo "tag not provided"
            false
        fi
        cilium-agent-push ${1} && cilium-operator-push ${1} && cilium-helm-install ${1}
    )
}

# build operator and agent from local repository and push it to a kind cluster
# $1 = tag to use
# $2 = kind cluster to push to
# e.g: cilium-build-kind local kind-cluster-1
cilium-build-kind() {
    export DOCKER_IMAGE_TAG="$1"
    make docker-operator-generic-image && make dev-docker-image && kind load --name "$2" docker-image quay.io/cilium/operator-generic:"$1" && kind load --name "$2" docker-image quay.io/cilium/cilium-dev:"$1"
}

