#Debian10 supported
#/bin/bash
apt update
apt-get install libsodium-dev shadowsocks-libev -y
apt-get clean

read -p "请输入SS端口:" SSPORT
read -p "请输入SS密码:" SSPASSWORD

cat > /etc/shadowsocks-libev/config.json << EOF
{
    "server":"0.0.0.0",
    "server_port":$SSPORT,
    "password":"$SSPASSWORD",
    "timeout":300,
    "method":"aes-256-gcm",
    "fast_open":false,
    "nameserver":"1.0.0.1",
    "mode":"tcp_and_udp",
}
EOF

cat > /etc/systemd/system/shadowsocks.service << EOF
[Unit]
Description=shadowsocks-libev
After=network.target
[Service]
Type=simple
ExecStart=/usr/bin/ss-server -c /etc/shadowsocks-libev/config.json
Restart=always
LimitNOFILE=512000
[Install]
WantedBy=multi-user.target
EOF

systemctl disable shadowsocks-libev
systemctl stop shadowsocks-libev
systemctl enable shadowsocks
systemctl restart shadowsocks
echo "SS密码为$SSPORT"
echo "SS端口为$SSPASSWORD"
echo "SS加密方式为aes-256-gcm"
