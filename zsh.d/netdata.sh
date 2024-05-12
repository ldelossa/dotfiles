function netdata-up() {
    docker run -d --name=netdata \
      --pid=host \
      --network=host \
      -v netdataconfig:/etc/netdata \
      -v netdatalib:/var/lib/netdata \
      -v netdatacache:/var/cache/netdata \
      -v /etc/passwd:/host/etc/passwd:ro \
      -v /etc/group:/host/etc/group:ro \
      -v /etc/localtime:/etc/localtime:ro \
      -v /proc:/host/proc:ro \
      -v /sys:/host/sys:ro \
      -v /etc/os-release:/host/etc/os-release:ro \
      -v /var/log:/host/var/log:ro \
      -v /var/run/docker.sock:/var/run/docker.sock:ro \
      -v /run/dbus:/run/dbus:ro \
      --restart unless-stopped \
      --cap-add SYS_PTRACE \
      --cap-add SYS_ADMIN \
      --security-opt apparmor=unconfined \
      netdata/netdata
}

alias netdata-down="docker stop netdata && docker rm netdata"
