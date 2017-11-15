#!/bin/bash
#package_install.sh

#Some colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

grep  ID_LIKE /etc/os-release | grep -q fedora
if [[ $? -eq 0 ]]; then
  echo -e "${RED}Please install Ubuntu on the ARM device to execute these tests.${NC}"
  sleep 6
  exit 0
fi 

export script_dir="$(dirname $(readlink -f $0))"

cd $script_dir
cd ..


#Check if AOVS is installed, uninstall if present
if [ -z ${NS_SDN_REVISION+x} ]; then
   echo "Agilio-OVS is not installed"

else
   NS_SDN_REVISION=$(echo $NS_SDN_REVISION | cut -f1 -d":")
   #echo "Agilio-OVS $NS_SDN_VERSION Revision $NS_SDN_REVISION is installed"
   rmmod vfio-pci
   /opt/netronome/bin/agilio-ovs-uninstall.sh -y

   #Check if uninstall script exited cleanly
   if [ $? == 1 ]; then
      exit 1
   fi
fi

grep ID_LIKE /etc/os-release | grep -q debian
if [[ $? -eq 0 ]]; then

  apt-get -y install make autoconf automake libtool \
   gcc g++ bison flex hwloc-nox libreadline-dev libpcap-dev dkms libftdi1 libjansson4 \
   libjansson-dev guilt pkg-config libevent-dev ethtool build-essential libssl-dev \
   libnl-3-200 libnl-3-dev libnl-genl-3-200 libnl-genl-3-dev psmisc gawk \
   libzmq3-dev protobuf-c-compiler protobuf-compiler python-protobuf \
   libnuma1 libnuma-dev python-ethtool python-six python-ethtool \
   virtinst bridge-utils cpu-checker libjansson-dev dkms iperf python
  
  # CPU-meas pre-req
  apt-get -y install aha htop sysstat
  
  # Clean-up
  apt -y autoremove
  
  # Fix dependencies
  apt -f install
  

  dpkg -i nfp-bsp-6000-b0_2017.10.05.1604-1_arm64.deb
  dpkg -i nfp-bsp-6000-b0-dev_2017.10.05.1604-1_arm64.deb
  dpkg -i nfp-bsp-6000-b0-dkms_2017.10.05.1604_all.deb

  dpkg -i ns-agilio-core-nic*.deb

fi

echo "DONE(package_install.sh)"


# CentOS
#grep  ID_LIKE /etc/os-release | grep -q fedora
#if [[ $? -eq 0 ]]; then
  
# yum -y install epel-release
#  yum -y install make autoconf automake libtool gcc gcc-c++ libpcap-devel \
#  readline-devel jansson-devel libevent libevent-devel libtool openssl-devel \
#  bison flex gawk hwloc gettext texinfo rpm-build \
#  redhat-rpm-config graphviz python-devel python python-devel tcl-devel \
#  tk-devel texinfo dkms zip unzip pkgconfig wget patch minicom libusb \
#  libusb-devel psmisc libnl3-devel libftdi pciutils \
#  zeromq3 zeromq3-devel protobuf-c-compiler protobuf-compiler protobuf-python \
#  protobuf-c-devel python-six numactl-libs python-ethtool \
#  python-virtinst virt-manager libguestfs-tools \
#  cloud-utils lvm2 wget git net-tools centos-release-qemu-ev.noarch \
#  qemu-kvm-ev libvirt libvirt-python virt-install \
#  numactl-devel numactl-devel pearl iperf
  
  #CPU-meas pre-req
#  yum -y install sysstat aha htop

  #Disable firewall for vxlan tunnels  
#  systemctl disable firewalld.service
#  systemctl stop firewalld.service

  #Disable NetworkManager
# systemctl disable NetworkManager.service
#  systemctl stop NetworkManager.service
  

  #SELINUX config
#  setenforce 0
#  sed -E 's/(SELINUX=).*/\1disabled/g' -i /etc/selinux/config


#ls /root/agilio-ovs-2.6.B-r* 2>/dev/null
#if [ $? == 2 ]; then
#   echo "Could not find BSP package file in root directory"
#   echo "Please copy the BSP package file file into /root/"
#   exit -1
#else

#   cd  
#   rpm -ivh nfp-bsp-6000*.rpm || exit -1
#   echo
#   echo
#   echo "Checking if NIC flash is required..."
#   sleep 5
#   /opt/netronome/bin/nfp-update-flash.sh
#fi


#ls /root/ns-agilio-core-nic* 2>/dev/null
#if [ $? == 2 ]; then
#   echo "Could not find CoreNIC package file file in root directory"
#   echo "Please copy the CoreNIC package file file into /root/"
#   exit -1
#else

   
#   rpm -ivh -i ns-agilio-core-nic*.rpm || exit -1
#   echo
#   echo

#fi

#fi

#echo "DONE(package_install.sh)"

#exit 0

