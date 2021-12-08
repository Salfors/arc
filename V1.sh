clear
echo "
 █████╗ ██████╗  ██████╗████████╗██╗   ██╗███████╗
██╔══██╗██╔══██╗██╔════╝╚══██╔══╝██║   ██║██╔════╝
███████║██████╔╝██║        ██║   ██║   ██║███████╗
██╔══██║██╔══██╗██║        ██║   ██║   ██║╚════██║
██║  ██║██║  ██║╚██████╗   ██║   ╚██████╔╝███████║
╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝   ╚═╝    ╚═════╝ ╚══════╝
" 
##_________________________________________WELCOM TO "ARCTUS" __________________________________________________________________##

os=`cat /etc/*-release | grep "PRETTY_NAME" | sed 's/PRETTY_NAME=//g'`
if [ "${os}" != '"Arch Linux"' ]; then
    echo -e "\nYou must be using Arch Linux to execute this script."
    break
    elif [ "${os}" == '"Arch Linux"' ]; then
    sleep 3
    #------In order to partition a disk----#
    echo -e "\nInstalling prereqs...\n"
    pacman -S --noconfirm gptfdisk btrfs-progs
    clear
    echo "-------------------------------------------------"
    echo "-------Select Your Disk To Format----------------"
    echo "-------------------------------------------------"
    lsblk
    ### to make clean screen with limit trying 
    count=0
    max=3
    while true
    do
    echo -e "\nPlease Enter Disk: (example /dev/sda)\n"
    read DISK
    if [ "$DISK" == "" ] 
        then
        echo -e "\n[+]Choose The Disk To Install To !!![+]\n"
        count=`expr $count + 1`
        if [ "$count" -eq "$max" ]
        then
        clear
        count=`expr $count - 3`
        lsblk
        fi
        else 
        break    
    fi
    done
    ##### to choos Disk option free space or all or gpt or msdos
    echo "-----------------------------"
    echo -e "\n----     EDIT Disk        ---\n"
    echo "-----------------------------"

    clear
    function EDIT_HARD() {
        while true
            do
            echo -e ""
            read -p "Do You Want To Modify a Hard Disk ? : " ED #EDIT DISK
            case $ED in 
                y|Y|yes|Yes|YES)
                        while true
                            do
                            clear
                            echo -e "\nChoose Tool for Managing Hard Disk Partitions.\n"
                            echo "**********"
                            echo "[-]fdisk"
                            echo "[-]cfdisk"
                            echo "[-]parted"
                            echo "[-]cgdisk"
                            echo -e "\n***********\n"
                            read -p "Enter Your Favorite Tool : " tool
                            case $tool in 
                                fdisk|cfdisk|parted|cgdisk)
                                    $tool ${DISK}
                                    break
                                    ;;
                                *)
                                    echo -e "\n[+]Sorry, Choose One From Them !!! [+]\n"
                                    count=`expr $count + 1`
                                    ;;
                            esac
                        done
                        break              
                        ;;

                n|N|no|No|NO)
                    break
                    ;;
                *)
                    echo -e "\n[+]ENTER 'yes' OR 'no' !!! [+]\n"
                    count=`expr $count + 1`   
                    ;;                      
            esac
            if [ "$count" -eq "$max" ]
                then
                clear
                count=`expr $count - 3`
            fi
        done
    }
    EDIT_HARD
    clear
    echo "-------------------------------------------------"
    echo "---           Disk Usage                     ----"
    echo "-------------------------------------------------"
    echo -e "\n"
    function disk_format(){
        while true
            do 
            echo -e ""
            echo "[1] Use it all and format the hard drive."
            echo "[2] Use only free disk space."
            echo -e ""
            read -p "Do you want to use all disk for installation or just free space : " UD #USE DISK

            if [ "$UD" == "1" ] 
            then
            clear
            sgdisk -Z ${DISK} # zap all on disk
            while true 
                do
                
                echo -e ""
                echo "[1] GPT"
                echo "[2] MSDOS"
                echo -e ""
                read -p "Do you want a 'GPT' or 'MSDOS' table for your hard disk : " table 
                case $table in 
                1)
                    clear
                    sgdisk -a 2048 -o ${DISK} 
                    break
                    ;;

                2)
                    clear
                    echo "o
                    w
                    " | fdisk ${DISK}
                    break
                    ;;

                *)
                    echo "enter 1 or 2 "
                    count=`expr $count + 1`
                    ;;
                esac
                clean
            done    
            break
            
            elif [ "$UD" == "2" ]; then
                        #chosse edit or note
            break 
            else
            echo -e "\n[+]Choose 1 or 2 !!![+]\n"
            count=`expr $count + 1`
            clean
            fi
            
        done
            
    }
    disk_format
    clear

    #-----Select live boot type------#

    while true
    do
    N1=1
    N2=2
    echo "-------------------------------------------------"
    echo "----------Select Your Boot Type -----------------"
    echo "-------------------------------------------------"
    echo -e "\n+[1] Bios Mode" # BIOS
    echo -e  "+[2] UFI Mode\n" # UFI
    read -p  "Enter Number : " Mode

    if [ "$Mode" == "$N1" ]  ######### IF IS BIOS MODE #######
        then       
        clear
        
        function Determine_size() {

            #_____Determine the size of the root partition____#
            echo -e "\nNote: Enter Values in 'MB' or 'GB' on Next step\n "
            while true
                do
                echo -e ""
                read -p "Please Enter Size For Root Partition : " RooP #Root Part
                if [ -z "${RooP//[0-9]/}" -a ! -z "$RooP" ]; then 
                    echo "${RooP}"
                    break
                    elif [ -z "${RooP##*[!0-9]*}" ]; then
                    echo -e "\n[+]enter just the number and  with out GB or MB[+]"
                    count=`expr $count + 1`
                    else
                    echo -e "\n[+]You Must Enter Root Partition Size !!![+]\n"
                    count=`expr $count + 1`
                fi
                if [ "$count" -eq "$max" ]; then
                    clear
                    echo -e "\nNote: Enter Values in 'MB' or 'GB' on Next step"
                    count=`expr $count - 3`       
                fi
            done
            clear
                
                #____Determine the size of the home partition___#
            while true
                do
                echo -e 
                read  -p "Please do you want create home part or not (y/n) : " AN #ANSWER
                case $AN in 
                    y|yes)

                            clear
                            echo -e 
                            echo -e "Note: Enter Values in 'MB' or 'GB' on Next step\n "
                            while true
                                do
                                read -p "Enter your /home partition size please : " Homep #Home Part
                                if [ -z "${Homep//[0-9]/}" -a ! -z "$Homep" ]; then
                                    break
                                    elif [ -z "${Homep##*[!0-9]*}" ]; then
                                    echo -e "\n[+]enter just the number without GB or MB[+]\n"
                                    count=`expr $count + 1`
                                    else 
                                    echo "enter vailde value !!"
                                    count=`expr $count + 1`
                                fi
                                if [ "$count" -eq "$max" ]; then
                                    clear
                                    echo -e "Note: Enter Values in 'MB' or 'GB' on Next step\n"
                                    count=`expr $count - 3`
                                fi
                            done
                            echo -e 
                            break
                            ;;
                    n|no)

                        break
                        ;;
                    *) 
                            echo -e "\n[+]Enter yes or no (y/n)[+]"
                            count=`expr $count + 1`
                            if [ "$count" -eq "$max" ]; then
                                clear
                                count=`expr $count - 3`
                            fi
                            ;;
                    esac
            done
            clear
                #_____Determine the size of the swap partition__#

            while true
                do
                echo -e 
                read  -p "Please do you want create home part or not (y/n) : " AN2 #ANSWER2
                case $AN2 in 
                    y|Y|YES|Yes|yes)
                            clear
                            echo -e 
                            echo -e "Note: Enter Values in 'MB' or 'GB' on Next step\n "
                            while true
                                do
                                read -p "Enter your Swap partition size please : " Swap
                                if [ -z "${Swap//[0-9]/}" -a ! -z "$Swap" ]; then
                                    break
                                    elif [ -z "${Swap##*[!0-9]*}" ]; then
                                    echo -e "\n[+]enter just the number without GB or MB[+]\n"
                                    count=`expr $count + 1`
                                    else 
                                    echo "enter vailde value !!"
                                    count=`expr $count + 1`
                                fi
                                if [ "$count" -eq "$max" ]; then
                                    clear
                                    echo -e "Note: Enter Values in 'MB' or 'GB' on Next step\n"
                                    count=`expr $count - 3`
                                fi
                            done
                            echo -e 
                            break
                            ;;
                    n|N|NO|No|no)
                        break
                        ;;
                    *) 
                            echo -e "\n[+]Enter yes or no (y/n)[+]"
                            count=`expr $count + 1`
                            if [ "$count" -eq "$max" ]; then
                                clear
                                count=`expr $count - 3`
                            fi
                            ;;
                    esac
            done
        }

        Determine_size
        logic=`expr $RooP + $Homep + $Swap`
        clear

                           #------    CREATE PARTITIONS ON BIOS MODE -------#

    #####################################################################################################################

    #  NOTE: Every line Here Is Important Even If It Is Empty. If You Delete Any Line Here, It Will Be A Problem
    #               You Must Understand How the "FDISK" Partition Works To Understand It

    ################################################################################################################## 

        
        DT=`sudo parted /dev/sda print | grep -i '^Partition Table' | sed 's/Partition Table: //g'`
        if [ "${DT}" == 'msdos' ]; then

            function MSDOS(){
                echo "n 
                e 
                
                
                +${logic}GB
                w
                " | fdisk ${DISK}
                #### root
                echo "n 
                l 
                
                
                +${RooP}GB
                w
                " | fdisk ${DISK}
                ROOT=`sudo partx -rgo NR -n -1:-1 /dev/sda`
                            
                if [ "$AN" == "YES" ] || [ "$AN" == "Yes" ] || [ "$AN" == "Y" ] || [ "$AN" == "yes" ] || [ "$AN" == "y" ] && [ "$AN2" == "YES" ] || [ "$AN2" == "Yes" ] || [ "$AN2" == "Y" ] || [ "$AN2" == "yes" ] || [ "$AN2" == "y" ]
                    then 
                    echo "n
                    l
                    
                    
                    +${Homep}GB
                    w
                    " | fdisk ${DISK}  
                    HOME=`sudo partx -rgo NR -n -1:-1 /dev/sda`
                    #####
                    echo "
                    n
                    l
                    
                    
                    +${Swap}GB
                    w
                    " | fdisk ${DISK}
                    SWAP=`sudo partx -rgo NR -n -1:-1 /dev/sda`
                    #######                

                    elif [ "$AN" == "NO" ] || [ "$AN" == "No" ] || [ "$AN" == "N" ] || [ "$AN" == "no" ] || [ "$AN" == "n" ] && [ "$AN2" == "Yes" ] || [ "$AN2" == "yes" ] || [ "$AN2" == "Y" ] || [ "$AN2" == "y" ]
                    then 
                    echo "
                    n
                    l
                    
                    
                    +${Swap}GB  
                    w
                    " | fdisk ${DISK}
                    swap=`sudo partx -rgo NR -n -1:-1 /dev/sda`
                    ### 
                    elif [ "$AN" == "YES" ] || [ "$AN" == "Yes" ] || [ "$AN" == "Y" ] || [ "$AN" == "yes" ] || [ "$AN" == "y" ] && [ "$AN2" == "NO" ] || [ "$AN2" == "No" ] || [ "$AN2" == "N" ] || [ "$AN2" == "no" ] || [ "$AN2" == "n" ]
                    then 
                    echo "
                    n
                    l
                    
                    
                    +${Homep}GB
                    w
                    " | fdisk ${DISK}
                    HOME=`sudo partx -rgo NR -n -1:-1 /dev/sda`
                                    
                fi
            }
            MSDOS

            #___________________IF IS GPT ON BIOS _______________#
            elif [ "${DT}" == 'gpt' ]; then

            function GPT(){

                #____root
                echo "n  
                
                
                +${RooP}GB
                w
                " | fdisk ${DISK}
                ROOT=`sudo partx -rgo NR -n -1:-1 /dev/sda`
                            
                if [ "$AN" == "YES" ] || [ "$AN" == "Yes" ] || [ "$AN" == "Y" ] || [ "$AN" == "yes" ] || [ "$AN" == "y" ] && [ "$AN2" == "YES" ] || [ "$AN2" == "Yes" ] || [ "$AN2" == "Y" ] || [ "$AN2" == "yes" ] || [ "$AN2" == "y" ]
                    then 
                    echo "n
                    
                    
                    +${Homep}GB
                    w
                    " | fdisk ${DISK}  
                    HOME=`sudo partx -rgo NR -n -1:-1 /dev/sda`
                    #____home
                    echo "
                    n
                    
                    
                    +${Swap}GB
                    w
                    " | fdisk ${DISK}
                    SWAP=`sudo partx -rgo NR -n -1:-1 /dev/sda`
                    #_____swap             

                    elif [ "$answer" == "NO" ] || [ "$answer" == "No" ] || [ "$answer" == "N" ] || [ "$answer" == "no" ] || [ "$answer" == "n" ] && [ "$answer2" == "Yes" ] || [ "$answer2" == "yes" ] || [ "$answer2" == "Y" ] || [ "$answer2" == "y" ]
                    then 
                    echo "
                    n
                    
                    
                    +${Swap}GB  
                    w
                    " | fdisk ${DISK}
                    SWAP=`sudo partx -rgo NR -n -1:-1 /dev/sda`
                    #_______# 
                    elif [ "$AN" == "YES" ] || [ "$AN" == "Yes" ] || [ "$AN" == "Y" ] || [ "$AN" == "yes" ] || [ "$AN" == "y" ] && [ "$AN2" == "NO" ] || [ "$AN2" == "No" ] || [ "$AN2" == "N" ] || [ "$AN2" == "no" ] || [ "$AN2" == "n" ]
                    then 
                    echo "
                    n
                    
                    
                    +${Homep}GB
                    w
                    " | fdisk ${DISK}
                    HOME=`sudo partx -rgo NR -n -1:-1 /dev/sda`                   
                fi
            }
            GPT
        fi

        ##_______________________________SELECT CONVERT TO __________________#

        mkfs.ext4 "${DISK}${ROOT}"
        if [ "$AN" == "YES" ] ||  [ "$AN" == "Yes" ] ||  [ "$AN" == "Y" ] ||  [ "$AN" == "yes" ] ||  [ "$AN" == "y" ] && [ "$AN2" == "YES" ] ||  [ "$AN2" == "Yes" ] ||  [ "$AN2" == "Y" ] ||  [ "$AN2" == "yes" ] ||  [ "$AN2" == "y" ]
            then
            mkfs.ext4 "${DISK}${HOME}" #partition (Home)
            mkswap "${DISK}${SWAP}" #partition (Swap)
            swapon "${DISK}${SWAP}"
            elif [ "$AN" == "NO" ] ||  [ "$AN" == "No" ] ||  [ "$AN" == "N" ] ||  [ "$AN" == "no" ] ||  [ "$AN" == "n" ] && [ "$AN2" == "Yes" ] ||  [ "$AN2" == "yes" ] ||  [ "$AN2" == "Y" ] ||  [ "$AN2" == "y" ]
            then
            mkswap "${DISK}${SWAP}" #partition  (Swap)
            swapon "${DISK}${SWAP}"
        fi 

            #_____________ MOUNT THE POINTS PARTITIONS  _______________#

        mount "${DISK}${ROOT}" /mnt
        if [ "$AN" == "YES" ] ||  [ "$AN" == "Yes" ] ||  [ "$AN" == "Y" ] ||  [ "$AN" == "yes" ] ||  [ "$AN" == "y" ]
            then
            mkdir /mnt/home
            mount "${DISK}${HOME}" /mnt/home
        fi
        clear 
        lsblk
        echo -e "\n"
        echo "----------------------------------------------------------------"
        echo "--   If you did not do the division correctly      -------------"
        echo "--           Stop Script with (CTRL + Z)           -------------"
        echo "           And run the script 'help.sh'             ------------"
        echo "----------------------------------------------------------------"
        echo "or read the steps mentioned in it and execute them manually  ---"
        echo "--                and try again                           ------"
        echo "----------------------------------------------------------------"
        sleep 20
        clear
        echo "--------------------------------------"
        echo "-- Arch Install on Main Drive       --"
        echo "--------------------------------------"
        pacstrap /mnt --noconfirm base base-devel linux linux-firmware vim nano sudo micro
        genfstab -U /mnt >> /mnt/etc/fstab

        #### To prepare step 2 ####
        cp ~/arc/step2.sh /mnt/
        chmod a+x /mnt/step2.sh
        echo "$DISK" > /mnt/ID
        echo "$Mode" > /mnt/GrubID
        clear
        echo "-------------------------------------------------------------"
        echo "--    You Should Run Step 2 After It Be Ready (./step2)  --"
        echo "-------------------------------------------------------------"
        sleep 4
        echo -e "\n----------------------------"
        echo    "------   It Ready !!    ----"
        echo    "----------------------------"
        arch-chroot /mnt 

        #---After arch-chroot---#
        umount -R /mnt
        clear
        echo "--------------------------------------"
        echo "--   SYSTEM READY FOR FIRST BOOT    --"
        echo "--------------------------------------"
        echo "--          Reboot Now              --"
        break
####______________________________________________________________________________________________________________________##### 
####______________________________________________________________________________________________________________________#####  

        elif [ "$Mode" == "$N2" ] # ---------- IF IS UEFI MODE ---------#
        then
        clear
        function Determine_size() {

            #_____Determine the size of the root partition____#
            echo -e "\nNote: Enter Values in 'MB' or 'GB' on Next step\n "
            while true
                do
                echo -e ""
                read -p "Please Enter Size For Root Partition : " RooP #Root Part
                if [ -z "${RooP//[0-9]/}" -a ! -z "$RooP" ]; then 
                    echo "${RooP}"
                    break
                    elif [ -z "${RooP##*[!0-9]*}" ]; then
                    echo -e "\n[+]enter just the number and  with out GB or MB[+]"
                    count=`expr $count + 1`
                    else
                    echo -e "\n[+]You Must Enter Root Partition Size !!![+]\n"
                    count=`expr $count + 1`
                fi
                if [ "$count" -eq "$max" ]; then
                    clear
                    echo -e "\nNote: Enter Values in 'MB' or 'GB' on Next step"
                    count=`expr $count - 3`       
                fi
            done
            clear
                
                #____Determine the size of the home partition___#
            while true
                do
                echo -e 
                read  -p "Please do you want create home part or not (y/n) : " AN #ANSWER
                case $AN in 
                    y|yes)

                            clear
                            echo -e 
                            echo -e "Note: Enter Values in 'MB' or 'GB' on Next step\n "
                            while true
                                do
                                read -p "Enter your /home partition size please : " Homep #Home Part
                                if [ -z "${Homep//[0-9]/}" -a ! -z "$Homep" ]; then
                                    break
                                    elif [ -z "${Homep##*[!0-9]*}" ]; then
                                    echo -e "\n[+]enter just the number without GB or MB[+]\n"
                                    count=`expr $count + 1`
                                    else 
                                    echo "enter vailde value !!"
                                    count=`expr $count + 1`
                                fi
                                if [ "$count" -eq "$max" ]; then
                                    clear
                                    echo -e "Note: Enter Values in 'MB' or 'GB' on Next step\n"
                                    count=`expr $count - 3`
                                fi
                            done
                            echo -e 
                            break
                            ;;
                    n|no)

                        break
                        ;;
                    *) 
                            echo -e "\n[+]Enter yes or no (y/n)[+]"
                            count=`expr $count + 1`
                            if [ "$count" -eq "$max" ]; then
                                clear
                                count=`expr $count - 3`
                            fi
                            ;;
                    esac
            done
            clear
                #_____Determine the size of the swap partition__#

            while true
                do
                echo -e 
                read  -p "Please do you want create home part or not (y/n) : " AN2 #ANSWER2
                case $AN2 in 
                    y|Y|YES|Yes|yes)
                            clear
                            echo -e 
                            echo -e "Note: Enter Values in 'MB' or 'GB' on Next step\n "
                            while true
                                do
                                read -p "Enter your Swap partition size please : " Swap
                                if [ -z "${Swap//[0-9]/}" -a ! -z "$Swap" ]; then
                                    break
                                    elif [ -z "${Swap##*[!0-9]*}" ]; then
                                    echo -e "\n[+]enter just the number without GB or MB[+]\n"
                                    count=`expr $count + 1`
                                    else 
                                    echo "enter vailde value !!"
                                    count=`expr $count + 1`
                                fi
                                if [ "$count" -eq "$max" ]; then
                                    clear
                                    echo -e "Note: Enter Values in 'MB' or 'GB' on Next step\n"
                                    count=`expr $count - 3`
                                fi
                            done
                            echo -e 
                            break
                            ;;
                    n|N|NO|No|no)
                        break
                        ;;
                    *) 
                            echo -e "\n[+]Enter yes or no (y/n)[+]"
                            count=`expr $count + 1`
                            if [ "$count" -eq "$max" ]; then
                                clear
                                count=`expr $count - 3`
                            fi
                            ;;
                    esac
            done
        }

        Determine_size
        logic=`expr $RooP + $Homep + $Swap`
        clear


        #_____________________ IF MSDOS ON BIOS __________________# 

        DT=`sudo parted /dev/sda print | grep -i '^Partition Table' | sed 's/Partition Table: //g'`
        if [ "${DT}" == 'msdos' ]; then
            function MSDOS(){
                echo "n 
                e 
                
                
                +${logic}GB
                w
                " | fdisk ${DISK}
                ####EFI PART

                function ESP() {
                    ## efi part
                    echo "n


                    +512M
                    w
                    " | fdisk ${DISK}
                    EFI=`sudo partx -rgo NR -n -1:-1 /dev/sda`

                }
                ESP
               #___ROOT
                echo "n 
                l 
                
                
                +${RooP}GB
                w
                " | fdisk ${DISK}
                ROOT=`sudo partx -rgo NR -n -1:-1 /dev/sda`
                            
                if [ "$AN" == "YES" ] || [ "$AN" == "Yes" ] || [ "$AN" == "Y" ] || [ "$AN" == "yes" ] || [ "$AN" == "y" ] && [ "$AN2" == "YES" ] || [ "$AN2" == "Yes" ] || [ "$AN2" == "Y" ] || [ "$AN2" == "yes" ] || [ "$AN2" == "y" ]
                    then 
                    echo "n
                    l
                    
                    
                    +${Homep}GB
                    w
                    " | fdisk ${DISK}  
                    HOME=`sudo partx -rgo NR -n -1:-1 /dev/sda`
                    #___home
                    echo "
                    n
                    l
                    
                    
                    +${Swap}GB
                    w
                    " | fdisk ${DISK}
                    SWAP=`sudo partx -rgo NR -n -1:-1 /dev/sda`
                    #___swap               

                    elif [ "$AN" == "NO" ] || [ "$AN" == "No" ] || [ "$AN" == "N" ] || [ "$AN" == "no" ] || [ "$AN" == "n" ] && [ "$AN2" == "Yes" ] || [ "$AN2" == "yes" ] || [ "$AN2" == "Y" ] || [ "$AN2" == "y" ]
                    then 
                    echo "
                    n
                    l
                    
                    
                    +${Swap}GB  
                    w
                    " | fdisk ${DISK}
                    swap=`sudo partx -rgo NR -n -1:-1 /dev/sda`
                    #___swap
                    elif [ "$AN" == "YES" ] || [ "$AN" == "Yes" ] || [ "$AN" == "Y" ] || [ "$AN" == "yes" ] || [ "$AN" == "y" ] && [ "$AN2" == "NO" ] || [ "$AN2" == "No" ] || [ "$AN2" == "N" ] || [ "$AN2" == "no" ] || [ "$AN2" == "n" ]
                    then 
                    echo "
                    n
                    l
                    
                    
                    +${Homep}GB
                    w
                    " | fdisk ${DISK}
                    HOME=`sudo partx -rgo NR -n -1:-1 /dev/sda`
                                    
                fi
            }
            MSDOS
            clear

            #________________________IF IS GPT ON UEFI _______________#
            elif [ "${DT}" == 'gpt' ]; then
            function GPT(){

                function ESP() {
                    #___ efi part
                    echo "n


                    +512M
                    w
                    " | fdisk ${DISK}
                    EFI=`sudo partx -rgo NR -n -1:-1 /dev/sda`

                }
                ESP
                #___root
                echo "n  
                
                
                +${RooP}GB
                w
                " | fdisk ${DISK}
                ROOT=`sudo partx -rgo NR -n -1:-1 /dev/sda`
                            
                if [ "$AN" == "YES" ] || [ "$AN" == "Yes" ] || [ "$AN" == "Y" ] || [ "$AN" == "yes" ] || [ "$AN" == "y" ] && [ "$AN2" == "YES" ] || [ "$AN2" == "Yes" ] || [ "$AN2" == "Y" ] || [ "$AN2" == "yes" ] || [ "$AN2" == "y" ]
                    then 
                    echo "n
                    
                    
                    +${Homep}GB
                    w
                    " | fdisk ${DISK}  
                    HOME=`sudo partx -rgo NR -n -1:-1 /dev/sda`
                    #___home
                    echo "
                    n
                    
                    
                    +${Swap}GB
                    w
                    " | fdisk ${DISK}
                    SWAP=`sudo partx -rgo NR -n -1:-1 /dev/sda`
                    #____swap                

                    elif [ "$answer" == "NO" ] || [ "$answer" == "No" ] || [ "$answer" == "N" ] || [ "$answer" == "no" ] || [ "$answer" == "n" ] && [ "$answer2" == "Yes" ] || [ "$answer2" == "yes" ] || [ "$answer2" == "Y" ] || [ "$answer2" == "y" ]
                    then 
                    echo "
                    n
                    
                    
                    +${Swap}GB  
                    w
                    " | fdisk ${DISK}
                    SWAP=`sudo partx -rgo NR -n -1:-1 /dev/sda`
                    #__swap
                    elif [ "$AN" == "YES" ] || [ "$AN" == "Yes" ] || [ "$AN" == "Y" ] || [ "$AN" == "yes" ] || [ "$AN" == "y" ] && [ "$AN2" == "NO" ] || [ "$AN2" == "No" ] || [ "$AN2" == "N" ] || [ "$AN2" == "no" ] || [ "$AN2" == "n" ]
                    then 
                    echo "
                    n
                    
                    
                    +${Homep}GB
                    w
                    " | fdisk ${DISK}
                    HOME=`sudo partx -rgo NR -n -1:-1 /dev/sda`
                                    
                fi
            }
            GPT
        fi

#_____________ mount the point ___________#

        mkfs.fat -F32 "${DISK}${EFI}"
        mkfs.ext4 "${DISK}${ROOT}"
        if [ "$AN" == "YES" ] ||  [ "$AN" == "Yes" ] ||  [ "$AN" == "Y" ] ||  [ "$AN" == "yes" ] ||  [ "$AN" == "y" ] && [ "$AN2" == "YES" ] ||  [ "$AN2" == "Yes" ] ||  [ "$AN2" == "Y" ] ||  [ "$AN2" == "yes" ] ||  [ "$AN2" == "y" ]
            then
            mkfs.ext4 "${DISK}${HOME}" #partition  (Home)
            mkswap "${DISK}${SWAP}" #partition  (Swap)
            swapon "${DISK}${SWAP}"
            elif [ "$AN" == "NO" ] ||  [ "$AN" == "No" ] ||  [ "$AN" == "N" ] ||  [ "$AN" == "no" ] ||  [ "$AN" == "n" ] && [ "$AN2" == "Yes" ] ||  [ "$AN2" == "yes" ] ||  [ "$AN2" == "Y" ] ||  [ "$AN2" == "y" ]
            then
            mkswap "${DISK}${SWAP}" #partition  (Swap)
            swapon "${DISK}${SWAP}"
        fi 

            #---------  mount the points partitions  --------------#

        mount "${DISK}${ROOT}" /mnt
        mkdir /mnt/boot
        mkdir /mnt/boot/efi
        mount "${DISK}${EFI}" /mnt/boot/efi

        if [ "$AN" == "YES" ] ||  [ "$AN" == "Yes" ] ||  [ "$AN" == "Y" ] ||  [ "$AN" == "yes" ] ||  [ "$AN" == "y" ]
            then
            mkdir /mnt/home
            mount "${DISK}${HOME}" /mnt/home
        fi
        clear
        lsblk
        echo -e "\n"
        echo "----------------------------------------------------------------"
        echo "--   If you did not do the division correctly      -------------"
        echo "--           Stop Script with (CTRL + Z)           -------------"
        echo "           And run the script 'help.sh'             ------------"
        echo "----------------------------------------------------------------"
        echo "or read the steps mentioned in it and execute them manually  ---"
        echo "--                and try again                           ------"
        echo "----------------------------------------------------------------"
        sleep 20
        clear
        echo "--------------------------------------"
        echo "-- Arch Install on Main Drive       --"
        echo "--------------------------------------"
        pacstrap /mnt --noconfirm base base-devel linux linux-firmware vim nano sudo micro
        genfstab -U /mnt >> /mnt/etc/fstab

        #### To prepare step 2 ####
        cp ~/arc/step2.sh /mnt/
        chmod a+x /mnt/step2.sh
        echo "$DISK" > /mnt/ID
        echo "$Mode" > /mnt/GrubID
        clear
        echo "-------------------------------------------------------------"
        echo "--    You Should Run Step 2 After It Be Ready (./step2)  --"
        echo "-------------------------------------------------------------"
        sleep 4
        echo -e "\n----------------------------"
        echo    "------   It Ready !!    ----"
        echo    "----------------------------"
        arch-chroot /mnt 

        #---After arch-chroot---#
        umount -R /mnt
        clear
        echo "--------------------------------------"
        echo "--   SYSTEM READY FOR FIRST BOOT    --"
        echo "--------------------------------------"
        echo "--          Reboot Now              --"
        break         
    fi
    done  
fi

##______________________________________________ENJOY WITH ARCH LINUX NOW ______________________________________##
