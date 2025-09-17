#!/bin/bash

# 错误检测
set -e

# 切换到家目录
cd "$HOME"

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

# 判断 Shell 类型
user_shell=$(basename "$SHELL")
if [ "$user_shell" = "bash" ]; then
    shell_rc="$HOME/.bashrc"
elif [ "$user_shell" = "zsh" ]; then
    shell_rc="$HOME/.zshrc"
else
    echo "Unsupported shell: $user_shell. Please add the following lines to your shell configuration file manually."
    shell_rc="/dev/null"
fi

if ! grep -Fxq 'source ~/.local/bin/proxy.sh' "$shell_rc"; then
    printf '\nsource ~/.local/bin/proxy.sh\n' >> "$shell_rc"
fi

echo "Proxy has been installed successfully."
echo
echo "Run \"source $shell_rc\" to apply changes."
