#!/bin/bash

# 错误检测
set -e

# 创建目录
mkdir -p "$HOME/.local/bin"

cat << 'EOF' > ~/.local/bin/proxy.sh

proxy() {
    # 清除旧代理
    unset http_proxy https_proxy ftp_proxy no_proxy

    if [ -z "$1" ]; then
        echo "Proxy is unset."
    else
        export http_proxy="http://$1"
        export https_proxy="$http_proxy"
        export ftp_proxy="$http_proxy"
        export no_proxy="localhost,127.0.0.1,192.168.0.0/16,::1"
        echo "Proxy set to: $http_proxy"
    fi
}

EOF

echo "Proxy has been installed successfully."
