#!/bin/bash
MYIP=$(wget -qO- ipinfo.io/ip);
clear
echo -e "\e[33m ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "                   • SCRIPT MENU •                 "
echo -e "\e[33m ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "    [1]\e[0m•SSH OVPN\e[0m" "      [7]\e[0m•SYSTEM MENU\e[0m"
echo -e "    [2]\e[0m•WIREGUARD\e[0m" "     [8]\e[0m•SERVER STATUS\e[0m"
echo -e "    [3]\e[0m•SHADOWSOCKS\e[0m" "   [9]\e[0m•VPS INFO\e[0m"
echo -e "    [4]\e[0m•XRAY CORE\e[0m" "     [10]\e[0m•REBOOT\e[0m"
echo -e "    [5]\e[0m•TROJAN GFW\e[0m" "    [11]\e[0m•[12]\e[0m•DNS GEOLOCATION SETUP\e[0m\e[0m"
echo -e "    [6]\e[0m•LOG CONFIG USER\e[0m"
echo -e   ""
echo -e   " Press x or [ Ctrl+C ] • To-Exit-Script"
echo -e   ""
read -p " Select menu :  "  opt
echo -e   ""
case $opt in
1) clear ; m-sshovpn ;;
2) clear ; m-wg ;;
3) clear ; m-ss ;;
4) clear ; xray-menu ;;
5) clear ; m-trojan ;;
6) clear ;cat /etc/log-create-user.log
       read -n 1 -s -r -p "Press any key to back on menu"
       menu ;;
7) clear ; m-system ;;
8) clear ; status ;;
9) clear ; vpsinfo ;;
10) clear ; reboot ;;
11) clear ; net ;;


x) exit ;;
esac
