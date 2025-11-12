desc="Build the Cilium agent and operator images"
args=("--tag:[o] The image tag (defaults to 'local')" \
      "--debug:[o,b] Create a debug image" \
      "--push:[o,b] Push images to quay" \
      "--account:[o] The repository of the container image" \
      "--registery:[o] The registry of the container image")
help=("build-images", "Helper for building Cilium agent and operator images.

 Images are built with the quay.io/cilium/ prefix unless --account and --register
 specified, for example:
 quay.io/cilium/operator-generic and quay.io/cilium/cilium-dev.

 If --account and --registery is specified the resulting images will be tagged as
 '$registry/$account/operator-generic' and '$registry/$account/cilium-dev'

 Therefore, they can be directly pushed to Quay with the proper permissions for
 distribution.

 If the --debug flag is set a debug image is created. This image uses dlv as a
 Cilium process host and will wait for a remote debugger to connect to it. Once
 connected the Cilium application will run as normal.

 If the --push flag is set the successfully built images will be pushed to
 Quay.io. You must have permissions to do so prior to running the command.

 This script should be ran from the root a Cilium source code repository.
")

execute() {
	set -e
	export DOCKER_IMAGE_TAG="local"
	if [[ -n "${tag}" ]]; then
		export DOCKER_IMAGE_TAG="${tag}"
	fi
	if [[ -n "${registery}" ]]; then
		export DOCKER_REGISTRY="${registery}"
	fi
	if [[ -n "${account}" ]]; then
		export DOCKER_DEV_ACCOUNT="${account}"
	fi
	if [[ -n "${debug}" ]]; then
		export NOSTRIP=1
		export NOOPT=1
		export DEBUG_HOLD=true
	fi
	if [[ -n "${push}" ]]; then
		export DOCKER_FLAGS=--push
	fi
	lib_info "\n=== Starting Operator Build ===\n"
	make docker-operator-generic-image
	lib_info "\n=== Starting Agent Build ===\n"
	make dev-docker-image
}
