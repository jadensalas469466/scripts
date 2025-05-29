#!/bin/bash

# 错误检测
set -e

# 创建目录
mkdir -p "/home/sec/.local/bin"

# 获取 Sliver 的最新版本
echo "Fetching latest Sliver release URLs..."
ARTIFACTS=$(curl -s "https:/api.github.com/repos/BishopFox/sliver/releases/latest" | awk -F '"' '/browser_download_url/{print $4}')
SLIVER_SERVER="sliver-server_linux"
SLIVER_CLIENT="sliver-client_linux"

# 下载 Sliver 的最新版本
for URL in $ARTIFACTS; do

    if [[ "$URL" == *"$SLIVER_SERVER"* && "$URL" != *.sig ]]; then
        echo "Downloading sliver-server"
        curl -L "$URL" -o "/home/sec/.local/bin/sliver-server"
    fi
    
    if [[ "$URL" == *"$SLIVER_CLIENT"* && "$URL" != *.sig ]]; then
        echo "Downloading sliver-client"
        curl -L "$URL" -o "/home/sec/.local/bin/sliver-client"
    fi
done

if test -f "/home/sec/.local/bin/sliver-client"; then
    echo "Setting permissions for the Sliver client executable..."
    chmod 755 "/home/sec/.local/bin/sliver-client"
else
    exit 3
fi

if test -f "/home/sec/.local/bin/sliver-server"; then
    echo "Setting permissions for the Sliver server executable..."
    chmod 755 "/home/sec/.local/bin/sliver-server"
else
    exit 3
fi

# systemd
echo "Configuring systemd service ..."

sudo -E tee /etc/systemd/system/sliver.service > /dev/null << 'EOF'

[Unit]
Description=Sliver
After=network.target
StartLimitIntervalSec=0

[Service]
Type=simple
Restart=on-failure
RestartSec=3
User=root
ExecStart=/home/sec/.local/bin/sliver-server daemon

[Install]
WantedBy=multi-user.target

EOF

sudo -E chown root:root /etc/systemd/system/sliver.service
sudo -E chmod 600 /etc/systemd/system/sliver.service

echo "Starting the Sliver service..."
sudo -E systemctl start sliver

# Generate local configs
echo "Generating configs ..."
mkdir -p /home/sec/.local/bin/.sliver-client/configs
/home/sec/.local/bin/sliver-server operator --name sec --lhost localhost --save /home/sec/.local/bin/.sliver-client/configs
chown -R sec:sec /home/sec/.local/bin/.sliver-client/

echo "Sliver has been successfully installed to /home/sec/.local/bin."
