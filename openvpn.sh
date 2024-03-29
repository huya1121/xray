#install openvpn-as in debian 10+
read -p "请输入域名:" domain
apt update && apt -y install ca-certificates wget net-tools gnupg nginx socat
curl  https://get.acme.sh | sh -s email=abc@gmail.com
acme(){
echo "安装证书中"
/etc/init.d/nginx stop
/root/.acme.sh/acme.sh --issue -d $domain   --standalone
/etc/init.d/nginx start
mkdir -p /etc/nginx/ssl/
/root/.acme.sh/acme.sh --install-cert -d $domain \
--key-file       /etc/nginx/ssl/$domain.key.pem  \
--fullchain-file /etc/nginx/ssl/$domain.cert.pem \
--reloadcmd     "service nginx force-reload"
if [ $? eq 0 ]; then
echo "安装证书完成"
else 
echo "安装证书失败"
fi


openvpnas() {
wget -qO - https://as-repository.openvpn.net/as-repo-public.gpg | apt-key add -
echo "deb http://as-repository.openvpn.net/as/debian buster main">/etc/apt/sources.list.d/openvpn-as-repo.list
apt update && apt -y install openvpn-as > ~/openvpnpassword
mkdir -p /etc/systemd/system/openvpnas.service.d
cat > /etc/systemd/system/openvpnas.service.d/override.conf <<EOF
[Service]
ExecStartPre=/opt/openvpnas-cert.sh
EOF
systemctl daemon-reload
wget -P /opt/ https://raw.githubusercontent.com/huya1121/xray/master/openvpnas-cert.sh
sed -i "s/abc.com/$domain/g" /opt/openvpnas-cert.sh
chmod +x /opt/openvpnas-cert.sh
mv /usr/local/openvpn_as/lib/python/pyovpn-2.0-py3.7.egg /usr/local/openvpn_as/lib/python/pyovpn-2.0-py3.7.egg.bak
wget -qP /usr/local/openvpn_as/lib/python https://raw.githubusercontent.com/huya1121/xray/master/pyovpn-2.0-py3.7.egg

}

acme
openvpnas
systemctl restart openvpnas
echo "安装完成，请在openvpnpassword中查看管理员登录密码"
