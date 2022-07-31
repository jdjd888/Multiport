#!/bin/bash
MYIP=$(wget -qO- ipinfo.io/ip);
clear
function add-user() {
    echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "\E[0;100;33m        • ADD XRAY USER •          \E[0m"
    echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo ""
	read -p "Username  : " user
	if grep -qw "$user" /etc/rare/xray/clients.txt; then
		echo -e ""
		echo -e "User \e[31m$user\e[0m already exist"
		echo -e ""
		echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
        echo ""
        read -n 1 -s -r -p "Press any key to back on menu"
        xray-menu
	fi
    read -p "SNI (BUG)     : " sni
read -p "Bug Address (Example: www.google.com) : " sub
	read -p "Duration (day) : " duration
	uuid=$(cat /proc/sys/kernel/random/uuid)
	exp=$(date -d +${duration}days +%Y-%m-%d)
	expired=$(date -d "${exp}" +"%d %b %Y")
	domain=$(cat /etc/rare/xray/domain)
	xtls="$(cat ~/log-install.txt | grep -w "XRAY VLESS XTLS SPLICE" | cut -d: -f2|sed 's/ //g')"
	nontls="$(cat ~/log-install.txt | grep -w "XRAY VMESS NON TLS no" | cut -d: -f2|sed 's/ //g')"
	none="$(cat ~/log-install.txt | grep -w "XRAY VLESS NON TLS" | cut -d: -f2|sed 's/ //g')"
	email=${user}@${domain}
    cat>/etc/rare/xray/tls.json<<EOF
      {
       "v": "2",
       "ps": "${user}",
       "add": "${sub}.${domain}",
       "port": "${xtls}",
       "id": "${uuid}",
       "aid": "0",
       "scy": "auto",
       "net": "ws",
       "type": "none",
       "host": "${sni}",
       "path": "/xrayvws",
       "tls": "tls",
       "sni": "${sni}"
}
EOF
cat>/etc/rare/xray/nontls.json<<EOF
      {
      "v": "2",
      "ps": "${user}",
      "add": "${sub}.${domain}",
      "port": "${nontls}",
      "id": "${uuid}",
      "aid": "0",
      "net": "ws",
      "path": "/xrayws",
      "type": "none",
      "host": "$sni",
      "tls": "none"
}
EOF
    vmess_base641=$( base64 -w 0 <<< $vmess_json1)
    vmess_base642=$( base64 -w 0 <<< $vmess_json2)
    vmesslink1="vmess://$(base64 -w 0 /etc/rare/xray/tls.json)"
    vmesslink2="vmess://$(base64 -w 0 /etc/rare/xray/nontls.json)"
	echo -e "${user}\t${uuid}\t${exp}" >> /etc/rare/xray/clients.txt
    cat /etc/rare/xray/conf/02_VLESS_TCP_inbounds.json | jq '.inbounds[0].settings.clients += [{"id": "'${uuid}'","add": "'${domain}'","flow": "xtls-rprx-direct","email": "'${email}'"}]' > /etc/rare/xray/conf/02_VLESS_TCP_inbounds_tmp.json
	mv -f /etc/rare/xray/conf/02_VLESS_TCP_inbounds_tmp.json /etc/rare/xray/conf/02_VLESS_TCP_inbounds.json
    cat /etc/rare/xray/conf/03_VLESS_WS_inbounds.json | jq '.inbounds[0].settings.clients += [{"id": "'${uuid}'","email": "'${email}'"}]' > /etc/rare/xray/conf/03_VLESS_WS_inbounds_tmp.json
	mv -f /etc/rare/xray/conf/03_VLESS_WS_inbounds_tmp.json /etc/rare/xray/conf/03_VLESS_WS_inbounds.json
    cat /etc/rare/xray/conf/04_trojan_TCP_inbounds.json | jq '.inbounds[0].settings.clients += [{"password": "'${uuid}'","email": "'${email}'"}]' > /etc/rare/xray/conf/04_trojan_TCP_inbounds_tmp.json
	mv -f /etc/rare/xray/conf/04_trojan_TCP_inbounds_tmp.json /etc/rare/xray/conf/04_trojan_TCP_inbounds.json
    cat /etc/rare/xray/conf/05_VMess_WS_inbounds.json | jq '.inbounds[0].settings.clients += [{"id": "'${uuid}'","alterId": 0,"add": "'${domain}'","email": "'${email}'"}]' > /etc/rare/xray/conf/05_VMess_WS_inbounds_tmp.json
	mv -f /etc/rare/xray/conf/05_VMess_WS_inbounds_tmp.json /etc/rare/xray/conf/05_VMess_WS_inbounds.json
	cat /etc/rare/xray/conf/06_VLESS_gRPC_inbounds.json | jq '.inbounds[0].settings.clients += [{"id": "'${uuid}'","email": "'${email}'"}] > /etc/rare/xray/conf/06_VLESS_gRPC_inbounds_temp.json
	mv -f /etc/rare/xray/conf/06_VLESS_gRPC_inbounds_temp.json /etc/rare/xray/conf/06_VLESS_gRPC_inbounds.json
	cat /etc/rare/xray/conf/vmess-nontls.json | jq '.settings.clients += [{"id": "'${uuid}'","alterId": 0,"add": "'${domain}'","email": "'${email}'"}]' > /etc/rare/xray/conf/vmess-nontls_tmp.json
	mv -f /etc/rare/xray/conf/vmess-nontls_tmp.json /etc/rare/xray/conf/vmess-nontls.json
	cat /etc/rare/xray/conf/vless-nontls.json | jq '.settings.clients += [{"id": "'${uuid}'","email": "'${email}'"}]' > /etc/rare/xray/conf/vless-nontls_tmp.json
	mv -f /etc/rare/xray/conf/vless-nontls_tmp.json /etc/rare/xray/conf/vless-nontls.json
    cat <<EOF >>"/etc/rare/config-user/${user}"
direct="vless://$uuid@$sub.$domain:$xtls?flow=xtls-rprx-direct&encryption=none&security=xtls&sni=$sni&type=tcp&headerType=none&host=$sni#${user}"
splice="vless://$uuid@$sub.$domain:$xtls?flow=xtls-rprx-splice&encryption=none&security=xtls&sni=$sni&type=tcp&headerType=none&host=$sni#${user}"
vlessws="vless://$uuid@$sub.$domain:$xtls?encryption=none&security=xtls&sni=$sni&type=ws&host=$sni&path=/xrayws#${user}"
trgrpc="trojan://$uuid@$sub.$domain:$xtls?sni=$sni#$user"
vlessgrpc="vless://${uuid}@$sub.$domain:${vl}?mode=gun&security=tls&encryption=none&type=grpc&serviceName=GunService&sni=${sni}#${user}"
vlessxws="vless://${uuid}@$sub.$domain:$none?path=/xvless&encryption=none&type=ws&sni=${sni}#${user}"
${vmesslink1}
${vmesslink2}

EOF
    cat <<EOF >>"/etc/rare/config-url/${user}"
  nameserver:
    - 119.29.29.29
    - 223.5.5.5
    - 180.76.76.76
  fallback:
    - https://doh.dns.sb/dns-query
    - tcp://208.67.222.222:443
    - tls://dns.google
  fallback-filter:
    geoip: true
    ipcidr:
      - 240.0.0.0/4
tproxy: true
tproxy-port: 23458
EOF
	base64Result=$(base64 -w 0 /etc/rare/config-user/${user})
    echo ${base64Result} >"/etc/rare/config-url/${uuid}"
    systemctl restart xray.service
    echo -e "\033[32m[Info]\033[0m xray Start Successfully !"
    sleep 2
    clear
	echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m" | tee -a /etc/log-create-user.log
    echo -e "\E[0;100;33m    • XRAY USER INFORMATION •      \E[0m" | tee -a /etc/log-create-user.log
    echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"   | tee -a /etc/log-create-user.log
	echo -e "" | tee -a /etc/log-create-user.log
	echo -e " Username      : $user" | tee -a /etc/log-create-user.log
	echo -e " Expired date  : $expired" | tee -a /etc/log-create-user.log
    echo -e " Jumlah Hari   : $duration Hari" | tee -a /etc/log-create-user.log
    echo -e " PORT          : $xtls" | tee -a /etc/log-create-user.log
    echo -e " PORT          : $nontls" | tee -a /etc/log-create-user.log
    echo -e " PORT          : $none" | tee -a /etc/log-create-user.log
    echo -e " UUID/PASSWORD : $uuid" | tee -a /etc/log-create-user.log
	echo -e "" | tee -a /etc/log-create-user.log
	echo -e " Ip Vps        : $MYIP" | tee -a /etc/log-create-user.log
    echo -e " Domain        : $domain" | tee -a /etc/log-create-user.log
	echo -e " Bug Domain    : $sub" | tee -a /etc/log-create-user.log
	echo -e " Bug SNI       : $sni" | tee -a /etc/log-create-user.log
    echo -e "" | tee -a /etc/log-create-user.log
    echo -e " LINK VLESS DIRECT :  ${direct}" | tee -a /etc/log-create-user.log
    echo -e " LINK VLESS SPLICE :  ${splice}" | tee -a /etc/log-create-user.log
    echo -e " LINK VLESS GRPC :  ${vlessgrpc}" | tee -a /etc/log-create-user.log
    echo -e "" | tee -a /etc/log-create-user.log
	echo -e " LINK VLESS WS: ${vlessws}" | tee -a /etc/log-create-user.log
    echo -e "" | tee -a /etc/log-create-user.log
    echo -e " Link VMESS TLS: ${vmesslink1}" | tee -a /etc/log-create-user.log
	echo -e " LINK TROJAN: ${trgrpc}" | tee -a /etc/log-create-user.log
    echo -e "" | tee -a /etc/log-create-user.log
    echo -e " Link VMESS NONE TLS: ${vmesslink2}" | tee -a /etc/log-create-user.log
    echo -e " LINK VLESS NONE TLS: ${vlessxws}" | tee -a /etc/log-create-user.log
	echo -e "" | tee -a /etc/log-create-user.log
	echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo "" | tee -a /etc/log-create-user.log
    read -n 1 -s -r -p "Press any key to back on menu"
    xray-menu   
}

function delete-user() {
	clear
	echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "\E[0;100;33m       • DELETE XRAY USER •        \E[0m"
    echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e ""  
	read -p "Username : " user
	echo -e ""
	if ! grep -qw "$user" /etc/rare/xray/clients.txt; then
		echo -e ""
        echo -e "User \e[31m$user\e[0m does not exist"
        echo ""
        echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
        echo ""
        read -n 1 -s -r -p "Press any key to back on menu"
        xray-menu   
	fi
    rm /etc/rare/config-url/${user}
	uuid="$(cat /etc/rare/xray/clients.txt | grep -w "$user" | awk '{print $2}')"
	        cat /etc/rare/xray/conf/02_VLESS_TCP_inbounds.json | jq 'del(.inbounds[0].settings.clients[] | select(.id == "'${uuid}'"))' > /etc/rare/xray/conf/02_VLESS_TCP_inbounds_tmp.json
		mv -f /etc/rare/xray/conf/02_VLESS_TCP_inbounds_tmp.json /etc/rare/xray/conf/02_VLESS_TCP_inbounds.json
		
		cat /etc/rare/xray/conf/03_VLESS_WS_inbounds.json | jq 'del(.inbounds[0].settings.clients[] | select(.id == "'${uuid}'"))' > /etc/rare/xray/conf/03_VLESS_WS_inbounds_tmp.json
		mv -f /etc/rare/xray/conf/03_VLESS_WS_inbounds_tmp.json /etc/rare/xray/conf/03_VLESS_WS_inbounds.json
		
		cat /etc/rare/xray/conf/04_trojan_TCP_inbounds.json | jq 'del(.inbounds[0].settings.clients[] | select(.password == "'${uuid}'"))' > /etc/rare/xray/conf/04_trojan_TCP_inbounds_tmp.json
		mv -f /etc/rare/xray/conf/04_trojan_TCP_inbounds_tmp.json /etc/rare/xray/conf/04_trojan_TCP_inbounds.json
		
		cat /etc/rare/xray/conf/05_VMess_WS_inbounds.json | jq 'del(.inbounds[0].settings.clients[] | select(.id == "'${uuid}'"))' > /etc/rare/xray/conf/05_VMess_WS_inbounds_tmp.json
		mv -f /etc/rare/xray/conf/05_VMess_WS_inbounds_tmp.json /etc/rare/xray/conf/05_VMess_WS_inbounds.json
		
		cat /etc/rare/xray/conf/06_VLESS_gRPC_inbounds.json | jq 'del(.inbounds[0].settings.clients[] | select(.id == "'${uuid}'"))' > /etc/rare/xray/conf/06_VLESS_gRPC_inbounds_temp.json
		mv -f /etc/rare/xray/conf/06_VLESS_gRPC_inbounds_temp.json /etc/rare/xray/conf/06_VLESS_gRPC_inbounds.json
		
		cat /etc/rare/xray/conf/vmess-nontls.json | jq 'del(settings.clients[] | select(.id == "'${uuid}'"))' > /etc/rare/xray/conf/vmess-nontls_tmp.json
	        mv -f /etc/rare/xray/conf/vmess-nontls_tmp.json /etc/rare/xray/conf/vmess-nontls.json
	
	        cat /etc/rare/xray/conf/vless-nontls.json | jq 'del(settings.clients[] | select(.id == "'${uuid}'"))' > /etc/rare/xray/conf/vless-nontls_tmp.json
	         mv -f /etc/rare/xray/conf/vless-nontls_tmp.json /etc/rare/xray/conf/vless-nontls.json
	
    sed -i "/\b$user\b/d" /etc/rare/xray/clients.txt
    rm /etc/rare/config-user/${user}
    rm /etc/rare/config-url/${uuid}
	systemctl restart xray.service
    echo -e "\033[32m[Info]\033[0m xray Start Successfully !"
    echo ""
	echo -e "User \e[32m$user\e[0m deleted Successfully !"
	echo ""
    echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo ""
    read -n 1 -s -r -p "Press any key to back on menu"
    xray-menu 
}

function extend-user() {
	clear
	echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "\E[0;100;33m       • EXTEND XRAY USER •        \E[0m"
    echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo ""
	read -p "Username : " user
	if ! grep -qw "$user" /etc/rare/xray/clients.txt; then
		echo -e ""
		echo -e "User \e[31m$user\e[0m does not exist"
        echo ""
        echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
        echo ""
        read -n 1 -s -r -p "Press any key to back on menu"
        xray-menu 
	fi
	read -p "Duration (day) : " extend
	uuid=$(cat /etc/rare/xray/clients.txt | grep -w $user | awk '{print $2}')
	exp_old=$(cat /etc/rare/xray/clients.txt | grep -w $user | awk '{print $3}')
	diff=$((($(date -d "${exp_old}" +%s)-$(date +%s))/(86400)))
	duration=$(expr $diff + $extend + 1)
	exp_new=$(date -d +${duration}days +%Y-%m-%d)
	exp=$(date -d "${exp_new}" +"%d %b %Y")
	sed -i "/\b$user\b/d" /etc/rare/xray/clients.txt
	echo -e "$user\t$uuid\t$exp_new" >> /etc/rare/xray/clients.txt
	clear
	echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "\E[0;100;33m    • XRAY USER INFORMATION •      \E[0m"
    echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo ""
	echo -e "Username     : $user"
	echo -e "Expired date : $exp"
	echo -e ""
    echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo ""
    read -n 1 -s -r -p "Press any key to back on menu"
    xray-menu     
}

function user-list() {
	clear
	echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "\E[0;100;33m        • XRAY USER LIST •         \E[0m"
    echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo ""
    echo -e  "\e[36mUsername               Exp. Date\e[0m"
    echo ""   
	while read expired
	do
		user=$(echo $expired | awk '{print $1}')
		exp=$(echo $expired | awk '{print $3}')
		exp_date=$(date -d"${exp}" "+%d %b %Y")
		printf "%-17s %2s\n" "$user" "     $exp_date"
	done < /etc/rare/xray/clients.txt
	total=$(wc -l /etc/rare/xray/clients.txt | awk '{print $1}')
    echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "Total accounts: $total"
    echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
	echo -e ""
    read -n 1 -s -r -p "Press any key to back on menu"
    xray-menu
}

function user-monitor() {
    clear
	echo -n > /tmp/other.txt
	data=($(cat /etc/rare/xray/clients.txt | awk '{print $1}'));
	echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "\E[0;100;33m      • XRAY USER MONITOR •        \E[0m"
    echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo ""
	for akun in "${data[@]}"
	do
	if [[ -z "$akun" ]]; then
	akun="tidakada"
	fi
	echo -n > /tmp/ipvmess.txt
	data2=( `netstat -anp | grep ESTABLISHED | grep tcp6 | grep xray | awk '{print $5}' | cut -d: -f1 | sort | uniq`);
	for ip in "${data2[@]}"
	do
	jum=$(cat /var/log/xray/access.log | grep -w $akun | awk '{print $3}' | cut -d: -f1 | grep -w $ip | sort | uniq)
    if [[ "$jum" = "$ip" ]]; then
	echo "$jum" >> /tmp/ipvmess.txt
	else
	echo "$ip" >> /tmp/other.txt
	fi
	jum2=$(cat /tmp/ipvmess.txt)
	sed -i "/$jum2/d" /tmp/other.txt > /dev/null 2>&1
	done
	jum=$(cat /tmp/ipvmess.txt)
	if [[ -z "$jum" ]]; then
	echo > /dev/null
	else
	jum2=$(cat /tmp/ipvmess.txt | nl)
	echo "user : $akun";
	echo "$jum2";
    echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
	fi
	rm -rf /tmp/ipvmess.txt
	done
	oth=$(cat /tmp/other.txt | sort | uniq | nl)
	echo "other";
	echo "$oth";
	echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
	rm -rf /tmp/other.txt
	echo -e ""
    read -n 1 -s -r -p "Press any key to back on menu"
    xray-menu      
}

function show-config() {
	echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "\E[0;100;33m       • XRAY USER CONFIG •        \E[0m"
    echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e ""
	read -p "User : " user
	if ! grep -qw "$user" /etc/rare/xray/clients.txt; then
		echo -e ""
		echo -e "User \e[31m$user\e[0m does not exist"
		echo -e ""
        read -n 1 -s -r -p "Press any key to back on menu"
        xray-menu
	fi
    xtls="$(cat ~/log-install.txt | grep -w "XRAY VLESS XTLS SPLICE" | cut -d: -f2|sed 's/ //g')"
	nontls="$(cat ~/log-install.txt | grep -w "XRAY VMESS NON TLS no" | cut -d: -f2|sed 's/ //g')"
	none="$(cat ~/log-install.txt | grep -w "XRAY VLESS NON TLS" | cut -d: -f2|sed 's/ //g')"
    link=$(cat /etc/rare/config-user/${user})
	uuid=$(cat /etc/rare/xray/clients.txt | grep -w "$user" | awk '{print $2}')
	domain=$(cat /etc/rare/xray/domain)
	exp=$(cat /etc/rare/xray/clients.txt | grep -w "$user" | awk '{print $3}')
	exp_date=$(date -d"${exp}" "+%d %b %Y")

	clear
	echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "\E[0;100;33m    • XRAY USER INFORMATION •      \E[0m"
    echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"      
	echo -e ""
	echo -e " Username      : $user"
	echo -e " Expired date  : $exp_date"
	echo -e " Ip Vps        : $MYIP"
    echo -e " Domain        : $domain"
    echo -e " PORT          : $xtls"
    echo -e " PORT          : $nontls"
    echo -e " PORT          : $none"
    echo -e " UUID/PASSWORD : $uuid"
	echo -e ""
    echo -e " Config :"
	echo -e " $link"  
	echo -e ""
	echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo ""
    read -n 1 -s -r -p "Press any key to back on menu"
    xray-menu    
}

function change-port() {
	clear
    xtls="$(cat ~/log-install.txt | grep -w "XRAY VLESS XTLS SPLICE" | cut -d: -f2|sed 's/ //g')"
	echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e "\E[0;100;33m       • CHANGE PORT XRAY •        \E[0m"
    echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo -e ""
	echo -e "Change Port XRAY TCP XTLS: $xtls"
	echo -e ""
	read -p "New Port XRAY TCP XTLS: " xtls1
	if [ -z $xtls1 ]; then
	echo "Please Input Port"
	echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo ""
    read -n 1 -s -r -p "Press any key to back on menu"
    change-port  	
	fi
	cek=$(netstat -nutlp | grep -w $xtls1)
    if [[ -z $cek ]]; then
    sed -i "s/$xtls/$xtls1/g" /etc/rare/xray/conf/02_VLESS_TCP_inbounds.json
    sed -i "s/   - XRAY VLESS XTLS SPLICE  : $xtls/   - XRAY VLESS XTLS SPLICE : $xtls1/g" /root/log-install.txt
    sed -i "s/   - XRAY VLESS XTLS DIRECT  : $xtls/   - XRAY VLESS XTLS DIRECT  : $xtls1/g" /root/log-install.txt
    sed -i "s/   - XRAY VLESS WS TLS       : $xtls/   - XRAY VLESS WS TLS       : $xtls1/g" /root/log-install.txt
	sed -i "s/   - XRAY TROJAN TLS         : $xtls/   - XRAY TROJAN TLS         : $xtls1/g" /root/log-install.txt
    sed -i "s/   - XRAY VMESS TLS          : $xtls/   - XRAY VMESS TLS          : $xtls1/g" /root/log-install.txt
    
    iptables -D INPUT -m state --state NEW -m tcp -p tcp --dport $xtls -j ACCEPT
    iptables -D INPUT -m state --state NEW -m udp -p udp --dport $xtls -j ACCEPT
    iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport $xtls1 -j ACCEPT
    iptables -I INPUT -m state --state NEW -m udp -p udp --dport $xtls1 -j ACCEPT
    iptables-save > /etc/iptables.up.rules
    iptables-restore -t < /etc/iptables.up.rules
    netfilter-persistent save > /dev/null
    netfilter-persistent reload > /dev/null
    systemctl restart xray > /dev/null
    echo -e "\033[32m[Info]\033[0m xray Start Successfully !"
    echo ""
    echo -e "\e[032;1mPort $xtls1 modified Successfully !\e[0m"
	echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo ""
    read -n 1 -s -r -p "Press any key to back on menu"
    xray-menu    
    else
    echo "Port $xtls1 is used"
	echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo ""
    read -n 1 -s -r -p "Press any key to back on menu"
    change-port      
    fi
}

clear
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[0;100;33m       • XRAY CORE MENU •          \E[0m"
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""   
echo -e " [\e[36m•1\e[0m] Add XRAY user "
echo -e " [\e[36m•2\e[0m] Delete XRAY user "
echo -e " [\e[36m•3\e[0m] Extend XRAY user "
echo -e " [\e[36m•4\e[0m] View user list "
echo -e " [\e[36m•5\e[0m] Monitor user "
echo -e " [\e[36m•6\e[0m] Show User config "
echo -e " [\e[36m•7\e[0m] Change Port XRAY "
echo -e ""
echo -e " [\e[31m•0\e[0m] \e[31mBACK TO MENU\033[0m"
echo -e   ""
echo -e   "Press x or [ Ctrl+C ] • To-Exit"
echo -e ""
echo -e "\e[33m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
read -p " Select menu : " opt
echo -e ""
case $opt in
1) clear ; add-user ;;
2) clear ; delete-user ;;
3) clear ; extend-user ;;
4) clear ; user-list ;;
5) clear ; user-monitor ;;
6) clear ; show-config ;;
7) clear ; change-port ;;
0) clear ; menu ;;
x) exit ;;
*) echo -e "" ; echo "Terimlah Kasih" ; sleep 1 ; xray-menu ;;
esac
