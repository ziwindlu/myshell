#!/bin/bash

iLoveWork=1
shareVpn="192.168.48.53"
localShareVpn="192.168.66.250"
testNet="192.168.3.23"
sudo route del -net 192.168.3.0/24

# 指定使用shareVpn
if ! test -z $1 ;then
		echo "force use shareVpn"
		sudo route add -net 192.168.3.0/24 gw "$shareVpn"
		exit 0
fi


# 获取当前日期的星期几
weekday=$(date +%u)

# 判断是否为工作日（星期一至星期五）
if [ $iLoveWork -eq 1 ] || ([ $weekday -gt 0 ] && [ $weekday -lt 6 ]); then
		# 正常逻辑
		ping "$shareVpn" -c 5
		if [[ $? -eq 0 ]]; then
				echo "use shareVpn"
				sudo route add -net 192.168.3.0/24 gw "$shareVpn"
				# ping "$testNet" -c 5
				# if [[ $? -ne 0 ]]; then
				# 		sudo route del -net 192.168.3.0/24
				# 		sudo virsh start win7-vpn
				# 		sudo route add -net 192.168.3.0/24 gw "$localShareVpn"
				# fi
		else 
				echo "use localShareVpn"
				sudo virsh start win7-vpn
				sudo route add -net 192.168.3.0/24 gw "$localShareVpn"
		fi
		# sudo route add -net 192.168.3.0/24 gw 192.168.66.250
		echo "work harder"
else
		echo "enjoy weekday"
fi

