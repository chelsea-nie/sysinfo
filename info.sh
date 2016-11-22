#/bin/bash
echo "本机系统详细信息："

#安装查看raid的包
a=`rpm -qa |grep MegaCli|wc -l`
if [ $a -eq 0 ];then
yum install MegaCli -y
else 
	echo "MegaCli installed"
fi

#查看本机的sn
dmidecode -t 1|grep "Serial Number"
dmidecode | grep Product|head -1

#cpu 型号和个数
cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c|awk '{print "cpu个数: " $1 "  " ;$1=""; print "cpu型号:" $0;}'

#系统版本
cat /etc/issue

#查看内存条的个数
echo "内存个数,非0为真"
dmidecode|grep -P -A5 "Memory\s+Device"| grep Size | grep -v Range|grep -v "Size: No Module Installed"


#安装查看raid的包
#a=`rpm -qa |grep MegaCli|wc -l`
#if [ $a -eq 0 ];then
#yum install MegaCli -y
#else 
#	echo "MegaCli installed"
#fi
#查看硬盘个数
/opt/MegaRAID/MegaCli/MegaCli64  -PDList -aALL|grep -E "^Raw Size"

#查看raid级别
raid=`/opt/MegaRAID/MegaCli/MegaCli64 -LDInfo -Lall -aALL |grep "RAID Level"|awk  -F": " '{print $2}'`

case "$raid"
in
"Primary-1, Secondary-0, RAID Level Qualifier-0") echo "Raid Level :Raid 1";;
"Primary-0, Secondary-0, RAID Level Qualifier-0") echo "Raid Level :Raid 0";;
"Primary-5, Secondary-0, RAID Level Qualifier-3") echo "Raid Level :Raid 5";;
"Primary-1, Secondary-3, RAID Level Qualifier-0") echo "Raid Level :Raid 10";;
esac

#查看raid卡类型
/opt/MegaRAID/MegaCli/MegaCli64 -AdpAllInfo -aALL|grep "^Product Name"

#删除脚本
rm -rf info.sh

ip a|grep -A1 em1|grep -Ev "^em1|inet6"

