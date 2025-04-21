desc="Helper for running BPF unit tests"
args=("--test_file:[o] Run a particular test by it's filename" \
	  "--verbose:[o,b] Verbose output to tests" \
	  "--dump_ctx:[o,b] Dump the ctx for debugging")
help=("run-bpf-tests", "Helper for running BPF unit tests

 This script should be ran from the root a Cilium source code repository.

 Runs the eBPF unit tests with the provided options.
 If no flags are provided all test are ran without verbose output.
")

execute() {
	if [[ ${+test_file} -eq 1 ]]; then
		export BPF_TEST_FILE="${test_file}"
	fi
	if [[ ${+verbose} -eq 1 ]]; then
		export BPF_TEST_VERBOSE=1
	fi
	if [[ ${+dump_ctx} -eq 1 ]]; then
		export BPF_TEST_DUMP_CTX=1
	fi

	make run_bpf_tests
}
