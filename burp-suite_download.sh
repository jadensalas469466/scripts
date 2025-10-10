#!/bin/bash

# 错误检测
set -e

# 切换到家目录
cd "$HOME"

# 获取 Burp Suite 的最新版本
latest_version=$(curl -s --connect-timeout 15 -H "Cache-Control: no-cache" https://portswigger.net/burp/releases \
    | grep -m1 -oE "/burp/releases/professional-community-[0-9]{4}-[0-9]{1,2}(-[0-9]{1,2})?" \
    | sed -E 's/.*\/burp\/releases\/professional-community-([0-9]{4}-[0-9]{1,2}(-[0-9]{1,2})?).*/\1/'
)

if [[ -z "$latest_version" ]]; then
    echo "Error: \"Failed to retrieve the latest Burp Suite version. Please check your network.\""
    exit 1
fi

echo "Latest version: Burp Suite $latest_version"

# 下载 Burp Suite 的最新版本
latest_package=${latest_version//-/.}
download_file="burpsuite_pro_linux_v$latest_package.sh"
curl -fL "https://portswigger.net/burp/releases/download?product=pro&version=$latest_package&type=Linux" -o "$download_file"

if [[ ! -f "$download_file" ]]; then
    echo "Download failed. Please check your network."
    exit 1
fi

echo "Download completed: Burp Suite Professional $latest_package"
