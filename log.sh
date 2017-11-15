#!/bin/bash

NFP_IP=$1
IP_DUT2=$2

echo $NFP_IP
echo $IP_DUT2

#Where scripts reside
export script_dir="$(dirname $(readlink -f $0))"


cd $script_dir
cd ..

#Where AVL-tests folder reside
export base_dir="$(pwd)"

#CHeck if tested

if [ -f "$base_dir/AVL-tests/results/Beryllium-IPERF10_1" ]; then
    Beryllium="Tested"
else 
    Beryllium="Untested"
fi
if [ -f "$base_dir/AVL-tests/results/Hydrogen-IPERF10_1" ]; then
    Hydrogen="Tested"
else 
    Hydrogen="Untested"
fi
if [ -f "$base_dir/AVL-tests/results/Lithium-IPERF10_1" ]; then
    Lithium="Tested"
else 
    Lithium="Untested"
fi
if [ -f "$base_dir/AVL-tests/results/Carbon-IPERF10_1" ]; then
    Carbon="Tested"
else 
    Carbon="Untested"
fi

#echo "Tested Cards:" >> $base_dir/AVL-tests/results/logs/sys_log.txt
#echo "2x 40G Beryllium: $Beryllium" >> $base_dir/AVL-tests/results/logs/sys_log.txt
#echo "2x 10G Lithium: $Lithium" >> $base_dir/AVL-tests/results/logs/sys_log.txt
#echo "2x 25G Carbon: $Carbon" >> $base_dir/AVL-tests/results/logs/sys_log.txt
#echo "1x 40G Hydrogen: $Hydrogen" >> $base_dir/AVL-tests/results/logs/sys_log.txt

#Get pass fails
#echo "" >> $base_dir/AVL-tests/results/logs/sys_log.txt
#cat $base_dir/AVL-tests/results.txt | sed -r 's/[,]+/\t/g' >> $base_dir/AVL-tests/results/logs/sys_log.txt
#echo "" >> $base_dir/AVL-tests/results/logs/sys_log.txt

# Get system info

echo "Systems" > $base_dir/AVL-tests/results/logs/sys_log.txt
echo "">> $base_dir/AVL-tests/results/logs/sys_log.txt
echo "NFP Device">> $base_dir/AVL-tests/results/logs/sys_log.txt
echo "----------">> $base_dir/AVL-tests/results/logs/sys_log.txt
echo "OS: $(ssh -i ~/.ssh/netronome_key $NFP_IP 'cat /etc/*release | grep ^NAME= | cut -d '=' -f2')" >> $base_dir/AVL-tests/results/logs/sys_log.txt
echo "Kerel: $(ssh -i ~/.ssh/netronome_key $NFP_IP 'uname -r')" >> $base_dir/AVL-tests/results/logs/sys_log.txt
echo "Architechture: $(ssh -i ~/.ssh/netronome_key $NFP_IP 'uname -m')" >> $base_dir/AVL-tests/results/logs/sys_log.txt
echo "">> $base_dir/AVL-tests/results/logs/sys_log.txt
echo "Secondary Device">> $base_dir/AVL-tests/results/logs/sys_log.txt
echo "----------">> $base_dir/AVL-tests/results/logs/sys_log.txt
echo "OS: $(ssh -i ~/.ssh/netronome_key $IP_DUT2 'cat /etc/*release | grep ^NAME= | cut -d '=' -f2')" >> $base_dir/AVL-tests/results/logs/sys_log.txt
echo "Kerel: $(ssh -i ~/.ssh/netronome_key $IP_DUT2 'uname -r')" >> $base_dir/AVL-tests/results/logs/sys_log.txt
echo "Architechture: $(ssh -i ~/.ssh/netronome_key $IP_DUT2 'uname -m')" >> $base_dir/AVL-tests/results/logs/sys_log.txt
echo "" >> $base_dir/AVL-tests/results/logs/sys_log.txt
echo "" >> $base_dir/AVL-tests/results/logs/sys_log.txt

#Beryllium stats
if [[ "$Beryllium" == "Tested" ]]; then
    echo -e "${bold}2x40G - Beryllium:" > $base_dir/AVL-tests/results/logs/2x40_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x40_log.txt
    echo "2x40G Beryllium ethtool log:" >> $base_dir/AVL-tests/results/logs/2x40_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x40_log.txt
    cat $base_dir/AVL-tests/results/Beryllium-ethtool.txt >> $base_dir/AVL-tests/results/logs/2x40_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x40_log.txt
    echo "2x40G Beryllium ISA log:" >> $base_dir/AVL-tests/results/logs/2x40_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x40_log.txt
    cat $base_dir/AVL-tests/results/Beryllium-isa.txt >> $base_dir/AVL-tests/results/logs/2x40_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x40_log.txt
    echo "2x40G Beryllium ping test log:" >> $base_dir/AVL-tests/results/logs/2x40_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x40_log.txt
    cat $base_dir/AVL-tests/results/Beryllium-ping_test_1.txt >> $base_dir/AVL-tests/results/logs/2x40_log.txt
    cat $base_dir/AVL-tests/results/Beryllium-ping_test_2.txt >> $base_dir/AVL-tests/results/logs/2x40_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x40_log.txt
    echo "2x40G Beryllium SSH log:" >> $base_dir/AVL-tests/results/logs/2x40_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x40_log.txt
    cat $base_dir/AVL-tests/results/Beryllium-ssh_test.txt >> $base_dir/AVL-tests/results/logs/2x40_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x40_log.txt
    echo "2x40G Beryllium SCP log:" >> $base_dir/AVL-tests/results/logs/2x40_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x40_log.txt
    cat $base_dir/AVL-tests/results/Beryllium-dmesg_scp.txt >> $base_dir/AVL-tests/results/logs/2x40_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x40_log.txt
    echo "2x40G Beryllium perf log:" >> $base_dir/AVL-tests/results/logs/2x40_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x40_log.txt
    cat $base_dir/AVL-tests/results/Beryllium-IPERF10_1 >> $base_dir/AVL-tests/results/logs/2x40_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x40_log.txt
    cat $base_dir/AVL-tests/results/Beryllium-IPERF11_1 >> $base_dir/AVL-tests/results/logs/2x40_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x40_log.txt
    cat $base_dir/AVL-tests/results/Beryllium-IPERF12_1 >> $base_dir/AVL-tests/results/logs/2x40_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x40_log.txt
    cat $base_dir/AVL-tests/results/Beryllium-IPERF13_1 >> $base_dir/AVL-tests/results/logs/2x40_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x40_log.txt
    cat $base_dir/AVL-tests/results/Beryllium-IPERF10_2 >> $base_dir/AVL-tests/results/logs/2x40_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x40_log.txt
    cat $base_dir/AVL-tests/results/Beryllium-IPERF11_2 >> $base_dir/AVL-tests/results/logs/2x40_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x40_log.txt
    cat $base_dir/AVL-tests/results/Beryllium-IPERF12_2 >> $base_dir/AVL-tests/results/logs/2x40_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x40_log.txt
    cat $base_dir/AVL-tests/results/Beryllium-IPERF13_2 >> $base_dir/AVL-tests/results/logs/2x40_log.txt

fi

#Lithium stats
if [[ "$Lithium" == "Tested" ]]; then
    echo -e "${bold}2x10G - Lithium:" > $base_dir/AVL-tests/results/logs/2x10_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x10_log.txt
    echo "2x10G Lithium ethtool log:" >> $base_dir/AVL-tests/results/logs/2x10_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x10_log.txt
    cat $base_dir/AVL-tests/results/Lithium-ethtool.txt >> $base_dir/AVL-tests/results/logs/2x10_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x10_log.txt
    echo "2x10G Lithium ISA log:" >> $base_dir/AVL-tests/results/logs/2x10_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x10_log.txt
    cat $base_dir/AVL-tests/results/Lithium-isa.txt >> $base_dir/AVL-tests/results/logs/2x10_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x10_log.txt
    echo "2x10G Lithium ping test log:" >> $base_dir/AVL-tests/results/logs/2x10_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x10_log.txt
    cat $base_dir/AVL-tests/results/Lithium-ping_test_1.txt >> $base_dir/AVL-tests/results/logs/2x10_log.txt
    cat $base_dir/AVL-tests/results/Lithium-ping_test_2.txt >> $base_dir/AVL-tests/results/logs/2x10_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x10_log.txt
    echo "2x10G Lithium SSH log:" >> $base_dir/AVL-tests/results/logs/2x10_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x10_log.txt
    cat $base_dir/AVL-tests/results/Lithium-ssh_test.txt >> $base_dir/AVL-tests/results/logs/2x10_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x10_log.txt
    echo "2x10G Lithium SCP log:" >> $base_dir/AVL-tests/results/logs/2x10_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x10_log.txt
    cat $base_dir/AVL-tests/results/Lithium-dmesg_scp.txt >> $base_dir/AVL-tests/results/logs/2x10_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x10_log.txt
    echo "2x10G Lithium perf log:" >> $base_dir/AVL-tests/results/logs/2x10_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x10_log.txt
    cat $base_dir/AVL-tests/results/Lithium-IPERF10_1 >> $base_dir/AVL-tests/results/logs/2x10_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x10_log.txt
    cat $base_dir/AVL-tests/results/Lithium-IPERF11_1 >> $base_dir/AVL-tests/results/logs/2x10_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x10_log.txt
    cat $base_dir/AVL-tests/results/Lithium-IPERF12_1 >> $base_dir/AVL-tests/results/logs/2x10_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x10_log.txt
    cat $base_dir/AVL-tests/results/Lithium-IPERF13_1 >> $base_dir/AVL-tests/results/logs/2x10_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x10_log.txt
    cat $base_dir/AVL-tests/results/Lithium-IPERF10_2 >> $base_dir/AVL-tests/results/logs/2x10_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x10_log.txt
    cat $base_dir/AVL-tests/results/Lithium-IPERF11_2 >> $base_dir/AVL-tests/results/logs/2x10_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x10_log.txt
    cat $base_dir/AVL-tests/results/Lithium-IPERF12_2 >> $base_dir/AVL-tests/results/logs/2x10_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x10_log.txt
    cat $base_dir/AVL-tests/results/Lithium-IPERF13_2 >> $base_dir/AVL-tests/results/logs/2x10_log.txt

fi

#Hydrogen stats
if [[ "$Hydrogen" == "Tested" ]]; then
    echo -e "${bold}1x40G Hydrogen:" > $base_dir/AVL-tests/results/logs/1x40_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/1x40_log.txt
    echo "1x40G Hydrogen ethtool log:" >> $base_dir/AVL-tests/results/logs/1x40_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/1x40_log.txt
    cat $base_dir/AVL-tests/results/Hydrogen-ethtool.txt >> $base_dir/AVL-tests/results/logs/1x40_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/1x40_log.txt
    echo "1x40G Hydrogen ISA log:" >> $base_dir/AVL-tests/results/logs/1x40_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/1x40_log.txt
    cat $base_dir/AVL-tests/results/Hydrogen-isa.txt >> $base_dir/AVL-tests/results/logs/1x40_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/1x40_log.txt
    echo "1x40G Hydrogen ping test log:" >> $base_dir/AVL-tests/results/logs/1x40_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/1x40_log.txt
    cat $base_dir/AVL-tests/results/Hydrogen-ping_test_1.txt >> $base_dir/AVL-tests/results/logs/1x40_log.txt
    cat $base_dir/AVL-tests/results/Hydrogen-ping_test_2.txt >> $base_dir/AVL-tests/results/logs/1x40_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/1x40_log.txt
    echo "1x40G Hydrogen SSH log:" >> $base_dir/AVL-tests/results/logs/1x40_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/1x40_log.txt
    cat $base_dir/AVL-tests/results/Hydrogen-ssh_test.txt >> $base_dir/AVL-tests/results/logs/1x40_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/1x40_log.txt
    echo "1x40G Hydrogen SCP log:" >> $base_dir/AVL-tests/results/logs/1x40_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/1x40_log.txt
    cat $base_dir/AVL-tests/results/Hydrogen-dmesg_scp.txt >> $base_dir/AVL-tests/results/logs/1x40_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/1x40_log.txt
    echo "1x40G Hydrogen perf log:" >> $base_dir/AVL-tests/results/logs/1x40_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/1x40_log.txt
    cat $base_dir/AVL-tests/results/Hydrogen-IPERF10_1 >> $base_dir/AVL-tests/results/logs/1x40_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/1x40_log.txt
    cat $base_dir/AVL-tests/results/Hydrogen-IPERF11_1 >> $base_dir/AVL-tests/results/logs/1x40_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/1x40_log.txt
    cat $base_dir/AVL-tests/results/Hydrogen-IPERF12_1 >> $base_dir/AVL-tests/results/logs/1x40_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/1x40_log.txt
    cat $base_dir/AVL-tests/results/Hydrogen-IPERF13_1 >> $base_dir/AVL-tests/results/logs/1x40_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/1x40_log.txt
    cat $base_dir/AVL-tests/results/Hydrogen-IPERF10_2 >> $base_dir/AVL-tests/results/logs/1x40_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/1x40_log.txt
    cat $base_dir/AVL-tests/results/Hydrogen-IPERF11_2 >> $base_dir/AVL-tests/results/logs/1x40_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/1x40_log.txt
    cat $base_dir/AVL-tests/results/Hydrogen-IPERF12_2 >> $base_dir/AVL-tests/results/logs/1x40_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/1x40_log.txt
    cat $base_dir/AVL-tests/results/Hydrogen-IPERF13_2 >> $base_dir/AVL-tests/results/logs/1x40_log.txt

fi

#Carbon stats
if [[ "$Carbon" == "Tested" ]]; then
    echo -e "${bold}2x25G - Carbon:" > $base_dir/AVL-tests/results/logs/2x25_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x25_log.txt
    echo "2x25G Carbon ethtool log:" >> $base_dir/AVL-tests/results/logs/2x25_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x25_log.txt
    cat $base_dir/AVL-tests/results/Carbon-ethtool.txt >> $base_dir/AVL-tests/results/logs/2x25_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x25_log.txt
    echo "2x25G Carbon ISA log:" >> $base_dir/AVL-tests/results/logs/2x25_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x25_log.txt
    cat $base_dir/AVL-tests/results/Carbon-isa.txt >> $base_dir/AVL-tests/results/logs/2x25_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x25_log.txt
    echo "2x25G Carbon ping test log:" >> $base_dir/AVL-tests/results/logs/2x25_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x25_log.txt
    cat $base_dir/AVL-tests/results/Carbon-ping_test_1.txt >> $base_dir/AVL-tests/results/logs/2x25_log.txt
    cat $base_dir/AVL-tests/results/Carbon-ping_test_2.txt >> $base_dir/AVL-tests/results/logs/2x25_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x25_log.txt
    echo "2x25G Carbon SSH log:" >> $base_dir/AVL-tests/results/logs/2x25_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x25_log.txt
    cat $base_dir/AVL-tests/results/Carbon-ssh_test.txt >> $base_dir/AVL-tests/results/logs/2x25_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x25_log.txt
    echo "2x25G Carbon SCP log:" >> $base_dir/AVL-tests/results/logs/2x25_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x25_log.txt
    cat $base_dir/AVL-tests/results/Carbon-dmesg_scp.txt >> $base_dir/AVL-tests/results/logs/2x25_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x25_log.txt
    echo "2x25G Carbon perf log:" >> $base_dir/AVL-tests/results/logs/2x25_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x25_log.txt
    cat $base_dir/AVL-tests/results/Carbon-IPERF10_1 >> $base_dir/AVL-tests/results/logs/2x25_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x25_log.txt
    cat $base_dir/AVL-tests/results/Carbon-IPERF11_1 >> $base_dir/AVL-tests/results/logs/2x25_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x25_log.txt
    cat $base_dir/AVL-tests/results/Carbon-IPERF12_1 >> $base_dir/AVL-tests/results/logs/2x25_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x25_log.txt
    cat $base_dir/AVL-tests/results/Carbon-IPERF13_1 >> $base_dir/AVL-tests/results/logs/2x25_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x25_log.txt
    cat $base_dir/AVL-tests/results/Carbon-IPERF10_2 >> $base_dir/AVL-tests/results/logs/2x25_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x25_log.txt
    cat $base_dir/AVL-tests/results/Carbon-IPERF11_2 >> $base_dir/AVL-tests/results/logs/2x25_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x25_log.txt
    cat $base_dir/AVL-tests/results/Carbon-IPERF12_2 >> $base_dir/AVL-tests/results/logs/2x25_log.txt
    echo "" >> $base_dir/AVL-tests/results/logs/2x25_log.txt
    cat $base_dir/AVL-tests/results/Carbon-IPERF13_2 >> $base_dir/AVL-tests/results/logs/2x25_log.txt

fi

