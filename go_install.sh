#!/bin/bash

# 错误检测
set -e

# 切换到家目录
cd "$HOME"

# 创建目录
mkdir -p "$HOME/.local/bin"

# 获取 Go 的最新版本
latest_version=$(curl -s --connect-timeout 15 -H "Cache-Control: no-cache" https://go.dev/dl/|grep -w downloadBox|grep src|grep -oE "[0-9]+\.[0-9]+\.?[0-9]*"|head -n 1)
if [[ -z "$latest_version" ]]; then
    echo "Error: \"Failed to retrieve the latest Go version. Please check your network.\""
    exit 1
fi

echo "Latest version: Go $latest_version"

# 检查是否已经安装 Go
if type go &>/dev/null; then
    # 获取 Go 的当前版本
    installed_version=$(go version | awk '{print $3}' | sed 's/go//')
    echo "Installed version: Go $installed_version"
    # 如果当前版本不等于最新版本，删除旧版本
    if [[ "$installed_version" != "$latest_version" ]]; then
        add_env=false
        sudo -E rm -rf /usr/local/go
    else
        echo "Go $installed_version is the latest version. No upgrade needed."
        exit 0
    fi
else
    add_env=true
fi

# 下载 Go 的最新版本
linux_package=go$latest_version.linux-amd64.tar.gz
curl -fLO "https://go.dev/dl/$linux_package"

if [[ ! -f "$linux_package" ]]; then
    echo "Download failed. Please check your network."
    exit 1
fi

sudo -E tar -C /usr/local/ -xzf "$linux_package"
rm -rf "$linux_package"

if [[ "$add_env" == false ]]; then
    echo "Go $installed_version has been upgraded to Go $latest_version."
elif [[ "$add_env" == true ]]; then

    # 判断 Shell 类型
    user_shell=$(basename "$SHELL")
    if [[ "$user_shell" == "bash" ]]; then
        shell_rc="$HOME/.bashrc"
    elif [[ "$user_shell" == "zsh" ]]; then
        shell_rc="$HOME/.zshrc"
    else
        echo "Unsupported shell: $user_shell. Please add the following lines to your shell configuration file manually."
        shell_rc="/dev/null"
    fi
    
    # 添加环境变量到 Shell 配置文件
    cat << 'EOF' >> $shell_rc

# Go env
export PATH="$HOME/.local/bin:/usr/local/go/bin:$PATH"
export GOPATH="$HOME/.local/go"
export GOBIN="$HOME/.local/bin"
EOF

    echo "The latest version of Go $latest_version is installed."
    echo
    echo "Run \"source $shell_rc\" to apply changes."
fi