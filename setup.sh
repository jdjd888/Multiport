#!/bin/bash
MYIP=$(wget -qO- ipinfo.io/ip);
clear
echo ""
echo -e "\e[33m ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e " \E[0;100;33m        • AutoScript by None •            \E[0m"
echo -e "\e[33m ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ''
echo -e "$green              Proses akan mula dalam 3 Saat!            $NC"
echo -e "\e[33m ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
sleep 3
clear
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "$green Sila Masukkan Sub Domain (sub.yourdomain.com) $NC"
echo -e "$green Jika tiada Sila [ Ctrl+C ] • To-Exit $NC"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
read -p " Hostname / Domain: " host
mkdir -p /etc/rare
mkdir -p /etc/rare/xray
mkdir -p /etc/rare/v2ray
mkdir -p /etc/rare/tls
mkdir -p /etc/rare/config-url
mkdir -p /etc/rare/config-user
mkdir -p /etc/rare/xray/conf
mkdir -p /etc/rare/v2ray/conf
mkdir -p /etc/systemd/system/
mkdir -p /var/log/xray/
mkdir -p /var/log/v2ray/
mkdir /var/lib/premium-script;
touch /etc/rare/xray/clients.txt
touch /etc/rare/v2ray/clients.txt
echo "IP=$host" >> /var/lib/premium-script/ipvps.conf
echo "$host" >> /etc/rare/xray/domain
echo "$host" >> /root/domain
clear
secs_to_human() {
    echo "Installation time : $(( ${1} / 3600 )) hours $(( (${1} / 60) % 60 )) minute's $(( ${1} % 60 )) seconds"
}
start=$(date +%s)
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "$green     Sila Tunggu sebentar             $NC"
echo -e "$gree Process Update & Upgrade Sedang Dijalankan  $NC"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
sleep 2
apt-get update && apt-get upgrade -y && update-grub -y
clear
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "$green  Process Update&Upgrade Selesai        $NC"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
sleep 2
clear
#install ssh ovpn
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "$green      Install SSH OVPN               $NC"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
sleep 2
wget https://raw.githubusercontent.com/SandakanVPNTrickster/Multiport/main/ssh-vpn.sh && chmod +x ssh-vpn.sh && screen -S ssh-vpn ./ssh-vpn.sh
clear
#install ssr
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "$green          Install SSR                $NC"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
sleep 2
wget https://raw.githubusercontent.com/SandakanVPNTrickster/Multiport/main/ssr.sh && chmod +x ssr.sh && screen -S ssr ./ssr.sh
wget https://raw.githubusercontent.com/SandakanVPNTrickster/Multiport/main/sodosok.sh && chmod +x sodosok.sh && screen -S ss ./sodosok.sh
clear
#install wireguard
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "$green        Install Wireguard              $NC"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
sleep 2
wget https://raw.githubusercontent.com/SandakanVPNTrickster/Multiport/main/wg.sh && chmod +x wg.sh && screen -S wg ./wg.sh
clear
#install v2ray
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "$green  ISSUE CERT & Install TROJAN GFW       $NC"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
sleep 2
wget https://raw.githubusercontent.com/SandakanVPNTrickster/Multiport/main/ins-vt.sh && chmod +x ins-vt.sh && screen -S v2ray ./ins-vt.sh
clear
#Instal Xray
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "$green          Install XRAY              $NC"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
sleep 2
wget https://raw.githubusercontent.com/SandakanVPNTrickster/Multiport/main/xray-go.sh && chmod +x xray-go.sh && screen -S xray-go ./xray-go.sh
clear
#Instal Xray
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "$green           Install V2RAY              $NC"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
sleep 2
wget https://raw.githubusercontent.com/SandakanVPNTrickster/Multiport/main/v2ray-go.sh && chmod +x v2ray-go.sh && screen -S v2ray-go ./v2ray-go.sh
#set backup
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "$green            SET BACKUP               $NC"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
sleep 2
wget https://raw.githubusercontent.com/SandakanVPNTrickster/Multiport/main/set-br.sh && chmod +x set-br.sh && ./set-br.sh
clear
# install OHP
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "$green          Install OHP                $NC"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
sleep 2
wget https://raw.githubusercontent.com/SandakanVPNTrickster/Multiport/main/ohp.sh && chmod +x ohp.sh && screen -S ohp ./ohp.sh

rm -f /root/ssh-vpn.sh
rm -f /root/ss.sh
rm -f /root/ssr.sh
rm -f /root/wg.sh
rm -f /root/ins-vt.sh
rm -f /root/set-br.sh
rm -f /root/xray-go.sh
rm -f /root/v2ray-go.sh
rm -f /root/ohp.sh

cat <<EOF> /etc/systemd/system/autosett.service
[Unit]
Description=autosetting
Documentation=https://none.xyz

[Service]
Type=oneshot
ExecStart=/bin/bash /etc/set.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable autosett
wget -O /etc/set.sh "https://raw.githubusercontent.com/SandakanVPNTrickster/Multiport/main/set.sh"
chmod +x /etc/set.sh
history -c
clear
echo " "
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "$green  Installation has been completed!!      $NC"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
sleep 2
echo " "
echo -e "\e[33m ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e " \E[0;100;33m        • AutoScript by @SquidVPN •            \E[0m"
echo -e "\e[33m ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
echo "   >>> Service & Port"  | tee -a log-install.txt
echo "   - OpenSSH                 : 22"  | tee -a log-install.txt
echo "   - OpenVPN                 : TCP 1194, UDP 2200"  | tee -a log-install.txt
echo "   - OpenVPN OHP             : 8087"  | tee -a log-install.txt
echo "   - Stunnel4                : 444, 777"  | tee -a log-install.txt
echo "   - Dropbear                : 109, 143"  | tee -a log-install.txt
echo "   - Squid Proxy             : 3128, 8000 (limit to IP Server)"  | tee -a log-install.txt
echo "   - Wireguard               : 7070"  | tee -a log-install.txt
echo "   - Shadowsocks-R           : 1443-1543"  | tee -a log-install.txt
echo "   - SS-OBFS TLS             : 2443-2543"  | tee -a log-install.txt
echo "   - SS-OBFS HTTP            : 3443-3543"  | tee -a log-install.txt
echo "   - XRAY VLESS XTLS SPLICE  : 443"  | tee -a log-install.txt
echo "   - XRAY VLESS XTLS DIRECT  : 443"  | tee -a log-install.txt
echo "   - XRAY VLESS WS TLS       : 443"  | tee -a log-install.txt
echo "   - XRAY TROJAN TLS         : 443"  | tee -a log-install.txt
echo "   - XRAY VMESS TLS          : 443"  | tee -a log-install.txt
echo "   - XRAY VMESS NONE TLS         : 80"  | tee -a log-install.txt
echo "   - XRAY VLESS WS NONE TLS     : 8080"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "   - V2RAY VLESS TLS SPLICE  : 80" | tee -a log-install.txt
echo "   - V2RAY VLESS TLS DIRECT  : 80" | tee -a log-install.txt
echo "   - V2RAY VLESS WS TLS      : 80" | tee -a log-install.txt
echo "   - V2RAY TROJAN TLS        : 80" | tee -a log-install.txt
echo "   - V2RAY VMESS TLS         : 80" | tee -a log-install.txt
echo "   - Trojan-GFW              : 2087" | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "   >>> Server Information & Other Features"  | tee -a log-install.txt
echo "   - Timezone                 : Asia/Kuala_Lumpur (GMT +8)"  | tee -a log-install.txt
echo "   - Fail2Ban                 : [ON]"  | tee -a log-install.txt
echo "   - DDOS Dflate              : [ON]"  | tee -a log-install.txt
echo "   - IPtables                 : [ON]"  | tee -a log-install.txt
echo "   - Auto-Reboot              : [OFF]" | tee -a log-install.txt
echo "   - IPv6                     : [OFF]" | tee -a log-install.txt
echo "   - Auto-Remove-Expired      : [ON]"  | tee -a log-install.txt
echo "   - Autobackup Data                "  | tee -a log-install.txt
echo "   - AutoKill Multi Login User       " | tee -a log-install.txt
echo "   - Auto Delete Expired Account     " | tee -a log-install.txt
echo "   - Fully automatic script          " | tee -a log-install.txt
echo "   - VPS settings                    " | tee -a log-install.txt
echo "   - Admin Control                   " | tee -a log-install.txt
echo "   - Change port                     " | tee -a log-install.txt
echo "   - Restore Data                    " | tee -a log-install.txt
echo "   - Full Orders For Various Services" | tee -a log-install.txt
echo ""
echo -e "\e[33m━━━━━━━━━[\e[0m \e[32mAutoscript Sayang Ibu Ayah\e[0m \e[33m]━━━━━━━━━━━\e[0m"
echo ""
secs_to_human "$(($(date +%s) - ${start}))" | tee -a log-install.txt
echo -e ""
sleep 3
echo -e ""
rm -f /root/setup.sh
rm -f /root/.bash_history
echo -ne "[ ${yell}WARNING${NC} ] Selesai install tekan y dan enter sahaja. (y/n)? "
read answer
if [ "$answer" == "${answer#[Yy]}" ] ;then
exit 0
else
reboot
fi
