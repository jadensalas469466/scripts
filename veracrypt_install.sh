#!/bin/bash

# 错误检测
set -e

# 切换到家目录
cd "$HOME"

# 导入公钥
gpg --keyserver keys.openpgp.org --recv-keys 5069A233D55A0EEB174A5FC3821ACD02680D16DE || { echo "Failed to import GPG key"; exit 1; }

# 获取 VeraCrypt 的最新版本
echo "Fetching latest VeraCrypt release URLs..."
ARTIFACTS=$(curl -fs "https://api.github.com/repos/veracrypt/VeraCrypt/releases/latest" \
    | awk -F '"' '$2 == "browser_download_url" { print $4 }')
VERACRYPT="Debian-12-amd64"

# 下载 VeraCrypt 的最新版本
echo "$ARTIFACTS" | while read -r URL; do

    if [[ "$URL" == *veracrypt-*-$VERACRYPT.deb && "$URL" != *.sig && "$URL" != *console* ]]; then
        echo "Downloading VeraCrypt"
        wget "$URL"
        wget "${URL}.sig"
    fi
done

# 签名验证

gpg --verify $HOME/veracrypt-*-$VERACRYPT.deb.sig $HOME/veracrypt-*-$VERACRYPT.deb || { echo "Server file signature verification failed"; exit 1; }

# 安装 VeraCrypt
echo "Installing VeraCrypt..."
sudo gdebi -n veracrypt-*-$VERACRYPT.deb
rm -f veracrypt-*-$VERACRYPT.deb veracrypt-*-$VERACRYPT.deb.sig

echo "VeraCrypt has been successfully installed."
