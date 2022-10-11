#!/bin/bash
proxy="192.168.14.254:1080"
no_proxy="localhost, 127.0.0.1, ::1"

function proxyOn() {
  export http_proxy=$proxy
  export https_proxy=$proxy
  export no_proxy=$no_proxy
}
function proxyOff() {
  unset ALL_PROXY
  unset http_proxy
  unset https_proxy
}

case $1 in
    start)
      proxyOn
      ;;
    stop)
      proxyOff
      ;;
esac

# source linuxProxy.sh
