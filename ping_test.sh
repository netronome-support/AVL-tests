#!/bin/bash
PCI=$(lspci -d 19ee: | awk '{print $1}' | head -1)
echo 2 > /sys/bus/pci/devices/$PCI/sriov_numvfs

sleep 2

DEFAULT_IP="10.10.10.1"
driver="nfp_netvf"

function print_usage {
    echo "Script to setup test case 1"
    echo "Usage: "
    echo "-i <ip>       --ip <bus>                IP address to add to interface"
    echo "-h            --help                    Prints this message and exits"
}

while [[ $# -gt 0 ]]
do
    argument="$1"
    case $argument in
        # Help
        -h|--help) print_usage; exit 1;;
        -i|--ip) IP="$2"; shift 2;;
        *) echo "Unkown argument: \"$argument\""; print_usage; exit 1;;
    esac
done

if [ -z "$IP" ] ; then IP=$DEFAULT_IP ; fi

script_dir="$(dirname $(readlink -f $0))"

#---------------------------------------------------------------------------

updatedb
DPDK_DEVBIND=$(find /root/ -iname dpdk-devbind.py | head -1)
if [ "$DPDK_DEVBIND" == "" ]; then
  echo "ERROR: could not find dpdk-devbind.py tool"
  exit -1
fi

PCIA="$(ethtool -i  enp1s8  | grep bus | cut -d ' ' -f 2)"
modprobe $driver
    
  #Bind the VF to nfp_netvf
  echo $DPDK_DEVBIND --bind $driver $PCIA
  $DPDK_DEVBIND --bind $driver $PCIA

  echo $DPDK_DEVBIND --status
  $DPDK_DEVBIND --status

#Get netdev name
ETH=$($DPDK_DEVBIND --status | grep $PCIA | cut -d ' ' -f 4 | cut -d '=' -f 2)

#Assign IP to netdev and up the interface
ip a add $IP/24 dev $ETH
ip link set dev $ETH up

ip link set nfp_p0 up

#Change MTU's
ifconfig nfp_p0 mtu 9000
ifconfig eth0 mtu 9000
ifconfig $ETH mtu 9000

#---------------------------------------------------------------------------------------------

echo "DONE($(basename $0))"
exit 0
