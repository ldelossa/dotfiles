function mkmodconfig() {
    lsmod > /tmp/lsmod.now
    yes "" | make LSMOD=/tmp/lsmod.now localmodconfig
}

function kbuild() {
    make -j $(($(nproc)*2))
}
