#！/bin/bash

set -e

PCINAME=$1
# 原始设备名
# PCINAME=$(nmcli con show | awk 'NR==2 {print $4}')

MODNAME=$2
# 要修改的设备名

MAC=$(cat /sys/class/net/${PCINAME}/address)

# MAC=$(ip a show ens32 | awk '/link\/ether/ {print $2}')

cat > /etc/udev/rules.d/10-network.rules << EOF
SUBSYSTEM=="net", ACTION=="add", ATTR{address}=="${MAC}", NAME="${MODNAME}"
EOF

udevadm trigger --verbose --subsystem-match=net --action=add

nmcli con modify ${PCINAME} connection.id ${MODNAME}
nmcli con reload
nmcli con up ${MODNAME}
nmcli con show

sed -i "s/NAME=${PCINAME}/NAME=${MODNAME}/" /etc/sysconfig/network-scripts/ifcfg-${PCINAME}
sed -i "s/DEVICE=${PCINAME}/DEVICE=${MODNAME}/" /etc/sysconfig/network-scripts/ifcfg-${PCINAME}
mv /etc/sysconfig/network-scripts/ifcfg-${PCINAME} /etc/sysconfig/network-scripts/ifcfg-${MODNAME}

# reboot