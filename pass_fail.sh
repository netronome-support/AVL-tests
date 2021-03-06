#!/bin/bash
#pass_fail.sh

#Where scripts reside
export script_dir="$(dirname $(readlink -f $0))"


cd $script_dir
cd ..

#Where AVL-tests reside
export base_dir="$(pwd)"

#Some colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

cd $base_dir/AVL-tests

CARD=$(cat $base_dir/AVL-tests/results/cur_card.txt)

if [[ $CARD == *"97" ]]; then
    echo "Current card: Beryllium - 2x40GbE"
    CUR_CARD="Beryllium"
    CARD_NAME="2x40G-Beryllium"



elif [[ $CARD == *"81" ]]; then
    echo "Current card: Hydrogen - 1x40GbE"
    CUR_CARD="Hydrogen"
    CARD_NAME="1x40G-Hydrogen"




elif [[ $CARD == *"96" ]]; then
    echo "Current card: Lithium - 2x10GbE"
    CUR_CARD="Lithium"
    CARD_NAME="2x10G-Lithiium"



elif [[ $CARD == *"99" ]]; then
    echo "Current card: Carbon - 2x25GbE"
    CUR_CARD="Carbon"
    CARD_NAME="2x25G-Carbon"

else 
    echo "Current card: None"
    CUR_CARD="None"
    CARD_NAME="None"

fi

echo "Current card: $CUR_CARD"
# ethool
speed=$(cat $base_dir/AVL-tests/results/$CUR_CARD-ethtool.txt | grep Speed: | cut -d ':' -f2 | cut -d ' ' -f2)
#echo $speed

sleep 1

if [[ $CUR_CARD == "Beryllium" ]]; then
    if [[ $speed == "40000Mb/s" ]]; then
        ethtool="pass"
    else
        ethtool="fail"
    fi
elif [[ $CUR_CARD == "Lithium" ]]; then

    if [[ $speed == "10000Mb/s" ]]; then
        ethtool="pass"
    else
        ethtool="fail"
    fi
elif [[ $CUR_CARD == "Hydrogen" ]]; then
    if [[ $speed == "40000Mb/s" ]]; then
        ethtool="pass"
    else
        ethtool="fail"
    fi
elif [[ $CUR_CARD == "Carbon" ]]; then
    if [[ $speed == "25000Mb/s" ]]; then
        ethtool="pass"
    else
        ethtool="fail"
    fi
else 
    ethtool="-"

fi

#ISA

isa_line1=$(cat $base_dir/AVL-tests/results/$CUR_CARD-isa.txt | grep Assembly)
#echo $isa_line1
isa_line2=$(cat $base_dir/AVL-tests/results/$CUR_CARD-isa.txt | grep BSP)
#echo $isa_line2

if [ ! -z "$isa_line1" ] && [ ! -z "$isa_line2" ]; then
    isa="pass"
else 
    isa="fail"
fi



#ping test 

ping_1=$( cat $base_dir/AVL-tests/results/$CUR_CARD-ping_test_1.txt | grep 'packet loss' | cut -d ',' -f 3 | cut -d '%' -f 1)
ping_2=$( cat $base_dir/AVL-tests/results/$CUR_CARD-ping_test_2.txt | grep 'packet loss' | cut -d ',' -f 3 | cut -d '%' -f 1)

#echo $ping_1
#echo $ping_2

if [[ $ping_1 -gt 0 ]]; then
    ping="fail"
else 
    if [[ $ping_2 -gt 0 ]]; then
        ping="fail"
    else 
        ping="pass"
    fi
fi

#echo "PING $ping"

#ssh test
ssh_line=$(cat $base_dir/AVL-tests/results/$CUR_CARD-ssh_test.txt)
#echo $ssh_line

if [[ -z "$ssh_line" ]]; then
    ssh="fail"
else
    ssh="pass"
fi

#scp tesst

scp_line=$(cat $base_dir/AVL-tests/results/$CUR_CARD-dmesg_scp.txt)

if [[ -z "$scp_line" ]]; then
    scp="fail"
else
    scp="pass"
fi




#perf test

one1=$(cat $base_dir/AVL-tests/results/$CUR_CARD-IPERF10_1 | grep SUM | sed '$!d' | sed 's/^.*GBytes //' | cut -d 'G' -f1)
one2=$(cat $base_dir/AVL-tests/results/$CUR_CARD-IPERF11_1 | grep SUM | sed '$!d' | sed 's/^.*GBytes //' | cut -d 'G' -f1)
one3=$(cat $base_dir/AVL-tests/results/$CUR_CARD-IPERF12_1 | grep SUM | sed '$!d' | sed 's/^.*GBytes //' | cut -d 'G' -f1)
one4=$(cat $base_dir/AVL-tests/results/$CUR_CARD-IPERF13_1 | grep SUM | sed '$!d' | sed 's/^.*GBytes //' | cut -d 'G' -f1)

one_a=$(echo "($one1 + $one2 + $one3 + $one4)" | bc -l)

two1=$(cat $base_dir/AVL-tests/results/$CUR_CARD-IPERF10_2 | grep SUM | sed '$!d' | sed 's/^.*GBytes //' | cut -d 'G' -f1)
two2=$(cat $base_dir/AVL-tests/results/$CUR_CARD-IPERF11_2 | grep SUM | sed '$!d' | sed 's/^.*GBytes //' | cut -d 'G' -f1)
two3=$(cat $base_dir/AVL-tests/results/$CUR_CARD-IPERF12_2 | grep SUM | sed '$!d' | sed 's/^.*GBytes //' | cut -d 'G' -f1)
two4=$(cat $base_dir/AVL-tests/results/$CUR_CARD-IPERF13_2 | grep SUM | sed '$!d' | sed 's/^.*GBytes //' | cut -d 'G' -f1)

two_a=$(echo "($two1 + $two2 + $two3 + $two4)" | bc -l )

echo "Speed ARM -> DUT2 : $one_a" > $base_dir/AVL-tests/results/logs/$CUR_CARD-iperf_test_summary.txt
echo "Speed DUT2 -> ARM : $two_a" >> $base_dir/AVL-tests/results/logs/$CUR_CARD-iperf_test_summary.txt

#Limit for pass/fail is set to 40% line rate
if [[ $CUR_CARD == "Beryllium" ]]; then
    if [[ $(echo $one_a'>'16 | bc -l) -eq 1 ]] && [[ $(echo $two_a'>'16 | bc -l) -eq 1 ]] ; then
        perf="pass"
        
    else
        perf="fail"
        
    fi
elif [[ $CUR_CARD == "Lithium" ]]; then
    if [[ $(echo $one_a'>'4 | bc -l) -eq 1 ]] && [[ $(echo $two_a'>'4 | bc -l) -eq 1 ]] ; then
        perf="pass"
    else
        perf="fail"
    fi
elif [[ $CUR_CARD == "Hydrogen" ]]; then
    if [[ $(echo $one_a'>'16 | bc -l) -eq 1 ]] && [[ $(echo $two_a'>'16 | bc -l) -eq 1 ]] ; then
        perf="pass"
    else
        perf="fail"
    fi
elif [[ $CUR_CARD == "Carbon" ]]; then
    if [[ $(echo $one_a'>'10 | bc -l) -eq 1 ]] && [[ $(echo $two_a'>'10 | bc -l) -eq 1 ]] ; then
        perf="pass"
    else
        perf="fail"
    fi
fi


if [ -z $(cat $base_dir/AVL-tests/results/logs/results.txt | sed -n 1p) ]; then
    echo "Netronome card,Ethool,ISA,PING,SSH,SCP,IPERF" > $base_dir/AVL-tests/results/logs/results.txt
fi

if [[ "$CARD_NAME" != "None" ]]; then
    sed -i "/$CARD_NAME/d" $base_dir/AVL-tests/results/logs/results.txt
    echo "$CARD_NAME,$ethtool,$isa,$ping,$ssh,$scp,$perf" >> $base_dir/AVL-tests/results/logs/results.txt
else
    echo -e "None,${RED}Card not identified correctly${NC}" >> $base_dir/AVL-tests/results/logs/results.txt
fi


echo "p_done"

exit 0