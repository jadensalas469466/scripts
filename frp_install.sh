#!/bin/bash

# 错误检测
set -e

# 切换到家目录
cd "$HOME"

# 创建目录
mkdir -p "$HOME/.local/bin"

# 获取 frp 的最新版本
echo "Fetching latest frp release URLs..."
ARTIFACTS=$(curl -fs "https://api.github.com/repos/fatedier/frp/releases/latest" \
    | awk -F '"' '$2 == "browser_download_url" { print $4 }')

# 下载 frp 的最新版本
echo "$ARTIFACTS" | while read -r URL; do

    if [[ "$URL" == *frp_*_linux_amd64.tar.gz ]]; then
        echo "Downloading frp"
        curl -fLO "$URL"
    fi
done

# 解压 frp
FRP_ARCHIVE=$(ls frp_*_linux_amd64.tar.gz | head -n 1)
if test -f "$FRP_ARCHIVE"; then
    tar -xzvf "$FRP_ARCHIVE"
    rm -f "$FRP_ARCHIVE"
    FRP_DIR=$(echo "$FRP_ARCHIVE" | sed 's/\.tar\.gz//')
    mv "$FRP_DIR" "$HOME/.local/frp"
    ln -s "$HOME/.local/frp/frps" "$HOME/.local/bin/frps"
    ln -s "$HOME/.local/frp/frpc" "$HOME/.local/bin/frpc"
else
    exit 2
fi

# Generate config
echo "Generating config ..."

FRP_CONFIG="$HOME/.frp"
mkdir -p "$FRP_CONFIG"
TOKEN=$(openssl rand -hex 16)
echo "$TOKEN" > "$FRP_CONFIG/frp_token"
chmod 600 "$FRP_CONFIG/frp_token"

# Server config

cat << EOF > "$FRP_CONFIG/frps.toml"
bindPort = 7000
transport.tcpMux = true
transport.tls.force = true
auth.tokenSource.type = "file"
auth.tokenSource.file.path = "$FRP_CONFIG/frp_token"
EOF

# Client config

cat << EOF > "$FRP_CONFIG/frpc.toml"
serverAddr = "evil.com"
serverPort = 7000
transport.tcpMux = true
transport.tls.enable = true
auth.tokenSource.type = "file"
auth.tokenSource.file.path = "$FRP_CONFIG/frp_token"

[[proxies]]
name = "tcp"
type = "tcp"
localIP = "127.0.0.1"
localPort = 6000
remotePort = 6000
EOF

# systemd
echo "Configuring systemd service ..."
FRP_PATH="$HOME/.local/bin"

sudo -E tee /etc/systemd/system/frps.service > /dev/null << EOF
[Unit]
Description=frps
After=network.target syslog.target
Wants=network.target

[Service]
Type=simple
ExecStart=$FRP_PATH/frps -c $FRP_CONFIG/frps.toml

[Install]
WantedBy=multi-user.target
EOF

sudo -E chown root:root /etc/systemd/system/frps.service
sudo -E chmod 600 /etc/systemd/system/frps.service
sudo -E systemctl daemon-reload

echo "frp has been successfully installed to $HOME/.local/frp."
