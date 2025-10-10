#!/bin/bash

# 错误检测
set -e

# 切换到家目录
cd "$HOME"

# 获取 Koodo Reader 的最新版本
echo "Fetching latest Koodo Reader release URLs..."
ARTIFACTS=$(curl -fs "https://api.github.com/repos/koodo-reader/koodo-reader/releases/latest" \
    | awk -F '"' '$2 == "browser_download_url" { print $4 }')

# 下载 Koodo Reader 的最新版本
echo "$ARTIFACTS" | while read -r URL; do

    if [[ "$URL" == *Koodo-Reader-*-amd64.deb ]]; then
        echo "Downloading Koodo Reader"
        curl -fLO "$URL"
    fi
done

# 安装 Koodo Reader
echo "Installing Koodo Reader..."
sudo gdebi -n Koodo-Reader-*-amd64.deb
rm -f Koodo-Reader-*-amd64.deb

echo "Koodo Reader has been successfully installed."
