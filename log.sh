#!/bin/bash

NFP_IP=$1
IP_DUT2=$2

echo $NFP_IP
echo $IP_DUT2

#CHeck if tested

if [ -f "/root/Qualcomm/results/Beryllium-iperf_test_1.txt" ]; then
    Beryllium="Tested"
else 
    Beryllium="Untested"
fi
if [ -f "/root/Qualcomm/results/Hydrogen-iperf_test_1.txt" ]; then
    Hydrogen="Tested"
else 
    Hydrogen="Untested"
fi
if [ -f "/root/Qualcomm/results/Lithium-iperf_test_1.txt" ]; then
    Lithium="Tested"
else 
    Lithium="Untested"
fi
if [ -f "/root/Qualcomm/results/Carbon-iperf_test_1.txt" ]; then
    Carbon="Tested"
else 
    Carbon="Untested"
fi

#echo "Tested Cards:" >> /root/Qualcomm/results/logs/sys_log.txt
#echo "2x 40G Beryllium: $Beryllium" >> /root/Qualcomm/results/logs/sys_log.txt
#echo "2x 10G Lithium: $Lithium" >> /root/Qualcomm/results/logs/sys_log.txt
#echo "2x 25G Carbon: $Carbon" >> /root/Qualcomm/results/logs/sys_log.txt
#echo "1x 40G Hydrogen: $Hydrogen" >> /root/Qualcomm/results/logs/sys_log.txt

#Get pass fails
#echo "" >> /root/Qualcomm/results/logs/sys_log.txt
#cat /root/Qualcomm/results.txt | sed -r 's/[,]+/\t/g' >> /root/Qualcomm/results/logs/sys_log.txt
#echo "" >> /root/Qualcomm/results/logs/sys_log.txt

# Get system info

echo "Systems" > /root/Qualcomm/results/logs/sys_log.txt
echo "">> /root/Qualcomm/results/logs/sys_log.txt
echo "NFP Device">> /root/Qualcomm/results/logs/sys_log.txt
echo "----------">> /root/Qualcomm/results/logs/sys_log.txt
echo "OS: $(ssh -i ~/.ssh/netronome_key $NFP_IP 'cat /etc/*release | grep ^NAME= | cut -d '=' -f2')" >> /root/Qualcomm/results/logs/sys_log.txt
echo "Kerel: $(ssh -i ~/.ssh/netronome_key $NFP_IP 'uname -r')" >> /root/Qualcomm/results/logs/sys_log.txt
echo "Architechture: $(ssh -i ~/.ssh/netronome_key $NFP_IP 'uname -m')" >> /root/Qualcomm/results/logs/sys_log.txt
echo "">> /root/Qualcomm/results/logs/sys_log.txt
echo "Secondary Device">> /root/Qualcomm/results/logs/sys_log.txt
echo "----------">> /root/Qualcomm/results/logs/sys_log.txt
echo "OS: $(ssh -i ~/.ssh/netronome_key $IP_DUT2 'cat /etc/*release | grep ^NAME= | cut -d '=' -f2')" >> /root/Qualcomm/results/logs/sys_log.txt
echo "Kerel: $(ssh -i ~/.ssh/netronome_key $IP_DUT2 'uname -r')" >> /root/Qualcomm/results/logs/sys_log.txt
echo "Architechture: $(ssh -i ~/.ssh/netronome_key $IP_DUT2 'uname -m')" >> /root/Qualcomm/results/logs/sys_log.txt
echo "" >> /root/Qualcomm/results/logs/sys_log.txt
echo "" >> /root/Qualcomm/results/logs/sys_log.txt

#Beryllium stats
if [[ "$Beryllium" == "Tested" ]]; then
    echo -e "${bold}2x40G - Beryllium:" > /root/Qualcomm/results/logs/2x40_log.txt
    echo "" >> /root/Qualcomm/results/logs/2x40_log.txt
    echo "2x40G Beryllium ethtool log:" >> /root/Qualcomm/results/logs/2x40_log.txt
    echo "" >> /root/Qualcomm/results/logs/2x40_log.txt
    cat /root/Qualcomm/results/Beryllium-ethtool.txt >> /root/Qualcomm/results/logs/2x40_log.txt
    echo "" >> /root/Qualcomm/results/logs/2x40_log.txt
    echo "2x40G Beryllium ethtool log:" >> /root/Qualcomm/results/logs/2x40_log.txt
    echo "" >> /root/Qualcomm/results/logs/2x40_log.txt
    cat /root/Qualcomm/results/Beryllium-isa.txt >> /root/Qualcomm/results/logs/2x40_log.txt
    echo "" >> /root/Qualcomm/results/logs/2x40_log.txt
    echo "2x40G Beryllium ping test log:" >> /root/Qualcomm/results/logs/2x40_log.txt
    echo "" >> /root/Qualcomm/results/logs/2x40_log.txt
    cat /root/Qualcomm/results/Beryllium-ping_test_1.txt >> /root/Qualcomm/results/logs/2x40_log.txt
    cat /root/Qualcomm/results/Beryllium-ping_test_2.txt >> /root/Qualcomm/results/logs/2x40_log.txt
    echo "" >> /root/Qualcomm/results/logs/2x40_log.txt
    echo "2x40G Beryllium SSH log:" >> /root/Qualcomm/results/logs/2x40_log.txt
    echo "" >> /root/Qualcomm/results/logs/2x40_log.txt
    cat /root/Qualcomm/results/Beryllium-ssh_test.txt >> /root/Qualcomm/results/logs/2x40_log.txt
    echo "" >> /root/Qualcomm/results/logs/2x40_log.txt
    echo "2x40G Beryllium SCP log:" >> /root/Qualcomm/results/logs/2x40_log.txt
    echo "" >> /root/Qualcomm/results/logs/2x40_log.txt
    cat /root/Qualcomm/results/Beryllium-dmesg_scp.txt >> /root/Qualcomm/results/logs/2x40_log.txt
    echo "" >> /root/Qualcomm/results/logs/2x40_log.txt
    echo "2x40G Beryllium perf log:" >> /root/Qualcomm/results/logs/2x40_log.txt
    echo "" >> /root/Qualcomm/results/logs/2x40_log.txt
    cat /root/Qualcomm/results/Beryllium-iperf_test_1.txt >> /root/Qualcomm/results/logs/2x40_log.txt
    cat /root/Qualcomm/results/Beryllium-iperf_test_2.txt >> /root/Qualcomm/results/logs/2x40_log.txt

fi

#Lithium stats
if [[ "$Lithium" == "Tested" ]]; then
    echo -e "${bold}2x10G - Lithium:" > /root/Qualcomm/results/logs/2x10_log.txt
    echo "" >> /root/Qualcomm/results/logs/2x10_log.txt
    echo "2x10G Lithium ethtool log:" >> /root/Qualcomm/results/logs/2x10_log.txt
    echo "" >> /root/Qualcomm/results/logs/2x10_log.txt
    cat /root/Qualcomm/results/Lithium-ethtool.txt >> /root/Qualcomm/results/logs/2x10_log.txt
    echo "" >> /root/Qualcomm/results/logs/2x10_log.txt
    echo "2x10G Lithium ethtool log:" >> /root/Qualcomm/results/logs/2x10_log.txt
    echo "" >> /root/Qualcomm/results/logs/2x10_log.txt
    cat /root/Qualcomm/results/Lithium-isa.txt >> /root/Qualcomm/results/logs/2x10_log.txt
    echo "" >> /root/Qualcomm/results/logs/2x10_log.txt
    echo "2x10G Lithium ping test log:" >> /root/Qualcomm/results/logs/2x10_log.txt
    echo "" >> /root/Qualcomm/results/logs/2x10_log.txt
    cat /root/Qualcomm/results/Lithium-ping_test_1.txt >> /root/Qualcomm/results/logs/2x10_log.txt
    cat /root/Qualcomm/results/Lithium-ping_test_2.txt >> /root/Qualcomm/results/logs/2x10_log.txt
    echo "" >> /root/Qualcomm/results/logs/2x10_log.txt
    echo "2x10G Lithium SSH log:" >> /root/Qualcomm/results/logs/2x10_log.txt
    echo "" >> /root/Qualcomm/results/logs/2x10_log.txt
    cat /root/Qualcomm/results/Lithium-ssh_test.txt >> /root/Qualcomm/results/logs/2x10_log.txt
    echo "" >> /root/Qualcomm/results/logs/2x10_log.txt
    echo "2x10G Lithium SCP log:" >> /root/Qualcomm/results/logs/2x10_log.txt
    echo "" >> /root/Qualcomm/results/logs/2x10_log.txt
    cat /root/Qualcomm/results/Lithium-dmesg_scp.txt >> /root/Qualcomm/results/logs/2x10_log.txt
    echo "" >> /root/Qualcomm/results/logs/2x10_log.txt
    echo "2x10G Lithium perf log:" >> /root/Qualcomm/results/logs/2x10_log.txt
    echo "" >> /root/Qualcomm/results/logs/2x10_log.txt
    cat /root/Qualcomm/results/Lithium-iperf_test_1.txt >> /root/Qualcomm/results/logs/2x10_log.txt
    cat /root/Qualcomm/results/Lithium-iperf_test_2.txt >> /root/Qualcomm/results/logs/2x10_log.txt

fi

#Hydrogen stats
if [[ "$Hydrogen" == "Tested" ]]; then
    echo -e "${bold}1x40G Hydrogen:" > /root/Qualcomm/results/logs/1x40_log.txt
    echo "" >> /root/Qualcomm/results/logs/1x40_log.txt
    echo "1x40G Hydrogen ethtool log:" >> /root/Qualcomm/results/logs/1x40_log.txt
    echo "" >> /root/Qualcomm/results/logs/1x40_log.txt
    cat /root/Qualcomm/results/Hydrogen-ethtool.txt >> /root/Qualcomm/results/logs/1x40_log.txt
    echo "" >> /root/Qualcomm/results/logs/1x40_log.txt
    echo "1x40G Hydrogen ethtool log:" >> /root/Qualcomm/results/logs/1x40_log.txt
    echo "" >> /root/Qualcomm/results/logs/1x40_log.txt
    cat /root/Qualcomm/results/Hydrogen-isa.txt >> /root/Qualcomm/results/logs/1x40_log.txt
    echo "" >> /root/Qualcomm/results/logs/1x40_log.txt
    echo "1x40G Hydrogen ping test log:" >> /root/Qualcomm/results/logs/1x40_log.txt
    echo "" >> /root/Qualcomm/results/logs/1x40_log.txt
    cat /root/Qualcomm/results/Hydrogen-ping_test_1.txt >> /root/Qualcomm/results/logs/1x40_log.txt
    cat /root/Qualcomm/results/Hydrogen-ping_test_2.txt >> /root/Qualcomm/results/logs/1x40_log.txt
    echo "" >> /root/Qualcomm/results/logs/1x40_log.txt
    echo "1x40G Hydrogen SSH log:" >> /root/Qualcomm/results/logs/1x40_log.txt
    echo "" >> /root/Qualcomm/results/logs/1x40_log.txt
    cat /root/Qualcomm/results/Hydrogen-ssh_test.txt >> /root/Qualcomm/results/logs/1x40_log.txt
    echo "" >> /root/Qualcomm/results/logs/1x40_log.txt
    echo "1x40G Hydrogen SCP log:" >> /root/Qualcomm/results/logs/1x40_log.txt
    echo "" >> /root/Qualcomm/results/logs/1x40_log.txt
    cat /root/Qualcomm/results/Hydrogen-dmesg_scp.txt >> /root/Qualcomm/results/logs/1x40_log.txt
    echo "" >> /root/Qualcomm/results/logs/1x40_log.txt
    echo "1x40G Hydrogen perf log:" >> /root/Qualcomm/results/logs/1x40_log.txt
    echo "" >> /root/Qualcomm/results/logs/1x40_log.txt
    cat /root/Qualcomm/results/Hydrogen-iperf_test_1.txt >> /root/Qualcomm/results/logs/1x40_log.txt
    cat /root/Qualcomm/results/Hydrogen-iperf_test_2.txt >> /root/Qualcomm/results/logs/1x40_log.txt

fi

#Carbon stats
if [[ "$Carbon" == "Tested" ]]; then
    echo -e "${bold}2x25G - Carbon:" > /root/Qualcomm/results/logs/2x25_log.txt
    echo "" >> /root/Qualcomm/results/logs/2x25_log.txt
    echo "2x25G Carbon ethtool log:" >> /root/Qualcomm/results/logs/2x25_log.txt
    echo "" >> /root/Qualcomm/results/logs/2x25_log.txt
    cat /root/Qualcomm/results/Carbon-ethtool.txt >> /root/Qualcomm/results/logs/2x25_log.txt
    echo "" >> /root/Qualcomm/results/logs/2x25_log.txt
    echo "2x25G Carbon ethtool log:" >> /root/Qualcomm/results/logs/2x25_log.txt
    echo "" >> /root/Qualcomm/results/logs/2x25_log.txt
    cat /root/Qualcomm/results/Carbon-isa.txt >> /root/Qualcomm/results/logs/2x25_log.txt
    echo "" >> /root/Qualcomm/results/logs/2x25_log.txt
    echo "2x25G Carbon ping test log:" >> /root/Qualcomm/results/logs/2x25_log.txt
    echo "" >> /root/Qualcomm/results/logs/2x25_log.txt
    cat /root/Qualcomm/results/Carbon-ping_test_1.txt >> /root/Qualcomm/results/logs/2x25_log.txt
    cat /root/Qualcomm/results/Carbon-ping_test_2.txt >> /root/Qualcomm/results/logs/2x25_log.txt
    echo "" >> /root/Qualcomm/results/logs/2x25_log.txt
    echo "2x25G Carbon SSH log:" >> /root/Qualcomm/results/logs/2x25_log.txt
    echo "" >> /root/Qualcomm/results/logs/2x25_log.txt
    cat /root/Qualcomm/results/Carbon-ssh_test.txt >> /root/Qualcomm/results/logs/2x25_log.txt
    echo "" >> /root/Qualcomm/results/logs/2x25_log.txt
    echo "2x25G Carbon SCP log:" >> /root/Qualcomm/results/logs/2x25_log.txt
    echo "" >> /root/Qualcomm/results/logs/2x25_log.txt
    cat /root/Qualcomm/results/Carbon-dmesg_scp.txt >> /root/Qualcomm/results/logs/2x25_log.txt
    echo "" >> /root/Qualcomm/results/logs/2x25_log.txt
    echo "2x25G Carbon perf log:" >> /root/Qualcomm/results/logs/2x25_log.txt
    echo "" >> /root/Qualcomm/results/logs/2x25_log.txt
    cat /root/Qualcomm/results/Carbon-iperf_test_1.txt >> /root/Qualcomm/results/logs/2x25_log.txt
    cat /root/Qualcomm/results/Carbon-iperf_test_2.txt >> /root/Qualcomm/results/logs/2x25_log.txt

fi

