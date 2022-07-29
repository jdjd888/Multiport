#!/bin/bash
MYIP=$(wget -qO- ipinfo.io/ip);
clear
#Update Repository VPS
clear
apt update 
apt-get -y upgrade

#Port Server
#Jika Ingiin Mengubah Port Silahkan Sesuaikan Dengan Port Yang Ada Di VPS Mu
Port_OpenVPN_TCP='1194';
Port_Squid='3128';
Port_OHP='8087';

#Installing ohp Server
cd 
wget -O /usr/local/bin/ohp "https://raw.githubusercontent.com/SandakanVPNTrickster/Squidvpn-v3/main/ohp"
chmod +x /usr/local/bin/ohp

#Buat File OpenVPN TCP OHP
cat > /etc/openvpn/tcp-ohp.ovpn <<END

setenv CLIENT_CERT 0
setenv opt block-outside-dns
client
dev tun
proto tcp
setenv FRIENDLY_NAME "VPN-OHP"
remote "bug.com" 1194
http-proxy xxxxxxxxx 8087
persist-tun
persist-key
persist-remote-ip
comp-lzo
reneg-sec 0
pull
resolv-retry infinite
remote-cert-tls server
verb 3
auth-user-pass
cipher none
auth none
auth-nocache
script-security 2
tls-version-min 1.2
tls-cipher TLS-ECDHE-ECDSA-WITH-AES-128-GCM-SHA256
END

sed -i $MYIP2 /etc/openvpn/tcp-ohp.ovpn;

# masukkan certificatenya ke dalam config client TCP 1194
echo '<ca>' >> /etc/openvpn/tcp-ohp.ovpn
cat /etc/openvpn/server/ca.crt >> /etc/openvpn/tcp-ohp.ovpn
echo '</ca>' >> /etc/openvpn/tcp-ohp.ovpn
cp /etc/openvpn/tcp-ohp.ovpn /usr/share/nginx/html/tcp-ohp.ovpn
clear
cd 

#Buat Service Untuk OHP
cat > /etc/systemd/system/ohp.service <<END
[Unit]
Description=Direct Squid Proxy For OpenVPN TCP By You
Documentation=https://none.my
Documentation=https://t.me/SandakanVPNTrickster
Wants=network.target
After=network.target

[Service]
ExecStart=/usr/local/bin/ohp -port 8087 -proxy 127.0.0.1:3128 -tunnel 127.0.0.1:1194
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
END

systemctl daemon-reload
systemctl enable ohp
systemctl restart ohp
echo ""
echo -e "${GREEN}Done Installing OHP Server${NC}"
echo -e "Port OVPN OHP TCP: $ohp"
echo -e "Link Download OVPN OHP: http://$MYIP/tcp-ohp.ovpn"
