#!/bin/bash

# 错误检测
set -e

# 切换到家目录
cd "$HOME"

# 获取 LocalSend 的最新版本
echo "Fetching latest LocalSend release URLs..."
ARTIFACTS=$(curl -fs "https://api.github.com/repos/localsend/localsend/releases/latest" \
    | awk -F '"' '$2 == "browser_download_url" { print $4 }')

# 下载 LocalSend 的最新版本
echo "$ARTIFACTS" | while read -r URL; do

    if [[ "$URL" == *LocalSend-*-linux-x86-64.deb ]]; then
        echo "Downloading LocalSend"
        curl -fLO "$URL"
    fi
done

# 安装 LocalSend
echo "Installing LocalSend..."
sudo gdebi -n LocalSend-*-linux-x86-64.deb
rm -f LocalSend-*-linux-x86-64.deb

echo "LocalSend has been successfully installed."
