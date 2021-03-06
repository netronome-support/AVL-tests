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
ETH=$(ls /sys/bus/pci/devices/$PCI/virtfn0/net | sed -n 1p)
PHY=$(ls /sys/bus/pci/devices/$PCI/net | sed -n 1p)
#Assign IP to netdev and up the interface
ip a add $INTERFACE_NFP/24 dev $ETH
sleep 1
ip link set $ETH up
sleep 1
ip link set $PHY up

sleep 1
#Change MTU's
ifconfig $PHY mtu 9000
sleep 1
ifconfig $ETH mtu 9000

sleep 3

/opt/netronome/bin/set_irq_affinity.sh $PHY

sleep 3

echo "DONE($(basename $0))"
exit 0
