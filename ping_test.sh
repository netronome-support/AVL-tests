#!/bin/bash

INTERFACE_NFP=$1

PCI=$(lspci -d 19ee: | awk '{print $1}' | head -1)

if [[ "$PCI" == *":"*":"*"."* ]]; then 
  echo "PCI correct format"
elif [[ "$PCI" == *":"*"."* ]]; then
  echo "PCI incorrect format"
  PCI="0000:$PCI"
fi
echo $PCI

echo 2 > /sys/bus/pci/devices/$PCI/sriov_numvfs

sleep 1


#Get netdev name
ETH=$(ls /sys/bus/pci/devices/$PCI/virtfn0/net)
PHY=$(ls /sys/bus/pci/devices/$PCI/net)
#Assign IP to netdev and up the interface
ip a add $INTERFACE_NFP/24 dev $ETH
ip link set dev $ETH up
ip link set $PHY up

#Change MTU's
ifconfig $PHY mtu 9000
ifconfig $ETH mtu 9000

echo "DONE($(basename $0))"
exit 0
