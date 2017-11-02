#!/bin/bash

SESSIONNAME=Qualcomm
script_dir="$(dirname $(readlink -f $0))"


#Check if TMUX is installed
grep ID_LIKE /etc/os-release | grep -q debian
if [[ $? -eq 0 ]]; then
apt-get install -y tmux
fi

grep  ID_LIKE /etc/os-release | grep -q fedora
if [[ $? -eq 0 ]]; then
yum -y install tmux
fi

#Some colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color


#Pause TMUX function
function wait_text {
    local pane="$1"
    local text="$2"
    if [ "$pane" == "ALL" ]; then
        wait_text 2 "$text" || exit -1
        wait_text 3 "$text" || exit -1
        return 0
    fi
    while :; do
        tmux capture-pane -t "$pane" -p \
            | grep "$text" > /dev/null \
            && return 0
        sleep 0.25
    done
    # never executed unless a timeout mechanism is implemented
    return -1
}

sshopts=()
sshopts+=( "-i" "$HOME/.ssh/netronome_key" )
sshopts+=( "-q" )
sshcmd="ssh ${sshopts[@]}"

function rsync_duts {
    local dirlist="$@"
    ropts=()
    ropts+=( "-e" "$sshcmd -l root" )
    for ipaddr in $IP_ARM $IP_DUT2 ; do
        rsync "${ropts[@]}" -a $dirlist $ipaddr:Qual_folder \
            || return -1
    done
    return 0
}


#######################################################################
######################### Main function ###############################
#######################################################################

# Check if TMUX variable is defined.
if [ -z "$TMUX" ]
then # $TMUX is empty, create/enter tmux session.
    tmux has-session -t $SESSIONNAME &> /dev/null
    if [ $? != 0 ]
    then
       # create session, window 0, and detach
        tmux new-session -s $SESSIONNAME -d
        tmux rename-window -t $SESSIONNAME:0 main-window
        # configure window
        tmux select-window -t $SESSIONNAME:0
        tmux split-window -h -t 0
        tmux split-window -v -t 0
        tmux split-window -v -t 1
    fi
    tmux send-keys -t 0 './qualcomm.sh' C-m
    tmux a -t $SESSIONNAME 
else # else $TMUX is not empty, start test.

    CARD_NAME="None"
    # Recreate all panes
    if [ $(tmux list-panes | wc -l) -gt 1 ] 
    then
        tmux kill-pane -a -t $SESSIONNAME":0.0"
    fi
        tmux split-window -h -t 0
        tmux split-window -v -t 0
        tmux split-window -v -t 1
        DUT_CONNECT=0

    while :; do
        tmux select-pane -t 0
        clear
        echo "Current card detected: $CARD_NAME"
        echo ""
        echo "Please choose a option"
        echo ""
        echo "h) HOW TO SETUP SECONDARY DEVICE"
        echo ""
        echo "a) Connect to DUT's"
        echo "b) Install CoreNIC"
        echo "c) Determine card"
        echo "1) Ethtool"
        echo "2) ISA info"
        echo "3) Ping test"
        echo "4) SSH test"
        echo "5) SCP test"
        echo "6) Iperf test"
        echo "7) Auto run tests & process results"
        echo "p) Generate current card results"
        echo "l) Generate logs to export to results spreadsheet"
        echo "r) Reboot host machines"
        echo "x) Exit"
        echo ""
        read -p "Enter choice: " OPT
        case "$OPT" in

        h)  echo ""
            echo "HOW TO SETUP SECONDARY DEVICE"
            echo "-----------------------------"
            echo "1) Please ensure that there is a management interface to the secondary device."
            echo "2) Please configure the port used to connect to the ARM (back-to-back) with an IP."
            echo "3) Pass both IPs to the script when connecting."
            echo ""
            sleep 10
            ;;
        
        a)  echo "a) Connect to DUT's"
            
            #Get IP's of DUT's
            read -p "Enter management IP of ARM DUT: " IP_ARM
            read -p "Enter management IP of secondary device: " IP_DUT2
            read -p "Enter secondary device back-to-back connection interface IP: " INTERFACE_IP

            #Copy n new public key to DUT's
            /root/AVL-tests/copy_ssh_key.sh $IP_ARM $IP_DUT2

            sleep 2

            tmux send-keys -t 2 "/root/AVL-tests/copy_ssh_key.sh $IP_DUT2" C-m
            tmux send-keys -t 3 "/root/AVL-tests/copy_ssh_key.sh $IP_ARM" C-m            
            
            sleep 2
            
            tmux send-keys -t 2 "cd" C-m
            tmux send-keys -t 3 "cd" C-m

            tmux send-keys -t 2 "rm -r Qualcomm" C-m
            tmux send-keys -t 3 "rm -r Qualcomm" C-m

            tmux send-keys -t 2 "mkdir -p Qualcomm" C-m
            tmux send-keys -t 3 "mkdir -p Qualcomm" C-m

            tmux send-keys -t 2 "cd Qualcomm" C-m
            tmux send-keys -t 3 "cd Qualcomm" C-m

            tmux send-keys -t 2 "mkdir -p results" C-m
            tmux send-keys -t 3 "mkdir -p results" C-m

            tmux send-keys -t 2 "cd results" C-m
            tmux send-keys -t 3 "cd results" C-m

            tmux send-keys -t 2 "mkdir -p logs" C-m
            tmux send-keys -t 3 "mkdir -p logs" C-m

            mkdir /root/AVL-tests/results
            mkdir /root/AVL-tests/results/logs

            sleep 1

            scp -i ~/.ssh/netronome_key -r /root/AVL-tests/ root@$IP_ARM:/root/
            scp -i ~/.ssh/netronome_key -r /root/AVL-tests/ root@$IP_DUT2:/root/

            sleep 1

            #SSH into DUT's
            tmux send-keys -t 2 "ssh -i ~/.ssh/netronome_key root@$IP_ARM" C-m
            tmux send-keys -t 3 "ssh -i ~/.ssh/netronome_key root@$IP_DUT2" C-m

            sleep 1
            
            DUT_CONNECT=1

            sleep 1
            
            grep ID_LIKE /etc/os-release | grep -q debian
            if [[ $? -eq 0 ]]; then
                apt-get -y install iperf3
            fi

            grep ID_LIKE /etc/os-release | grep -q fedora
            if [[ $? -eq 0 ]]; then
                yum -y install iperf3
            fi

            sleep 1

            ;;


        b)  echo "b) Install CoreNIC"

            if [ $DUT_CONNECT == 0 ]; then
                echo "Please connect to DUT's first"
                sleep 5
                continue
            fi

            #tmux send-keys -t 2 "/opt/netronome/bin/agilio-ovs-uninstall.sh"
            #tmux send-keys -t 2 "apt-get remove nfp-bsp.* ; apt-get remove ns-agilio-core-nic"

            cd

            #ls nfp-bsp-6000* 2>/dev/null

            #if [ $? == 2 ]; then
            #    echo -e "${RED}Please copy NFP BSP package to /root directory of this machine${NC}"
            #    echo ""
            #    echo "The packages can be downloaded from support.netronome.com"
            #    echo ""
            #fi

            ls ns-agilio-core-nic* 2>/dev/null

            if [ $? == 2 ]; then
                echo -e "${RED}Please copy CoreNIC 1.1 package to /root directory of this machine${NC}"
                echo ""
                echo "The packages can be downloaded from support.netronome.com"
                echo ""
            fi

            ls nfp-bsp-6000-b0-20171005160457.ns.aarch64.tgz 2>/dev/null

            if [ $? == 2 ]; then
                echo -e "${RED}Please copy the BSP package to /root directory of this machine${NC}"
                echo ""
                echo "The package will be supplied by Netronome"
                echo "nfp-bsp-6000-b0-20171005160457.ns.aarch64.tgz"
            fi

            ls agilio-ovs-2.6.B-r5952-2017-10-05.tar.gz 2>/dev/null

            if [ $? == 2 ]; then
                echo -e "${RED}Please copy the AOVS package to /root directory of this machine${NC}"
                echo ""
                echo "The package will be supplied by Netronome"
                echo "agilio-ovs-2.6.B-r5952-2017-10-05.tar.gz"
            fi

            scp -i ~/.ssh/netronome_key nfp-bsp-6000-b0-20171005160457.ns.aarch64.tgz root@$IP_ARM:/root/
            scp -i ~/.ssh/netronome_key agilio-ovs-2.6.B-r5952-2017-10-05.tar.gz root@$IP_ARM:/root/
            scp -i ~/.ssh/netronome_key ns-agilio-core-nic*.* root@$IP_ARM:/root/

            tmux send-keys -t 2 "/root/AVL-tests/package_install.sh" C-m

            wait_text 2 "DONE(package_install.sh)"

            tmux send-keys -t 2 "/root/AVL-tests/build_dpdk.sh" C-m

            wait_text 2 "DPDK build complete"

            sleep 3

            echo "Please reboot machine"


            ;;


        c)  echo "c) Determine card)"
            
            if [ $DUT_CONNECT == 0 ]; then
                echo "Please connect to DUT's first"
                sleep 5
                continue
            fi

            tmux send-keys -t 2 "clear" C-m
            sleep 1
            tmux send-keys -t 2 "lsmod | grep nfp" C-m
            sleep 1
            nfp_install=$(tmux capture-pane -t 2 -p | grep nfp | tail -n +2)

            if [ -z "$nfp_install" ]; then
                echo "Please install CoreNIC package first"
                sleep 3
            else


                tmux send-keys -t 2 "dmesg | grep 'nfp .* Assembly' | sed -n 1p | cut -d ':' -f5 | cut -d '-' -f1 | cut -d ' ' -f2 > /root/AVL-tests/results/cur_card.txt" C-m
                sleep 1
                scp -i ~/.ssh/netronome_key root@$IP_ARM:/root/AVL-tests/results/cur_card.txt /root/AVL-tests/results 

                CARD=$(cat /root/AVL-tests/results/cur_card.txt)

                if [[ $CARD == *"97" ]]; then
                    echo "Current card: Beryllium - 2x40GbE"
                    CARD_NAME="Beryllium - 2x40GbE"
                    CUR_CARD="Beryllium" 
                elif [[ $CARD == *"81" ]]; then
                    echo "Current card: Hydrogen - 1x40GbE"
                    CARD_NAME="Hydrogen - 1x40GbE"
                    CUR_CARD="Hydrogen"
                elif [[ $CARD == *"96" ]]; then
                    echo "Current card: Lithium - 2x10GbE"
                    CARD_NAME="Lithium - 2x10GbE"
                    CUR_CARD="Lithium"
                elif [[ $CARD == *"99" ]]; then
                    echo "Current card: Carbon - 2x25GbE"
                    CARD_NAME="Carbon - 2x25GbE"
                    CUR_CARD="Carbon"
                else 
                    echo "Current card: NO CARD DETECTED"
                    CUR_CARD="None"
                fi

                echo ""
                echo "$CUR_CARD"

                sleep 1
            fi

            
 
            ;;
        
        1)  echo "1) Ethtool test"
            
            if [ $DUT_CONNECT == 0 ]; then
                echo "Please connect to DUT's first"
                sleep 5
                continue
            fi

            tmux send-keys -t 2 "ip l set nfp_p0 up" C-m

            tmux send-keys -t 2 "cd" C-m

            tmux send-keys -t 2 "ethtool nfp_p0 > /root/AVL-tests/results/$CUR_CARD-ethtool.txt" C-m
            sleep 2

            scp -i ~/.ssh/netronome_key root@$IP_ARM:/root/AVL-tests/results/$CUR_CARD-ethtool.txt /root/AVL-tests/results

            sleep 1

            echo "1_done"

        ;;
            
            

        2)  echo "ISA info"
            
            if [ $DUT_CONNECT == 0 ]; then
                echo "Please connect to DUT's first"
                sleep 5
                continue
            fi
            
                tmux send-keys -t 2 "dmesg | grep 'Assembly\|BSP' > /root/AVL-tests/results/$CUR_CARD-isa.txt" C-m
                sleep 2
                scp -i ~/.ssh/netronome_key root@$IP_ARM:/root/AVL-tests/results/$CUR_CARD-isa.txt /root/AVL-tests/results
                sleep 1
                echo "2_done"
            
           ;;

        3)  echo "3) Ping test"

            
            
           if [ $DUT_CONNECT == 0 ]; then
                echo "Please connect to DUT's first"
                sleep 5
                continue
            fi

            PING_TEST=1
            
            baseaddr="$(echo $INTERFACE_IP | cut -d. -f1-3)"
            lsv="$(echo $INTERFACE_IP | cut -d. -f4)"
            new_value=$(( $lsv + 1))

            INTERFACE_NFP=("$baseaddr.$new_value")


            DUT2_INT=$(ssh -i ~/.ssh/netronome_key $IP_DUT2 ip a | grep "$INTERFACE_IP" -B 3 | grep mtu | cut -d ' ' -f2 | cut -d ':' -f1)
            echo "Device 2 interface : $DUT2_INT" 

            sleep 1

            tmux send-keys -t 3 "ifconfig $DUT2_INT mtu 9000" C-m
            tmux send-keys -t 3 "ip link set $DUT2_INT up" C-m
            

            tmux send-keys -t 2 "cd" C-m

            tmux send-keys -t 2 "/root/AVL-tests/ping_test.sh $INTERFACE_NFP" C-m
            
            echo -e "${GREEN}* Setting up ping test${NC}"
            
            wait_text 2 "DONE(ping_test.sh)"

            echo -e "${GREEN}* Running test case 1 - Simple ping${NC}"
            
            


            tmux send-keys -t 2 "ping $INTERFACE_IP -c 6 | tee /root/AVL-tests/results/$CUR_CARD-ping_test_1.txt" C-m

            wait_text 2 "ping statistics"

            sleep 1

            scp -i ~/.ssh/netronome_key root@$IP_ARM:/root/AVL-tests/results/$CUR_CARD-ping_test_1.txt /root/AVL-tests/results

            sleep 1

            tmux send-keys -t 3 "ping $INTERFACE_NFP -c 6 | tee /root/AVL-tests/results/$CUR_CARD-ping_test_2.txt" C-m

            wait_text 3 "ping statistics"

            sleep 1

            scp -i ~/.ssh/netronome_key root@$IP_DUT2:/root/AVL-tests/results/$CUR_CARD-ping_test_2.txt /root/AVL-tests/results


            echo "Ping test complete"

            sleep 2

            echo "3_done"

        
            ;;

        4) echo "4) SSH test"

            if [ $DUT_CONNECT == 0 ]; then
                echo "Please connect to DUT's first"
                sleep 5
                continue
            fi            
            
            #ssh from 2nd DUT to nfp
            tmux send-keys -t 3 "ssh -i ~/.ssh/netronome_key $INTERFACE_NFP 'dmesg | grep Assembly' > /root/AVL-tests/results/$CUR_CARD-ssh_test.txt" C-m

            sleep 2

            scp -i ~/.ssh/netronome_key root@$IP_DUT2:/root/AVL-tests/results/$CUR_CARD-ssh_test.txt /root/AVL-tests/results

            sleep 1

            echo "4_done"


            ;;

        5) echo "5) SCP test"

            if [ $DUT_CONNECT == 0 ]; then
                echo "Please connect to DUT's first"
                sleep 5
                continue
            fi
            
            tmux send-keys -t 2 "dmesg | grep Assembly > /root/AVL-tests/results/$CUR_CARD-dmesg_scp.txt" C-m

            #scp from 2nd Dut to nfp

            tmux send-keys -t 3 "scp -i ~/.ssh/netronome_key $INTERFACE_NFP:/root/AVL-tests/results/$CUR_CARD-dmesg_scp.txt /root/AVL-tests/results" C-m

            sleep 2

            scp -i ~/.ssh/netronome_key root@$IP_DUT2:/root/AVL-tests/results/$CUR_CARD-dmesg_scp.txt /root/AVL-tests/results/

            sleep 1

            echo "5_done"

            ;;

        6) echo "6) Performance test"

            if [ $DUT_CONNECT == 0 ]; then
                echo "Please connect to DUT's first"
                sleep 5
                continue
            fi

            DUT2_INT=$(ssh -i ~/.ssh/netronome_key $IP_DUT2 ip a | grep $INTERFACE_IP -B 3 | grep mtu | cut -d ' ' -f2 | cut -d ':' -f1)
            echo "Device 2 interface : $DUT2_INT"

            tmux send-keys -t 3 "ifconfig $DUT2_INT mtu 9000" C-m

            #OLD Commands
            #tmux send-keys -t 2 "iperf -c $INTERFACE_IP -w 2m -l 64k -i 10 -t 30 -P 4 -m | tee /root/AVL-tests/results/$CUR_CARD-iperf_test_1.txt" C-m
            #tmux send-keys -t 3 "iperf -s" C-m

            tmux send-keys -t 2 "cd /root/AVL-tests/results" C-m
            tmux send-keys -t 3 "cd /root/AVL-tests/results" C-m

            tmux send-keys -t 3 "iperf3 -s -p10 & iperf3 -s -p11 & iperf3 -s -p12 & iperf3 -s -p13 &" C-m
            sleep 1
            
            tmus send-keys -t 2 "iperf3 -A 0 -c $INTERFACE_IP -P 6 -t 30 -i 30 -p 10 > $CUR_CARD-IPERF10_1 & iperf3 -A 1 -c $INTERFACE_IP -P 6 -t 30 -i 30 -p 11 > $CUR_CARD-IPERF11_1 & iperf3 -A 2 -c $INTERFACE_IP -P 6 -t 30 -i 30 -p 12 > $CUR_CARD-IPERF12_1 & iperf3 -A 3 -c $INTERFACE_IP -P 6 -t 30 -i 30 -p 13 > $CUR_CARD-IPERF13_1 &" C-m
            sleep 40

            tmux send-keys -t 3 "^C" C-m
            sleep 1

            scp -i ~/.ssh/netronome_key root@$IP_ARM:/root/AVL-tests/results/$CUR_CARD-IPERF* /root/AVL-tests/results

            sleep 5


            tmux send-keys -t 2 "iperf3 -s -p10 & iperf3 -s -p11 & iperf3 -s -p12 & iperf3 -s -p13 &" C-m
            sleep 1
            tmus send-keys -t 2 "iperf3 -A 0 -c $INTERFACE_NFP -P 6 -t 30 -i 30 -p 10 > $CUR_CARD-IPERF10_2 & iperf3 -A 1 -c $INTERFACE_NFP -P 6 -t 30 -i 30 -p 11 > $CUR_CARD-IPERF11_2 & iperf3 -A 2 -c $INTERFACE_NFP -P 6 -t 30 -i 30 -p 12 > $CUR_CARD-IPERF12_2 & iperf3 -A 3 -c $INTERFACE_NFP -P 6 -t 30 -i 30 -p 13 > $CUR_CARD-IPERF13_2 &" C-m

            sleep 40

            tmux send-keys -t 2 "^C" C-m
            sleep 1

            scp -i ~/.ssh/netronome_key root@$IP_DUT2:/root/AVL-tests/results/$CUR_CARD-IPERF* /root/AVL-tests/results

            sleep 2

            echo "6_done"

            sleep 2

            ;;

        7)  echo "7) Auto-run tests"

            if [ $DUT_CONNECT == 0 ]; then
                echo "Please connect to DUT's first"
                sleep 5
                continue
            fi
            sleep 1

            #------------------------------------------------------------
            #   c) Determine Card
            #------------------------------------------------------------
            
            echo "Determine Card"
            sleep 1
            tmux send-keys -t 2 "clear" C-m
            sleep 1
            tmux send-keys -t 2 "lsmod | grep nfp" C-m
            sleep 1
            nfp_install=$(tmux capture-pane -t 2 -p | grep nfp | tail -n +2)

            if [ -z "$nfp_install" ]; then
                echo "Please install CoreNIC package first"
                sleep 3
            else
                tmux send-keys -t 2 "dmesg | grep 'nfp .* Assembly' | sed -n 1p | cut -d ':' -f5 | cut -d '-' -f1 | cut -d ' ' -f2 > /root/AVL-tests/results/cur_card.txt" C-m
                sleep 1
                scp -i ~/.ssh/netronome_key root@$IP_ARM:/root/AVL-tests/results/cur_card.txt /root/AVL-tests/results 

                CARD=$(cat /root/AVL-tests/results/cur_card.txt)

                if [[ $CARD == *"97" ]]; then
                    echo "Current card: Beryllium - 2x40GbE"
                    CARD_NAME="Beryllium - 2x40GbE"
                    CUR_CARD="Beryllium" 
                elif [[ $CARD == *"81" ]]; then
                    echo "Current card: Hydrogen - 1x40GbE"
                    CARD_NAME="Hydrogen - 1x40GbE"
                    CUR_CARD="Hydrogen"
                elif [[ $CARD == *"96" ]]; then
                    echo "Current card: Lithium - 2x10GbE"
                    CARD_NAME="Lithium - 2x10GbE"
                    CUR_CARD="Lithium"
                elif [[ $CARD == *"99" ]]; then
                    echo "Current card: Carbon - 2x25GbE"
                    CARD_NAME="Carbon - 2x25GbE"
                    CUR_CARD="Carbon"
                else 
                    echo "Current card: NO CARD DETECTED"
                    CUR_CARD="None"
                fi
                sleep 1
            fi

            echo "c_done"

            sleep 1

            #-------------------------------------------------------------
            #   1) Ethtool test
            #-------------------------------------------------------------

            echo "1) Ethtool test"


            tmux send-keys -t 2 "ip l set nfp_p0 up" C-m

            tmux send-keys -t 2 "cd" C-m

            tmux send-keys -t 2 "ethtool nfp_p0 > /root/AVL-tests/results/$CUR_CARD-ethtool.txt" C-m
            sleep 2
            scp -i ~/.ssh/netronome_key root@$IP_ARM:/root/AVL-tests/results/$CUR_CARD-ethtool.txt /root/AVL-tests/results
            sleep 1
            
            echo "1_done"

            #-------------------------------------------------------------
            #   2) ISA info test
            #-------------------------------------------------------------

            echo "ISA info"
            
            if [ $DUT_CONNECT == 0 ]; then
                echo "Please connect to DUT's first"
                sleep 5
                continue
            fi
            
                tmux send-keys -t 2 "dmesg | grep 'Assembly\|BSP' > /root/AVL-tests/results/$CUR_CARD-isa.txt" C-m
                sleep 2
                scp -i ~/.ssh/netronome_key root@$IP_ARM:/root/AVL-tests/results/$CUR_CARD-isa.txt /root/AVL-tests/results
                sleep 1
                echo "2_done"

            #-------------------------------------------------------------
            #   3) Ping test
            #-------------------------------------------------------------
            sleep 1
            echo "Ping test" 
            sleep 1

            PING_TEST=1
            
            baseaddr="$(echo $INTERFACE_IP | cut -d. -f1-3)"
            lsv="$(echo $INTERFACE_IP | cut -d. -f4)"
            new_value=$(( $lsv + 1))

            INTERFACE_NFP=("$baseaddr.$new_value")


            DUT2_INT=$(ssh -i ~/.ssh/netronome_key $IP_DUT2 ip a | grep "$INTERFACE_IP" -B 3 | grep mtu | cut -d ' ' -f2 | cut -d ':' -f1)
            echo "Device 2 interface : $DUT2_INT" 

            tmux send-keys -t 3 "ifconfig $DUT2_INT mtu 9000" C-m

            tmux send-keys -t 2 "cd" C-m

            tmux send-keys -t 2 "/root/AVL-tests/ping_test.sh $INTERFACE_NFP" C-m
            
            echo -e "${GREEN}* Setting up ping test${NC}"
            
            wait_text 2 "DONE(ping_test.sh)"

            echo -e "${GREEN}* Running test case 1 - Simple ping${NC}"

            tmux send-keys -t 2 "ping $INTERFACE_IP -c 6 | tee /root/AVL-tests/results/$CUR_CARD-ping_test_1.txt" C-m

            wait_text 2 "ping statistics"

            sleep 1

            scp -i ~/.ssh/netronome_key root@$IP_ARM:/root/AVL-tests/results/$CUR_CARD-ping_test_1.txt /root/AVL-tests/results

            sleep 1

            tmux send-keys -t 3 "ping $INTERFACE_NFP -c 6 | tee /root/AVL-tests/results/$CUR_CARD-ping_test_2.txt" C-m

            wait_text 3 "ping statistics"

            sleep 1

            scp -i ~/.ssh/netronome_key root@$IP_DUT2:/root/AVL-tests/results/$CUR_CARD-ping_test_2.txt /root/AVL-tests/results


            echo "Ping test complete"

            sleep 2

            echo "3_done"

            sleep 1

            #-------------------------------------------------------------
            #   4) SSH test
            #-------------------------------------------------------------

            echo "4) SSH test"

            sleep 1

            #ssh from 2nd DUT to nfp
            tmux send-keys -t 3 "ssh -i ~/.ssh/netronome_key $INTERFACE_NFP 'dmesg | grep Assembly' > /root/AVL-tests/results/$CUR_CARD-ssh_test.txt" C-m

            sleep 2

            scp -i ~/.ssh/netronome_key root@$IP_DUT2:/root/AVL-tests/results/$CUR_CARD-ssh_test.txt /root/AVL-tests/results

            sleep 1

            echo "4_done"

            #-------------------------------------------------------------
            #   5) SCP test
            #-------------------------------------------------------------

            echo "5) SCP test"
            
            tmux send-keys -t 2 "dmesg | grep Assembly > /root/AVL-tests/results/$CUR_CARD-dmesg_scp.txt" C-m

            #scp from 2nd Dut to nfp

            tmux send-keys -t 3 "scp -i ~/.ssh/netronome_key $INTERFACE_NFP:/root/AVL-tests/results/$CUR_CARD-dmesg_scp.txt /root/AVL-tests/results/" C-m

            sleep 2

            scp -i ~/.ssh/netronome_key root@$IP_DUT2:/root/AVL-tests/results/$CUR_CARD-dmesg_scp.txt /root/AVL-tests/results/

            sleep 1

            echo "5_done"

            sleep 1

            #-------------------------------------------------------------
            #   6) Perf test
            #-------------------------------------------------------------

            echo "6) Performance test"

           DUT2_INT=$(ssh -i ~/.ssh/netronome_key $IP_DUT2 ip a | grep $INTERFACE_IP -B 3 | grep mtu | cut -d ' ' -f2 | cut -d ':' -f1)
            echo "Device 2 interface : $DUT2_INT"

            tmux send-keys -t 3 "ifconfig $DUT2_INT mtu 9000" C-m

            #OLD Commands
            #tmux send-keys -t 2 "iperf -c $INTERFACE_IP -w 2m -l 64k -i 10 -t 30 -P 4 -m | tee /root/AVL-tests/results/$CUR_CARD-iperf_test_1.txt" C-m
            #tmux send-keys -t 3 "iperf -s" C-m

            tmux send-keys -t 2 "cd /root/AVL-tests/results" C-m
            tmux send-keys -t 3 "cd /root/AVL-tests/results" C-m

            tmux send-keys -t 3 "iperf3 -s -p10 & iperf3 -s -p11 & iperf3 -s -p12 & iperf3 -s -p13 &" C-m
            sleep 1
            
            tmus send-keys -t 2 "iperf3 -A 0 -c $INTERFACE_IP -P 6 -t 30 -i 30 -p 10 > $CUR_CARD-IPERF10_1 & iperf3 -A 1 -c $INTERFACE_IP -P 6 -t 30 -i 30 -p 11 > $CUR_CARD-IPERF11_1 & iperf3 -A 2 -c $INTERFACE_IP -P 6 -t 30 -i 30 -p 12 > $CUR_CARD-IPERF12_1 & iperf3 -A 3 -c $INTERFACE_IP -P 6 -t 30 -i 30 -p 13 > $CUR_CARD-IPERF13_1 &" C-m
            sleep 40

            tmux send-keys -t 3 "^C" C-m
            sleep 1

            scp -i ~/.ssh/netronome_key root@$IP_ARM:/root/AVL-tests/results/$CUR_CARD-IPERF* /root/AVL-tests/results

            sleep 5


            tmux send-keys -t 2 "iperf3 -s -p10 & iperf3 -s -p11 & iperf3 -s -p12 & iperf3 -s -p13 &" C-m
            sleep 1
            tmus send-keys -t 2 "iperf3 -A 0 -c $INTERFACE_NFP -P 6 -t 30 -i 30 -p 10 > $CUR_CARD-IPERF10_2 & iperf3 -A 1 -c $INTERFACE_NFP -P 6 -t 30 -i 30 -p 11 > $CUR_CARD-IPERF11_2 & iperf3 -A 2 -c $INTERFACE_NFP -P 6 -t 30 -i 30 -p 12 > $CUR_CARD-IPERF12_2 & iperf3 -A 3 -c $INTERFACE_NFP -P 6 -t 30 -i 30 -p 13 > $CUR_CARD-IPERF13_2 &" C-m

            sleep 40

            tmux send-keys -t 2 "^C" C-m
            sleep 1

            scp -i ~/.ssh/netronome_key root@$IP_DUT2:/root/AVL-tests/results/$CUR_CARD-IPERF* /root/AVL-tests/results

            sleep 2

            echo "6_done"

            sleep 2

            #-------------------------------------------------------------
            #   p) Show Results
            #-------------------------------------------------------------
            /root/AVL-tests/pass_fail.sh

            sleep 1

            clear
            echo ""
            echo ""
            cat /root/AVL-tests/results/logs/results.txt | sed -r 's/[,]+/\t/g'
            echo ""
            echo ""
            echo "$CUR_CARD done"
            echo "Please place next card in device"

            sleep 10

            sed -i '/None/d' /root/AVL-tests/results/logs/results.txt

            ;;

        p)  echo "p) Process Results"
            
            sleep 1

            /root/AVL-tests/pass_fail.sh

            sleep 1

            wait_text 0 "p_done"

            clear
            echo ""
            echo ""
            cat /root/AVL-tests/results/logs/results.txt | sed -r 's/[,]+/\t/g'

            sleep 10

            sed -i '/None/d' /root/AVL-tests/results/logs/results.txt


            ;;

        l) echo "Create Logs"

            if [ $DUT_CONNECT == 0 ]; then
                echo "Please connect to DUT's first"
                sleep 5
                continue
            fi
            
            /root/AVL-tests/log.sh $IP_ARM $IP_DUT2
            sleep 2

            echo ""
            echo ""
            echo "PLEASE FIND RESULTS IN /root/AVL-tests/results/logs/"
            echo "Import them as decribed in the Results spreadsheet provided."
            echo ""
            sleep 5
            ;;

        r)  echo "r) Reboot host machines"
            
            if [ $DUT_CONNECT == 0 ]; then
                echo "Please connect to DUT's first"
                sleep 5
                continue
            fi

            read -p "Are you sure you want to reboot DUT's (y/n): " REBOOT_ANS

            if [ $REBOOT_ANS == 'y' ]; then
                echo "Rebooting DUT's"
                tmux send-keys -t 2 "reboot" C-m
                tmux send-keys -t 3 "reboot" C-m

            #Code if running from orch

            sleep 10

            echo -e "${GREEN}Adding 5 min sleep while DUT's reboot${NC}"
            counter=0
            while [ $counter -lt 30 ];
            do
                sleep 10
                counter=$((counter+1))
                echo "counter: $counter"
                ip=$IP_ARM
                echo "ip: $ip"
                if [ ! -z "$ip" ]; then
                    nc -w 2 -v $ip 22 </dev/null
                    if [ $? -eq 0 ]; then
                        counter=$((counter+30))
                        echo "end"
                    fi
                fi
            done
            
            echo -e "${GREEN} DUT's are back online. Connect to them using option 'a'${NC}"
            sleep 5
            DUT_CONNECT=0
            

            fi
            ;;

        x)  echo "x) Exiting script"
            sleep 1
            tmux kill-session -t $SESSIONNAME
            exit 0
            ;;
        *)  echo "Not a valid option, try again."
            ;;
        esac
    done
fi

#######################################################################
#######################################################################
#######################################################################


