function gdb-remote {
    gdb -iex "target remote 0.0.0.0:$1"
}
