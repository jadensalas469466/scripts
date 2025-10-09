#!/bin/bash

# 错误检测
set -e

# 切换到家目录
cd "$HOME"

# 获取 VeraCrypt 的最新版本
echo "Fetching latest VeraCrypt release URLs..."
ARTIFACTS=$(curl -fs "https://api.github.com/repos/veracrypt/VeraCrypt/releases/latest" \
    | awk -F '"' '$2 == "browser_download_url" { print $4 }')
VERACRYPT="Debian-12-amd64"

# 下载 VeraCrypt 的最新版本
echo "$ARTIFACTS" | while read -r URL; do

    if [[ "$URL" == *veracrypt-*-$VERACRYPT.deb && "$URL" != *.sig && "$URL" != *console* ]]; then
        echo "Downloading VeraCrypt"
        curl -fLO "$URL"
        curl -fLO "${URL}.sig"
    fi
done

# 签名验证

gpg --verify $HOME/veracrypt-*-$VERACRYPT.deb.sig $HOME/veracrypt-*-$VERACRYPT.deb || { echo "Server file signature verification failed"; exit 1; }

# 安装 VeraCrypt
echo "Installing VeraCrypt..."
sudo gdebi -n veracrypt-*-$VERACRYPT.deb
trash veracrypt-*-$VERACRYPT.deb veracrypt-*-$VERACRYPT.deb.sig

echo "VeraCrypt has been successfully installed."
