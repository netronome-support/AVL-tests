#!/bin/bash

NFP_IP=$1
IP_DUT2=$2

echo $NFP_IP
echo $IP_DUT2

#CHeck if tested

if [ -f "/local/mnt/workspace/AVL-tests/results/Beryllium-IPERF10_1" ]; then
    Beryllium="Tested"
else 
    Beryllium="Untested"
fi
if [ -f "/local/mnt/workspace/AVL-tests/results/Hydrogen-IPERF10_1" ]; then
    Hydrogen="Tested"
else 
    Hydrogen="Untested"
fi
if [ -f "/local/mnt/workspace/AVL-tests/results/Lithium-IPERF10_1" ]; then
    Lithium="Tested"
else 
    Lithium="Untested"
fi
if [ -f "/local/mnt/workspace/AVL-tests/results/Carbon-IPERF10_1" ]; then
    Carbon="Tested"
else 
    Carbon="Untested"
fi

#echo "Tested Cards:" >> /local/mnt/workspace/AVL-tests/results/logs/sys_log.txt
#echo "2x 40G Beryllium: $Beryllium" >> /local/mnt/workspace/AVL-tests/results/logs/sys_log.txt
#echo "2x 10G Lithium: $Lithium" >> /local/mnt/workspace/AVL-tests/results/logs/sys_log.txt
#echo "2x 25G Carbon: $Carbon" >> /local/mnt/workspace/AVL-tests/results/logs/sys_log.txt
#echo "1x 40G Hydrogen: $Hydrogen" >> /local/mnt/workspace/AVL-tests/results/logs/sys_log.txt

#Get pass fails
#echo "" >> /local/mnt/workspace/AVL-tests/results/logs/sys_log.txt
#cat /local/mnt/workspace/AVL-tests/results.txt | sed -r 's/[,]+/\t/g' >> /local/mnt/workspace/AVL-tests/results/logs/sys_log.txt
#echo "" >> /local/mnt/workspace/AVL-tests/results/logs/sys_log.txt

# Get system info

echo "Systems" > /local/mnt/workspace/AVL-tests/results/logs/sys_log.txt
echo "">> /local/mnt/workspace/AVL-tests/results/logs/sys_log.txt
echo "NFP Device">> /local/mnt/workspace/AVL-tests/results/logs/sys_log.txt
echo "----------">> /local/mnt/workspace/AVL-tests/results/logs/sys_log.txt
echo "OS: $(ssh -i ~/.ssh/netronome_key $NFP_IP 'cat /etc/*release | grep ^NAME= | cut -d '=' -f2')" >> /local/mnt/workspace/AVL-tests/results/logs/sys_log.txt
echo "Kerel: $(ssh -i ~/.ssh/netronome_key $NFP_IP 'uname -r')" >> /local/mnt/workspace/AVL-tests/results/logs/sys_log.txt
echo "Architechture: $(ssh -i ~/.ssh/netronome_key $NFP_IP 'uname -m')" >> /local/mnt/workspace/AVL-tests/results/logs/sys_log.txt
echo "">> /local/mnt/workspace/AVL-tests/results/logs/sys_log.txt
echo "Secondary Device">> /local/mnt/workspace/AVL-tests/results/logs/sys_log.txt
echo "----------">> /local/mnt/workspace/AVL-tests/results/logs/sys_log.txt
echo "OS: $(ssh -i ~/.ssh/netronome_key $IP_DUT2 'cat /etc/*release | grep ^NAME= | cut -d '=' -f2')" >> /local/mnt/workspace/AVL-tests/results/logs/sys_log.txt
echo "Kerel: $(ssh -i ~/.ssh/netronome_key $IP_DUT2 'uname -r')" >> /local/mnt/workspace/AVL-tests/results/logs/sys_log.txt
echo "Architechture: $(ssh -i ~/.ssh/netronome_key $IP_DUT2 'uname -m')" >> /local/mnt/workspace/AVL-tests/results/logs/sys_log.txt
echo "" >> /local/mnt/workspace/AVL-tests/results/logs/sys_log.txt
echo "" >> /local/mnt/workspace/AVL-tests/results/logs/sys_log.txt

#Beryllium stats
if [[ "$Beryllium" == "Tested" ]]; then
    echo -e "${bold}2x40G - Beryllium:" > /local/mnt/workspace/AVL-tests/results/logs/2x40_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x40_log.txt
    echo "2x40G Beryllium ethtool log:" >> /local/mnt/workspace/AVL-tests/results/logs/2x40_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x40_log.txt
    cat /local/mnt/workspace/AVL-tests/results/Beryllium-ethtool.txt >> /local/mnt/workspace/AVL-tests/results/logs/2x40_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x40_log.txt
    echo "2x40G Beryllium ISA log:" >> /local/mnt/workspace/AVL-tests/results/logs/2x40_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x40_log.txt
    cat /local/mnt/workspace/AVL-tests/results/Beryllium-isa.txt >> /local/mnt/workspace/AVL-tests/results/logs/2x40_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x40_log.txt
    echo "2x40G Beryllium ping test log:" >> /local/mnt/workspace/AVL-tests/results/logs/2x40_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x40_log.txt
    cat /local/mnt/workspace/AVL-tests/results/Beryllium-ping_test_1.txt >> /local/mnt/workspace/AVL-tests/results/logs/2x40_log.txt
    cat /local/mnt/workspace/AVL-tests/results/Beryllium-ping_test_2.txt >> /local/mnt/workspace/AVL-tests/results/logs/2x40_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x40_log.txt
    echo "2x40G Beryllium SSH log:" >> /local/mnt/workspace/AVL-tests/results/logs/2x40_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x40_log.txt
    cat /local/mnt/workspace/AVL-tests/results/Beryllium-ssh_test.txt >> /local/mnt/workspace/AVL-tests/results/logs/2x40_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x40_log.txt
    echo "2x40G Beryllium SCP log:" >> /local/mnt/workspace/AVL-tests/results/logs/2x40_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x40_log.txt
    cat /local/mnt/workspace/AVL-tests/results/Beryllium-dmesg_scp.txt >> /local/mnt/workspace/AVL-tests/results/logs/2x40_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x40_log.txt
    echo "2x40G Beryllium perf log:" >> /local/mnt/workspace/AVL-tests/results/logs/2x40_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x40_log.txt
    cat /local/mnt/workspace/AVL-tests/results/Beryllium-IPERF10_1 >> /local/mnt/workspace/AVL-tests/results/logs/2x40_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x40_log.txt
    cat /local/mnt/workspace/AVL-tests/results/Beryllium-IPERF11_1 >> /local/mnt/workspace/AVL-tests/results/logs/2x40_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x40_log.txt
    cat /local/mnt/workspace/AVL-tests/results/Beryllium-IPERF12_1 >> /local/mnt/workspace/AVL-tests/results/logs/2x40_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x40_log.txt
    cat /local/mnt/workspace/AVL-tests/results/Beryllium-IPERF13_1 >> /local/mnt/workspace/AVL-tests/results/logs/2x40_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x40_log.txt
    cat /local/mnt/workspace/AVL-tests/results/Beryllium-IPERF10_2 >> /local/mnt/workspace/AVL-tests/results/logs/2x40_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x40_log.txt
    cat /local/mnt/workspace/AVL-tests/results/Beryllium-IPERF11_2 >> /local/mnt/workspace/AVL-tests/results/logs/2x40_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x40_log.txt
    cat /local/mnt/workspace/AVL-tests/results/Beryllium-IPERF12_2 >> /local/mnt/workspace/AVL-tests/results/logs/2x40_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x40_log.txt
    cat /local/mnt/workspace/AVL-tests/results/Beryllium-IPERF13_2 >> /local/mnt/workspace/AVL-tests/results/logs/2x40_log.txt

fi

#Lithium stats
if [[ "$Lithium" == "Tested" ]]; then
    echo -e "${bold}2x10G - Lithium:" > /local/mnt/workspace/AVL-tests/results/logs/2x10_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x10_log.txt
    echo "2x10G Lithium ethtool log:" >> /local/mnt/workspace/AVL-tests/results/logs/2x10_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x10_log.txt
    cat /local/mnt/workspace/AVL-tests/results/Lithium-ethtool.txt >> /local/mnt/workspace/AVL-tests/results/logs/2x10_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x10_log.txt
    echo "2x10G Lithium ISA log:" >> /local/mnt/workspace/AVL-tests/results/logs/2x10_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x10_log.txt
    cat /local/mnt/workspace/AVL-tests/results/Lithium-isa.txt >> /local/mnt/workspace/AVL-tests/results/logs/2x10_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x10_log.txt
    echo "2x10G Lithium ping test log:" >> /local/mnt/workspace/AVL-tests/results/logs/2x10_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x10_log.txt
    cat /local/mnt/workspace/AVL-tests/results/Lithium-ping_test_1.txt >> /local/mnt/workspace/AVL-tests/results/logs/2x10_log.txt
    cat /local/mnt/workspace/AVL-tests/results/Lithium-ping_test_2.txt >> /local/mnt/workspace/AVL-tests/results/logs/2x10_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x10_log.txt
    echo "2x10G Lithium SSH log:" >> /local/mnt/workspace/AVL-tests/results/logs/2x10_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x10_log.txt
    cat /local/mnt/workspace/AVL-tests/results/Lithium-ssh_test.txt >> /local/mnt/workspace/AVL-tests/results/logs/2x10_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x10_log.txt
    echo "2x10G Lithium SCP log:" >> /local/mnt/workspace/AVL-tests/results/logs/2x10_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x10_log.txt
    cat /local/mnt/workspace/AVL-tests/results/Lithium-dmesg_scp.txt >> /local/mnt/workspace/AVL-tests/results/logs/2x10_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x10_log.txt
    echo "2x10G Lithium perf log:" >> /local/mnt/workspace/AVL-tests/results/logs/2x10_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x10_log.txt
    cat /local/mnt/workspace/AVL-tests/results/Lithium-IPERF10_1 >> /local/mnt/workspace/AVL-tests/results/logs/2x10_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x10_log.txt
    cat /local/mnt/workspace/AVL-tests/results/Lithium-IPERF11_1 >> /local/mnt/workspace/AVL-tests/results/logs/2x10_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x10_log.txt
    cat /local/mnt/workspace/AVL-tests/results/Lithium-IPERF12_1 >> /local/mnt/workspace/AVL-tests/results/logs/2x10_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x10_log.txt
    cat /local/mnt/workspace/AVL-tests/results/Lithium-IPERF13_1 >> /local/mnt/workspace/AVL-tests/results/logs/2x10_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x10_log.txt
    cat /local/mnt/workspace/AVL-tests/results/Lithium-IPERF10_2 >> /local/mnt/workspace/AVL-tests/results/logs/2x10_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x10_log.txt
    cat /local/mnt/workspace/AVL-tests/results/Lithium-IPERF11_2 >> /local/mnt/workspace/AVL-tests/results/logs/2x10_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x10_log.txt
    cat /local/mnt/workspace/AVL-tests/results/Lithium-IPERF12_2 >> /local/mnt/workspace/AVL-tests/results/logs/2x10_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x10_log.txt
    cat /local/mnt/workspace/AVL-tests/results/Lithium-IPERF13_2 >> /local/mnt/workspace/AVL-tests/results/logs/2x10_log.txt

fi

#Hydrogen stats
if [[ "$Hydrogen" == "Tested" ]]; then
    echo -e "${bold}1x40G Hydrogen:" > /local/mnt/workspace/AVL-tests/results/logs/1x40_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/1x40_log.txt
    echo "1x40G Hydrogen ethtool log:" >> /local/mnt/workspace/AVL-tests/results/logs/1x40_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/1x40_log.txt
    cat /local/mnt/workspace/AVL-tests/results/Hydrogen-ethtool.txt >> /local/mnt/workspace/AVL-tests/results/logs/1x40_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/1x40_log.txt
    echo "1x40G Hydrogen ISA log:" >> /local/mnt/workspace/AVL-tests/results/logs/1x40_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/1x40_log.txt
    cat /local/mnt/workspace/AVL-tests/results/Hydrogen-isa.txt >> /local/mnt/workspace/AVL-tests/results/logs/1x40_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/1x40_log.txt
    echo "1x40G Hydrogen ping test log:" >> /local/mnt/workspace/AVL-tests/results/logs/1x40_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/1x40_log.txt
    cat /local/mnt/workspace/AVL-tests/results/Hydrogen-ping_test_1.txt >> /local/mnt/workspace/AVL-tests/results/logs/1x40_log.txt
    cat /local/mnt/workspace/AVL-tests/results/Hydrogen-ping_test_2.txt >> /local/mnt/workspace/AVL-tests/results/logs/1x40_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/1x40_log.txt
    echo "1x40G Hydrogen SSH log:" >> /local/mnt/workspace/AVL-tests/results/logs/1x40_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/1x40_log.txt
    cat /local/mnt/workspace/AVL-tests/results/Hydrogen-ssh_test.txt >> /local/mnt/workspace/AVL-tests/results/logs/1x40_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/1x40_log.txt
    echo "1x40G Hydrogen SCP log:" >> /local/mnt/workspace/AVL-tests/results/logs/1x40_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/1x40_log.txt
    cat /local/mnt/workspace/AVL-tests/results/Hydrogen-dmesg_scp.txt >> /local/mnt/workspace/AVL-tests/results/logs/1x40_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/1x40_log.txt
    echo "1x40G Hydrogen perf log:" >> /local/mnt/workspace/AVL-tests/results/logs/1x40_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/1x40_log.txt
    cat /local/mnt/workspace/AVL-tests/results/Hydrogen-IPERF10_1 >> /local/mnt/workspace/AVL-tests/results/logs/1x40_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/1x40_log.txt
    cat /local/mnt/workspace/AVL-tests/results/Hydrogen-IPERF11_1 >> /local/mnt/workspace/AVL-tests/results/logs/1x40_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/1x40_log.txt
    cat /local/mnt/workspace/AVL-tests/results/Hydrogen-IPERF12_1 >> /local/mnt/workspace/AVL-tests/results/logs/1x40_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/1x40_log.txt
    cat /local/mnt/workspace/AVL-tests/results/Hydrogen-IPERF13_1 >> /local/mnt/workspace/AVL-tests/results/logs/1x40_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/1x40_log.txt
    cat /local/mnt/workspace/AVL-tests/results/Hydrogen-IPERF10_2 >> /local/mnt/workspace/AVL-tests/results/logs/1x40_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/1x40_log.txt
    cat /local/mnt/workspace/AVL-tests/results/Hydrogen-IPERF11_2 >> /local/mnt/workspace/AVL-tests/results/logs/1x40_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/1x40_log.txt
    cat /local/mnt/workspace/AVL-tests/results/Hydrogen-IPERF12_2 >> /local/mnt/workspace/AVL-tests/results/logs/1x40_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/1x40_log.txt
    cat /local/mnt/workspace/AVL-tests/results/Hydrogen-IPERF13_2 >> /local/mnt/workspace/AVL-tests/results/logs/1x40_log.txt

fi

#Carbon stats
if [[ "$Carbon" == "Tested" ]]; then
    echo -e "${bold}2x25G - Carbon:" > /local/mnt/workspace/AVL-tests/results/logs/2x25_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x25_log.txt
    echo "2x25G Carbon ethtool log:" >> /local/mnt/workspace/AVL-tests/results/logs/2x25_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x25_log.txt
    cat /local/mnt/workspace/AVL-tests/results/Carbon-ethtool.txt >> /local/mnt/workspace/AVL-tests/results/logs/2x25_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x25_log.txt
    echo "2x25G Carbon ISA log:" >> /local/mnt/workspace/AVL-tests/results/logs/2x25_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x25_log.txt
    cat /local/mnt/workspace/AVL-tests/results/Carbon-isa.txt >> /local/mnt/workspace/AVL-tests/results/logs/2x25_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x25_log.txt
    echo "2x25G Carbon ping test log:" >> /local/mnt/workspace/AVL-tests/results/logs/2x25_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x25_log.txt
    cat /local/mnt/workspace/AVL-tests/results/Carbon-ping_test_1.txt >> /local/mnt/workspace/AVL-tests/results/logs/2x25_log.txt
    cat /local/mnt/workspace/AVL-tests/results/Carbon-ping_test_2.txt >> /local/mnt/workspace/AVL-tests/results/logs/2x25_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x25_log.txt
    echo "2x25G Carbon SSH log:" >> /local/mnt/workspace/AVL-tests/results/logs/2x25_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x25_log.txt
    cat /local/mnt/workspace/AVL-tests/results/Carbon-ssh_test.txt >> /local/mnt/workspace/AVL-tests/results/logs/2x25_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x25_log.txt
    echo "2x25G Carbon SCP log:" >> /local/mnt/workspace/AVL-tests/results/logs/2x25_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x25_log.txt
    cat /local/mnt/workspace/AVL-tests/results/Carbon-dmesg_scp.txt >> /local/mnt/workspace/AVL-tests/results/logs/2x25_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x25_log.txt
    echo "2x25G Carbon perf log:" >> /local/mnt/workspace/AVL-tests/results/logs/2x25_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x25_log.txt
    cat /local/mnt/workspace/AVL-tests/results/Carbon-IPERF10_1 >> /local/mnt/workspace/AVL-tests/results/logs/2x25_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x25_log.txt
    cat /local/mnt/workspace/AVL-tests/results/Carbon-IPERF11_1 >> /local/mnt/workspace/AVL-tests/results/logs/2x25_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x25_log.txt
    cat /local/mnt/workspace/AVL-tests/results/Carbon-IPERF12_1 >> /local/mnt/workspace/AVL-tests/results/logs/2x25_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x25_log.txt
    cat /local/mnt/workspace/AVL-tests/results/Carbon-IPERF13_1 >> /local/mnt/workspace/AVL-tests/results/logs/2x25_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x25_log.txt
    cat /local/mnt/workspace/AVL-tests/results/Carbon-IPERF10_2 >> /local/mnt/workspace/AVL-tests/results/logs/2x25_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x25_log.txt
    cat /local/mnt/workspace/AVL-tests/results/Carbon-IPERF11_2 >> /local/mnt/workspace/AVL-tests/results/logs/2x25_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x25_log.txt
    cat /local/mnt/workspace/AVL-tests/results/Carbon-IPERF12_2 >> /local/mnt/workspace/AVL-tests/results/logs/2x25_log.txt
    echo "" >> /local/mnt/workspace/AVL-tests/results/logs/2x25_log.txt
    cat /local/mnt/workspace/AVL-tests/results/Carbon-IPERF13_2 >> /local/mnt/workspace/AVL-tests/results/logs/2x25_log.txt

fi

