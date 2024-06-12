cat > linuxProxy.sh << \EOF
#!/bin/bash
proxy="192.168.14.254:1080"
no_proxy="localhost, 127.0.0.1, ::1"

function proxyOn() {
  export http_proxy=http://$proxy
  export https_proxy=http://$proxy  # https 转向http代理，防止ssl错误发生
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
EOF

执行 `source linuxProxy.sh start` 开启代理


