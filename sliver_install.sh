#!/bin/bash

# 错误检测
set -e

# 创建目录
mkdir -p "$HOME/.local/bin"

# 获取 Sliver 的最新版本
ARTIFACTS=$(curl -s "https://api.github.com/repos/BishopFox/sliver/releases/latest" | awk -F '"' '/browser_download_url/{print $4}')
SLIVERS=("sliver-server_linux" "sliver-client_linux")

# 下载 Sliver 的最新版本
for URL in $ARTIFACTS; do
    for SLIVER in "${SLIVERS[@]}"; do
        if [[ "$URL" == *"$SLIVER"* && "$URL" != *.sig ]]; then
        echo "Downloading $URL"
        curl -L "$URL" -o "$HOME/.local/bin/$(basename "$URL")"
        fi
    done
done

# 添加执行权限
for f in $HOME/.local/bin/sliver*; do
    if [ -f "$f" ]; then
        chmod +x "$f"
    fi
done

echo "Sliver has been successfully installed to $HOME/.local/bin."
