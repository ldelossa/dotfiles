function procs-kill() {
    procs ${1} --no-header | cut -d " " -f 2 | xargs kill -SIGKILL
}
