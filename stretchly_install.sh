#!/bin/bash

# 错误检测
set -e

# 切换到家目录
cd "$HOME"

# 获取 Stretchly 的最新版本
echo "Fetching latest Stretchly release URLs..."
ARTIFACTS=$(curl -fs "https://api.github.com/repos/hovancik/stretchly/releases/latest" \
    | awk -F '"' '$2 == "browser_download_url" { print $4 }')

# 下载 Stretchly 的最新版本
echo "$ARTIFACTS" | while read -r URL; do

    if [[ "$URL" == *Stretchly_*_amd64.deb ]]; then
        echo "Downloading Stretchly"
        wget "$URL"
    fi
done

# 安装 Stretchly
echo "Installing Stretchly..."
sudo gdebi -n Stretchly_*_amd64.deb
rm -f Stretchly_*_amd64.deb

echo "Stretchly has been successfully installed."
