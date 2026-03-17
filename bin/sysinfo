#!/usr/bin/env bash
# Shell Scirpt to print System Info
# author: emanuel.regnath@tum.de
# first print most important infos, then offer menu to choose specific diagnostic commands



# https://lzone.de/cheat-sheet/Linux-Networking



# Prompt Colors
#white='\033[0;37m';  WHITE='\033[1;37m'
white='\033[0m';  WHITE='\033[1;37m'
blue='\033[0;34m';   BLUE='\033[1;34m'
green='\033[0;32m';  GREEN='\033[1;32m'
cyan='\033[0;36m';   CYAN='\033[1;36m'
red='\033[0;31m';    RED='\033[1;31m'
purple='\033[0;35m'; PURPLE='\033[1;35m'
yellow='\033[0;33m'; YELLOW='\033[1;33m'
gray='\033[0;30m';   GRAY='\033[1;30m'
nocol='\033[0m';




# extracts the next word after paramter separated by space, : =
parse_key(){
	#sed -nr "s/^.*${1}\s*[ :=]\s*(\S+).*$/\1/p;q" # for some reason q (quit) also if no match
	sed -nr "s/^.*${1}\s*[ :=]\s*(\S+).*$/\1/p" | head -1
	#grep -m 1 -oP "${1}\s*[ :=]\s*\K(\S+)"
	#awk pattern="/$1\s*[ :=]\s*/" '{ print $2;exit }'
}


parse_keyline(){
	sed -nr "s/^.*${1}\s*[ :=]\s*(.*$)/\1/p" | head -1
}



# selects availables command
sel_cmd(){
	if command -v ${1%% *} >/dev/null; then 
		echo "$1"
	elif command -v ${2%% *} >/dev/null; then
		echo "$2"
	elif command -v ${3%% *} >/dev/null; then
		echo "$3"
	fi
}


run_cmd(){
	#echo "-----------------------------"
	clear
	echo "> $1"
	eval $1
	echo -n "[Any Key] to continue..."; read subchoice </dev/tty
	clear
}


# ========================================================

main_menu(){
	mainchoice=1
	while [ $mainchoice != 'q' ]; do
		echo -e "\n${WHITE}   Main${white}"
		echo "   1.  General System"
		echo "   2.  Hardware (CPU, USB, ...)"
		echo "   3.  Network"
		echo "   4.  Filesystems"
		echo "   *   Quit"
		echo ""

		echo -n "Your Choice: "; read mainchoice </dev/tty
		case $mainchoice in
			1 ) clear; print_sysinfo; submenu_system;;
			2 ) clear; print_cpuinfo; submenu_hardware;;
			3 ) clear; print_netinfo; submenu_net;;
			4 ) clear; print_meminfo;;
			* ) exit 0;;
		esac
	done
}



submenu_system(){
	cmd_pack=$(sel_cmd "dpkg -l | wc -l" )
	cmd_logins=$(sel_cmd "lslogins" "who -a")
	cmd_kernel=$(sel_cmd "hostnamectl" "uname -a")
	cmd_proc=$(sel_cmd "pstree" "ps -aux")

	while true; do
		echo -e "\n${WHITE}   Main => System:${white}"
		echo "   1> ${cmd_logins}      (Users and Logins)"
		echo "   2> ${cmd_kernel}   (Kernel and OS)"
		echo "   3> ${cmd_proc}        (Processes)"
		echo "   * back"

		echo -n "Your Choice: "; read subchoice </dev/tty
		case $subchoice in
			1 ) run_cmd ${cmd_logins};; 
			2 ) run_cmd ${cmd_kernel};;
			3 ) run_cmd ${cmd_proc};;
			* ) break;;
		esac
	done
}



submenu_hardware(){
	cmd_hw="lspci"
	cmd_cpu=$(sel_cmd "lscpu" "cat /proc/cpuinfo")
	cmd_pci="lspci"
	cmd_usb="lsusb"


	while true; do
		echo -e "\n${WHITE}   Main => Hardware:${white}"
		echo "   1> ${cmd_hw}   (Harware)"
		echo "   2> ${cmd_pci}   (PCI)"
		echo "   3> ${cmd_usb}   (USB)"
		echo "   4> ${cmd_cpu}   (CPU Info)"
		echo "   * back"

		echo -n "Your Choice: "; read subchoice </dev/tty
		case $subchoice in
			1 ) run_cmd ${cmd_hw};;
			2 ) run_cmd ${cmd_pci};;
			3 ) run_cmd ${cmd_usb};;
			4 ) run_cmd ${cmd_cpu};; 
			* ) break;;
		esac
	done
}



submenu_net(){

	cmd_routes=$(sel_cmd "ip route | column -t" "route")
	cmd_iface=$(sel_cmd "nmcli device" "ip address" "ifconfig") 
	cmd_dns="cat /etc/resolv.conf"
	cmd_arp="arp -n"
	cmd_nm_config="cat /etc/NetworkManager/NetworkManager.conf"
	cmd_if_config="cat /etc/network/interfaces"
	cmd_ports=$(sel_cmd "sudo ss -tunlp" "sudo netstat -tnlp")


	subchoice=1
	while true; do
		echo -e "\n${WHITE}  Main => Network:${white}"
		printf '  %-40s %-20s\n' "1> ${cmd_iface}" "(Show interfaces)"
		printf '  %-40s %-20s\n' "2> ${cmd_routes}" "(Show routes)"
		printf '  %-40s %-20s\n' "3> ${cmd_dns}" "(Show DNS)"
		printf '  %-40s %-20s\n' "4> ${cmd_arp}" "(Show MACs)"
		printf '  %-40s %-20s\n' "5> ${cmd_nm_config}" "(NM Config)"
		printf '  %-40s %-20s\n' "5> ${cmd_if_config}" "(interfaces)"
		printf '  %-40s %-20s\n' "5> ${cmd_ports}" "(show ports)"
		echo "  * back"

		echo -n "Your Choice: "; read subchoice </dev/tty
		case $subchoice in
			1 ) run_cmd "$cmd_iface";; 
			2 ) run_cmd "$cmd_routes";; 
			3 ) run_cmd "$cmd_dns";; 
			4 ) run_cmd "$cmd_arp";; 
			5 ) run_cmd "$cmd_nm_config";; 
			6 ) run_cmd "$cmd_if_config";; 
			7 ) run_cmd "$cmd_ports";; 
			* ) break;;
		esac
	done

}



# ========================================================



# Gather CPU Info
CPU_CORES="$(cat /proc/cpuinfo | grep processor | wc -l)"
CPU_NAME=$(cat /proc/cpuinfo | grep -m 1 -oP 'model name\s+: \K(.*)')        # lscpu
CPU_ARCH=$(cat /proc/cpuinfo | grep -m 1 -oP 'model name\s+: \K(.*)')
# get CPU word width
case $(uname -m) in
	x86_64)CPU_BITS=64;;
	i*86) CPU_BITS=32;;
	*) CPU_BITS="?";;
esac


NET_GATEWAY="$(/sbin/ip route | awk '/default/ { print $3;exit }')"
NET_IFACE="$(/sbin/ip route | awk '/default/ { print $5;exit }')"
NET_IP_LAN="$(/sbin/ip -o route get to 8.8.8.8 | sed -n 's/.*src \([0-9.]\+\).*/\1/p')"


print_summary(){
	echo "Kernel: $(/bin/uname -sr)"
	echo "Distro: $(echo_release)"
	echo ""
	echo "Arch.:  $(/bin/uname -m) (${CPU_BITS} bit)"
	echo "CPU:    $(cat /proc/cpuinfo | grep -m 1 -oP 'model name\s+: \K(.*)')"
	echo "GPU:    $(lspci | grep -m 1 -oP 'VGA compatible controller: \K(.*)')"
	echo "MEM:    $(( $(sed -n "s/MemTotal:[\t ]\+\([0-9]\+\) kB/\1/p" /proc/meminfo)/1000000)) GB RAM, $(df -H --output=size / 2> /dev/null | awk ' NR==2 ')B /,  $(df -H --output=size /home 2> /dev/null | awk ' NR==2 ')B /home"
	echo ""
	echo "Login:  ${USER} @ $(hostname)"
	echo "LAN IP: ${NET_IP_LAN} via GW ${NET_GATEWAY} at ${NET_IFACE}"
	#echo "WAN IP: $(wget -qO- ipinfo.io/ip)"
	#echo "USB:    $(lsusb | grep Device -c)"  # lsusb -v | grep "bcdUSB"
}



print_sysinfo(){
	echo ""
	echo -e "${WHITE}## System ##\n===================${white}"
	echo "Kernel:  $(/bin/uname -sr)"
	echo "Distro:  $(echo_release)"
	echo "Arch.:   $(/bin/uname -m) (${CPU_BITS} bit)"
	#echo "Boot CL: $(dmesg | parse_keyline 'Command line')"
	echo "Kopt:    $(dmesg | parse_keyline 'kopt')"
	echo "SecBoot: $(dmesg | parse_keyline 'secureboot')"
}



print_cpuinfo(){
	echo ""
	echo -e "${WHITE}## CPU ##${white}"
	echo "Model: ${CPU_NAME}"
	echo "Arch.: $(/bin/uname -m) (${CPU_BITS} bit)"
	echo "Cores: ${CPU_CORES}"
}


print_netinfo(){
	echo ""
	echo -e "${WHITE}## Network ##${white}"
	echo "Host:   $(hostname)"
	echo "LAN IP: $(ip -o route get to 8.8.8.8 | sed -n 's/.*src \([0-9.]\+\).*/\1/p')"
	echo "WAN IP: $(wget -qO- ipinfo.io/ip)"
	echo "DNS:    $(cat /etc/resolv.conf | parse_key nameserver)"


echo -e "${WHITE}"
printf '%-16s %-20s %-20s %-6s\n' "Interface" "IPv4" "MAC" "STATE"
echo -en "${white}"
#echo "$(ip addr | grep 'state UP' | sed -nr 's/^[0-9]: (.*):.*$/\1/p')"

for iface in $(ip addr | sed -nr 's/^[0-9]: (.*):.*$/\1/p' | tr '\n' ' ')
do 
  ipaddr=$(ip -o -4 addr list $iface | parse_key inet)
  macaddr=$(ip -o link list $iface | parse_key ether)
  istate=$(ip addr list $iface | parse_key state)
  printf '%-16s %-20s %-20s %-6s\n' "$iface" "$ipaddr" "$macaddr" "$istate"
done	

	# DNS commands: nslookup, dig, host
}



print_meminfo(){
	echo ""
	echo -e "${WHITE}## Memory ##${white}"
	#echo "RAM: $(lsmem | parse_key 'Total online memory')"
	echo "RAM:   $(( $(sed -n "s/MemTotal:[\t ]\+\([0-9]\+\) kB/\1/p" /proc/meminfo)/1000000)) GB ($(( $(sed -n "s/MemFree:[\t ]\+\([0-9]\+\) kB/\1/p" /proc/meminfo)/1000000)) GB free)"
	echo "Mount: $(df -H --output=size / 2> /dev/null | awk ' NR==2 ') /,  $(df -H --output=size /home 2> /dev/null | awk ' NR==2 ') /home"

	#echo "commands: free, top, vmstat, cat /proc/meminfo" 

	echo -e "\n${WHITE}Filesystems${white}"
	echo "$(lsblk -o NAME,TYPE,FSTYPE,SIZE,MOUNTPOINT,ROTA -e 1,7)"




# for disk in $(ls /sys/class/block | grep sd)
# do 	
# 	echo "$(cat /sys/class/block/${disk}/queue/rotational > /dev/null && echo 'SSD' || echo 'HDD')"
# done
	# dmidecode -t memory
	# sudo lshw -c memory
	# df -H

	# lsblk -o NAME,MOUNTPOINT,FSTYPE,ROTA -e 1,7

	# lsblk -l -o NAME,MOUNTPOINT,FSTYPE,SIZE,ROTA -e 1,7

}




echo_release(){
	if [ -f /etc/os-release ]; then # freedesktop.org and systemd
	    source /etc/os-release
		echo -n "${NAME} ${VERSION}"
	elif type lsb_release >/dev/null 2>&1; then # linuxbase.org
	    echo -n "$(lsb_release -sd)"
	elif [ -f /etc/lsb-release ]; then # some Debian/Ubuntu
	    . /etc/lsb-release
	    echo -n "${DISTRIB_DESCRIPTION}"
	else #fall back
	    echo -n "$(uname -sr)"
	fi
}



installed_packages(){
	echo apt --installed | wc -l
	echo yum list installed  | wc -l
}




# ======================================================

# run sysinfo
case "$1" in
	"sys") print_sysinfo;;
	"cpu") print_cpuinfo;;
	"net") print_netinfo;;
	"mem") print_meminfo;;
	*) print_summary; main_menu;;
esac






