#!/bin/bash

NFP_IP=$1
IP_DUT2=$2

echo $NFP_IP
echo $IP_DUT2

#CHeck if tested

if [ -f "/root/AVL-tests/results/Beryllium-IPERF10*" ]; then
    Beryllium="Tested"
else 
    Beryllium="Untested"
fi
if [ -f "/root/AVL-tests/results/Hydrogen-IPERF10*" ]; then
    Hydrogen="Tested"
else 
    Hydrogen="Untested"
fi
if [ -f "/root/AVL-tests/results/Lithium-IPERF10*" ]; then
    Lithium="Tested"
else 
    Lithium="Untested"
fi
if [ -f "/root/AVL-tests/results/Carbon-IPERF10*" ]; then
    Carbon="Tested"
else 
    Carbon="Untested"
fi

#echo "Tested Cards:" >> /root/AVL-tests/results/logs/sys_log.txt
#echo "2x 40G Beryllium: $Beryllium" >> /root/AVL-tests/results/logs/sys_log.txt
#echo "2x 10G Lithium: $Lithium" >> /root/AVL-tests/results/logs/sys_log.txt
#echo "2x 25G Carbon: $Carbon" >> /root/AVL-tests/results/logs/sys_log.txt
#echo "1x 40G Hydrogen: $Hydrogen" >> /root/AVL-tests/results/logs/sys_log.txt

#Get pass fails
#echo "" >> /root/AVL-tests/results/logs/sys_log.txt
#cat /root/AVL-tests/results.txt | sed -r 's/[,]+/\t/g' >> /root/AVL-tests/results/logs/sys_log.txt
#echo "" >> /root/AVL-tests/results/logs/sys_log.txt

# Get system info

echo "Systems" > /root/AVL-tests/results/logs/sys_log.txt
echo "">> /root/AVL-tests/results/logs/sys_log.txt
echo "NFP Device">> /root/AVL-tests/results/logs/sys_log.txt
echo "----------">> /root/AVL-tests/results/logs/sys_log.txt
echo "OS: $(ssh -i ~/.ssh/netronome_key $NFP_IP 'cat /etc/*release | grep ^NAME= | cut -d '=' -f2')" >> /root/AVL-tests/results/logs/sys_log.txt
echo "Kerel: $(ssh -i ~/.ssh/netronome_key $NFP_IP 'uname -r')" >> /root/AVL-tests/results/logs/sys_log.txt
echo "Architechture: $(ssh -i ~/.ssh/netronome_key $NFP_IP 'uname -m')" >> /root/AVL-tests/results/logs/sys_log.txt
echo "">> /root/AVL-tests/results/logs/sys_log.txt
echo "Secondary Device">> /root/AVL-tests/results/logs/sys_log.txt
echo "----------">> /root/AVL-tests/results/logs/sys_log.txt
echo "OS: $(ssh -i ~/.ssh/netronome_key $IP_DUT2 'cat /etc/*release | grep ^NAME= | cut -d '=' -f2')" >> /root/AVL-tests/results/logs/sys_log.txt
echo "Kerel: $(ssh -i ~/.ssh/netronome_key $IP_DUT2 'uname -r')" >> /root/AVL-tests/results/logs/sys_log.txt
echo "Architechture: $(ssh -i ~/.ssh/netronome_key $IP_DUT2 'uname -m')" >> /root/AVL-tests/results/logs/sys_log.txt
echo "" >> /root/AVL-tests/results/logs/sys_log.txt
echo "" >> /root/AVL-tests/results/logs/sys_log.txt

#Beryllium stats
if [[ "$Beryllium" == "Tested" ]]; then
    echo -e "${bold}2x40G - Beryllium:" > /root/AVL-tests/results/logs/2x40_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x40_log.txt
    echo "2x40G Beryllium ethtool log:" >> /root/AVL-tests/results/logs/2x40_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x40_log.txt
    cat /root/AVL-tests/results/Beryllium-ethtool.txt >> /root/AVL-tests/results/logs/2x40_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x40_log.txt
    echo "2x40G Beryllium ethtool log:" >> /root/AVL-tests/results/logs/2x40_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x40_log.txt
    cat /root/AVL-tests/results/Beryllium-isa.txt >> /root/AVL-tests/results/logs/2x40_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x40_log.txt
    echo "2x40G Beryllium ping test log:" >> /root/AVL-tests/results/logs/2x40_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x40_log.txt
    cat /root/AVL-tests/results/Beryllium-ping_test_1.txt >> /root/AVL-tests/results/logs/2x40_log.txt
    cat /root/AVL-tests/results/Beryllium-ping_test_2.txt >> /root/AVL-tests/results/logs/2x40_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x40_log.txt
    echo "2x40G Beryllium SSH log:" >> /root/AVL-tests/results/logs/2x40_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x40_log.txt
    cat /root/AVL-tests/results/Beryllium-ssh_test.txt >> /root/AVL-tests/results/logs/2x40_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x40_log.txt
    echo "2x40G Beryllium SCP log:" >> /root/AVL-tests/results/logs/2x40_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x40_log.txt
    cat /root/AVL-tests/results/Beryllium-dmesg_scp.txt >> /root/AVL-tests/results/logs/2x40_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x40_log.txt
    echo "2x40G Beryllium perf log:" >> /root/AVL-tests/results/logs/2x40_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x40_log.txt
    cat /root/AVL-tests/results/Beryllium-IPERF10_1 >> /root/AVL-tests/results/logs/2x40_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x40_log.txt
    cat /root/AVL-tests/results/Beryllium-IPERF11_1 >> /root/AVL-tests/results/logs/2x40_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x40_log.txt
    cat /root/AVL-tests/results/Beryllium-IPERF12_1 >> /root/AVL-tests/results/logs/2x40_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x40_log.txt
    cat /root/AVL-tests/results/Beryllium-IPERF13_1 >> /root/AVL-tests/results/logs/2x40_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x40_log.txt
    cat /root/AVL-tests/results/Beryllium-IPERF10_2 >> /root/AVL-tests/results/logs/2x40_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x40_log.txt
    cat /root/AVL-tests/results/Beryllium-IPERF11_2 >> /root/AVL-tests/results/logs/2x40_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x40_log.txt
    cat /root/AVL-tests/results/Beryllium-IPERF12_2 >> /root/AVL-tests/results/logs/2x40_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x40_log.txt
    cat /root/AVL-tests/results/Beryllium-IPERF13_2 >> /root/AVL-tests/results/logs/2x40_log.txt

fi

#Lithium stats
if [[ "$Lithium" == "Tested" ]]; then
    echo -e "${bold}2x10G - Lithium:" > /root/AVL-tests/results/logs/2x10_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x10_log.txt
    echo "2x10G Lithium ethtool log:" >> /root/AVL-tests/results/logs/2x10_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x10_log.txt
    cat /root/AVL-tests/results/Lithium-ethtool.txt >> /root/AVL-tests/results/logs/2x10_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x10_log.txt
    echo "2x10G Lithium ethtool log:" >> /root/AVL-tests/results/logs/2x10_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x10_log.txt
    cat /root/AVL-tests/results/Lithium-isa.txt >> /root/AVL-tests/results/logs/2x10_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x10_log.txt
    echo "2x10G Lithium ping test log:" >> /root/AVL-tests/results/logs/2x10_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x10_log.txt
    cat /root/AVL-tests/results/Lithium-ping_test_1.txt >> /root/AVL-tests/results/logs/2x10_log.txt
    cat /root/AVL-tests/results/Lithium-ping_test_2.txt >> /root/AVL-tests/results/logs/2x10_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x10_log.txt
    echo "2x10G Lithium SSH log:" >> /root/AVL-tests/results/logs/2x10_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x10_log.txt
    cat /root/AVL-tests/results/Lithium-ssh_test.txt >> /root/AVL-tests/results/logs/2x10_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x10_log.txt
    echo "2x10G Lithium SCP log:" >> /root/AVL-tests/results/logs/2x10_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x10_log.txt
    cat /root/AVL-tests/results/Lithium-dmesg_scp.txt >> /root/AVL-tests/results/logs/2x10_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x10_log.txt
    echo "2x10G Lithium perf log:" >> /root/AVL-tests/results/logs/2x10_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x10_log.txt
    cat /root/AVL-tests/results/Lithium-IPERF10_1 >> /root/AVL-tests/results/logs/2x10_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x10_log.txt
    cat /root/AVL-tests/results/Lithium-IPERF11_1 >> /root/AVL-tests/results/logs/2x10_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x10_log.txt
    cat /root/AVL-tests/results/Lithium-IPERF12_1 >> /root/AVL-tests/results/logs/2x10_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x10_log.txt
    cat /root/AVL-tests/results/Lithium-IPERF13_1 >> /root/AVL-tests/results/logs/2x10_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x10_log.txt
    cat /root/AVL-tests/results/Lithium-IPERF10_2 >> /root/AVL-tests/results/logs/2x10_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x10_log.txt
    cat /root/AVL-tests/results/Lithium-IPERF11_2 >> /root/AVL-tests/results/logs/2x10_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x10_log.txt
    cat /root/AVL-tests/results/Lithium-IPERF12_2 >> /root/AVL-tests/results/logs/2x10_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x10_log.txt
    cat /root/AVL-tests/results/Lithium-IPERF13_2 >> /root/AVL-tests/results/logs/2x10_log.txt

fi

#Hydrogen stats
if [[ "$Hydrogen" == "Tested" ]]; then
    echo -e "${bold}1x40G Hydrogen:" > /root/AVL-tests/results/logs/1x40_log.txt
    echo "" >> /root/AVL-tests/results/logs/1x40_log.txt
    echo "1x40G Hydrogen ethtool log:" >> /root/AVL-tests/results/logs/1x40_log.txt
    echo "" >> /root/AVL-tests/results/logs/1x40_log.txt
    cat /root/AVL-tests/results/Hydrogen-ethtool.txt >> /root/AVL-tests/results/logs/1x40_log.txt
    echo "" >> /root/AVL-tests/results/logs/1x40_log.txt
    echo "1x40G Hydrogen ethtool log:" >> /root/AVL-tests/results/logs/1x40_log.txt
    echo "" >> /root/AVL-tests/results/logs/1x40_log.txt
    cat /root/AVL-tests/results/Hydrogen-isa.txt >> /root/AVL-tests/results/logs/1x40_log.txt
    echo "" >> /root/AVL-tests/results/logs/1x40_log.txt
    echo "1x40G Hydrogen ping test log:" >> /root/AVL-tests/results/logs/1x40_log.txt
    echo "" >> /root/AVL-tests/results/logs/1x40_log.txt
    cat /root/AVL-tests/results/Hydrogen-ping_test_1.txt >> /root/AVL-tests/results/logs/1x40_log.txt
    cat /root/AVL-tests/results/Hydrogen-ping_test_2.txt >> /root/AVL-tests/results/logs/1x40_log.txt
    echo "" >> /root/AVL-tests/results/logs/1x40_log.txt
    echo "1x40G Hydrogen SSH log:" >> /root/AVL-tests/results/logs/1x40_log.txt
    echo "" >> /root/AVL-tests/results/logs/1x40_log.txt
    cat /root/AVL-tests/results/Hydrogen-ssh_test.txt >> /root/AVL-tests/results/logs/1x40_log.txt
    echo "" >> /root/AVL-tests/results/logs/1x40_log.txt
    echo "1x40G Hydrogen SCP log:" >> /root/AVL-tests/results/logs/1x40_log.txt
    echo "" >> /root/AVL-tests/results/logs/1x40_log.txt
    cat /root/AVL-tests/results/Hydrogen-dmesg_scp.txt >> /root/AVL-tests/results/logs/1x40_log.txt
    echo "" >> /root/AVL-tests/results/logs/1x40_log.txt
    echo "1x40G Hydrogen perf log:" >> /root/AVL-tests/results/logs/1x40_log.txt
    echo "" >> /root/AVL-tests/results/logs/1x40_log.txt
    cat /root/AVL-tests/results/Hydrogen-IPERF10_1 >> /root/AVL-tests/results/logs/1x40_log.txt
    echo "" >> /root/AVL-tests/results/logs/1x40_log.txt
    cat /root/AVL-tests/results/Hydrogen-IPERF11_1 >> /root/AVL-tests/results/logs/1x40_log.txt
    echo "" >> /root/AVL-tests/results/logs/1x40_log.txt
    cat /root/AVL-tests/results/Hydrogen-IPERF12_1 >> /root/AVL-tests/results/logs/1x40_log.txt
    echo "" >> /root/AVL-tests/results/logs/1x40_log.txt
    cat /root/AVL-tests/results/Hydrogen-IPERF13_1 >> /root/AVL-tests/results/logs/1x40_log.txt
    echo "" >> /root/AVL-tests/results/logs/1x40_log.txt
    cat /root/AVL-tests/results/Hydrogen-IPERF10_2 >> /root/AVL-tests/results/logs/1x40_log.txt
    echo "" >> /root/AVL-tests/results/logs/1x40_log.txt
    cat /root/AVL-tests/results/Hydrogen-IPERF11_2 >> /root/AVL-tests/results/logs/1x40_log.txt
    echo "" >> /root/AVL-tests/results/logs/1x40_log.txt
    cat /root/AVL-tests/results/Hydrogen-IPERF12_2 >> /root/AVL-tests/results/logs/1x40_log.txt
    echo "" >> /root/AVL-tests/results/logs/1x40_log.txt
    cat /root/AVL-tests/results/Hydrogen-IPERF13_2 >> /root/AVL-tests/results/logs/1x40_log.txt

fi

#Carbon stats
if [[ "$Carbon" == "Tested" ]]; then
    echo -e "${bold}2x25G - Carbon:" > /root/AVL-tests/results/logs/2x25_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x25_log.txt
    echo "2x25G Carbon ethtool log:" >> /root/AVL-tests/results/logs/2x25_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x25_log.txt
    cat /root/AVL-tests/results/Carbon-ethtool.txt >> /root/AVL-tests/results/logs/2x25_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x25_log.txt
    echo "2x25G Carbon ethtool log:" >> /root/AVL-tests/results/logs/2x25_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x25_log.txt
    cat /root/AVL-tests/results/Carbon-isa.txt >> /root/AVL-tests/results/logs/2x25_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x25_log.txt
    echo "2x25G Carbon ping test log:" >> /root/AVL-tests/results/logs/2x25_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x25_log.txt
    cat /root/AVL-tests/results/Carbon-ping_test_1.txt >> /root/AVL-tests/results/logs/2x25_log.txt
    cat /root/AVL-tests/results/Carbon-ping_test_2.txt >> /root/AVL-tests/results/logs/2x25_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x25_log.txt
    echo "2x25G Carbon SSH log:" >> /root/AVL-tests/results/logs/2x25_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x25_log.txt
    cat /root/AVL-tests/results/Carbon-ssh_test.txt >> /root/AVL-tests/results/logs/2x25_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x25_log.txt
    echo "2x25G Carbon SCP log:" >> /root/AVL-tests/results/logs/2x25_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x25_log.txt
    cat /root/AVL-tests/results/Carbon-dmesg_scp.txt >> /root/AVL-tests/results/logs/2x25_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x25_log.txt
    echo "2x25G Carbon perf log:" >> /root/AVL-tests/results/logs/2x25_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x25_log.txt
    cat /root/AVL-tests/results/Carbon-IPERF10_1 >> /root/AVL-tests/results/logs/2x25_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x25_log.txt
    cat /root/AVL-tests/results/Carbon-IPERF11_1 >> /root/AVL-tests/results/logs/2x25_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x25_log.txt
    cat /root/AVL-tests/results/Carbon-IPERF12_1 >> /root/AVL-tests/results/logs/2x25_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x25_log.txt
    cat /root/AVL-tests/results/Carbon-IPERF13_1 >> /root/AVL-tests/results/logs/2x25_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x25_log.txt
    cat /root/AVL-tests/results/Carbon-IPERF10_2 >> /root/AVL-tests/results/logs/2x25_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x25_log.txt
    cat /root/AVL-tests/results/Carbon-IPERF11_2 >> /root/AVL-tests/results/logs/2x25_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x25_log.txt
    cat /root/AVL-tests/results/Carbon-IPERF12_2 >> /root/AVL-tests/results/logs/2x25_log.txt
    echo "" >> /root/AVL-tests/results/logs/2x25_log.txt
    cat /root/AVL-tests/results/Carbon-IPERF13_2 >> /root/AVL-tests/results/logs/2x25_log.txt

fi

