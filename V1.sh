echo "
 █████╗ ██████╗  ██████╗████████╗██╗   ██╗███████╗
██╔══██╗██╔══██╗██╔════╝╚══██╔══╝██║   ██║██╔════╝
███████║██████╔╝██║        ██║   ██║   ██║███████╗
██╔══██║██╔══██╗██║        ██║   ██║   ██║╚════██║
██║  ██║██║  ██║╚██████╗   ██║   ╚██████╔╝███████║
╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝   ╚═╝    ╚═════╝ ╚══════╝
" 
sleep 3
while true
do
os=$(lsb_release -ds | sed 's/"//g')
if [ "${os}" != "Arch Linux" ]; then
    echo "You must be using Arch Linux to execute this script."
    break
    elif [ "${os}" == "Arch Linux" ]; then
    echo "........."
    fi
#------In order to partition a disk----#
echo -e "\nInstalling prereqs...\n"
pacman -S --noconfirm gptfdisk btrfs-progs
clear
#------      disc selection   ---------# 
echo "-------------------------------------------------"
echo "-------Select Your Disk To Format----------------"
echo "-------------------------------------------------"
lsblk
### to make clean screen with limit trying 
count=0
max=3
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
echo "--------------------------------------"
echo -e "\nFormatting Disk...\n"
echo "--------------------------------------"
# disk prep
sgdisk -Z ${DISK} # zap all on disk
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

if [ "$Mode" == "$N1" ]  ######### iIF IS BIOS MODE #######
    then
    clear
    #_____Determine the size of the root partition____#
    echo -e "\nNote: Enter Values in 'MB' or 'GB' on Next step\n "
    while true
    do
    echo -e ""
    read -p "Please Enter Size For Root Partition : " RooP
    if [ "$RooP" == "" ] 
        then
        echo -e "\n[+]You Must Enter Root Partition Size !!![+]\n"
        count=`expr $count + 1`
        if [ "$count" -eq "$max" ]
        then
        clear
        count=`expr $count - 3`
        fi
        else 
        break        
    fi
    done
    clear
    #____Determine the size of the home partition___#
    while true
    do
    echo -e 
    read  -p "Please do you want create home part or not (y/n) : " answer
    if [ "$answer" == "YES" ] ||  [ "$answer" == "Yes" ] ||  [ "$answer" == "Y" ] ||  [ "$answer" == "yes" ] ||  [ "$answer" == "y" ] #if "Yes"
        then
        echo -e 
        read -p "Enter your /home partition size please : " Homep
        echo -e 
        break
        elif [ "$answer" == "NO" ] ||  [ "$answer" == "No" ] ||  [ "$answer" == "N" ] ||  [ "$answer" == "no" ] ||  [ "$answer" == "n" ]  #if "No"
        then
        break
        else 
        echo -e "\n[+]Enter yes or no (y/n)[+]"
        count=`expr $count + 1`
        if [ "$count" -eq "$max" ]
        then
        clear
        count=`expr $count - 3`
        fi
    fi
    done
    clear
    #_____Determine the size of the swap partition__#

    while true
    do
    echo -e ""
    read  -p "Please did you want create swap part or not (y/n) : " answer2
    if [ "$answer2" == "YES" ] ||  [ "$answer2" == "Yes" ] ||  [ "$answer2" == "Y" ] ||  [ "$answer2" == "yes" ] ||  [ "$answer2" == "y" ] #if "Yes"
        then
        echo -e 
        read -p "Enter your Swap partition size please : " Swap
        echo -e 
        break
        elif [ "$answer2" == "NO" ] ||  [ "$answer2" == "No" ] ||  [ "$answer2" == "N" ] ||  [ "$answer2" == "no" ] ||  [ "$answer2" == "n" ] #if "No"
        then        
        break
        else 
        echo -e "\n[+]Enter yes or no (y/n)[+]"
        count=`expr $count + 1`
        if [ "$count" -eq "$max" ]
        then
        clear
        count=`expr $count - 3`
        fi
    fi
    done
#------    CREATE PARTITIONS ON BIOS MODE -------#

#####################################################################################################################

#  NOTE: Every line Here Is Important Even If It Is Empty. If You Delete Any Line Here, It Will Be A Problem
#               You Must Understand How the "FDISK" Partition Works To Understand It

################################################################################################################## 

    clear
    echo "o
    w
    " | fdisk ${DISK}
     
    if  [ -z "${RooP##*[!0-9]*}" ]; 
    then       
    echo "n 
    p 
    1   
    
    +${RooP}
    w
    " | fdisk ${DISK}
    elif [ -z "${RooP//[0-9]/}" -a ! -z "$RooP" ]; 
    then 
    echo "n 
    p 
    1
    
    +${RooP}GB
    w
    " | fdisk ${DISK}
    fi
    if [ "$answer" == "YES" ] || [ "$answer" == "Yes" ] || [ "$answer" == "Y" ] || [ "$answer" == "yes" ] || [ "$answer" == "y" ] && [ "$answer2" == "YES" ] || [ "$answer2" == "Yes" ] || [ "$answer2" == "Y" ] || [ "$answer2" == "yes" ] || [ "$answer2" == "y" ]
        then ######## for check input if is string or int, example : (10GB) or (10) only
        if  [ -z "${Homep##*[!0-9]*}" ] && [ -z "${Swap##*[!0-9]*}" ]; #str
            then       
            echo "n
            p
            2
                        
            +${Homep}
            w
            " | fdisk ${DISK}
            echo "
            n
            p
            3
                        
            +${Swap}
            w
            " | fdisk ${DISK}
            elif [ -z "${Homep//[0-9]/}" -a ! -z "$Homep" ] && [ -z "${Swap//[0-9]/}" -a ! -z "$Swap" ]; #int
            then 
            echo "n
            p
            2
                        
            +${Homep}GB
            w
            " | fdisk ${DISK}  
            echo "
            n
            p
            3
                        
            +${Swap}GB
            w
            " | fdisk ${DISK}
            elif [ -z "${Homep//[0-9]/}" -a ! -z "$Homep" ] && [ -z "${Swap##*[!0-9]*}" ];
            then 
            echo "n
            p
            2
                        
            +${Homep}GB
            w
            "  | fdisk ${DISK}
            echo "
            n
            p
            3
                        
            +${Swap}
            w
            "  | fdisk ${DISK}
            elif  [ -z "${Swap//[0-9]/}" -a ! -z "$Swap" ] && [ -z "${Homep##*[!0-9]*}" ];
            then 
            echo "n
            p
            2
                        
            +${Homep}
            w
            "  | fdisk ${DISK}
            echo "
            n
            p
            3
                        
            +${Swap}GB
            w
            " | fdisk ${DISK}
            fi 
        elif [ "$answer" == "NO" ] || [ "$answer" == "No" ] || [ "$answer" == "N" ] || [ "$answer" == "no" ] || [ "$answer" == "n" ] && [ "$answer2" == "Yes" ] || [ "$answer2" == "yes" ] || [ "$answer2" == "Y" ] || [ "$answer2" == "y" ]
        then 
        if  [ -z "${Swap##*[!0-9]*}" ]; 
            then       
            echo "
            n
            p
            2
                
            +${Swap}
            w
            " | fdisk ${DISK}
            elif [ -z "${Swap//[0-9]/}" -a ! -z "$Swap" ]; 
            then 
            echo "
            n
            p
            2
                
            +${Swap}GB  
            w
            " | fdisk ${DISK}
            fi 
        elif [ "$answer" == "YES" ] || [ "$answer" == "Yes" ] || [ "$answer" == "Y" ] || [ "$answer" == "yes" ] || [ "$answer" == "y" ] && [ "$answer2" == "NO" ] || [ "$answer2" == "No" ] || [ "$answer2" == "N" ] || [ "$answer2" == "no" ] || [ "$answer2" == "n" ]
        then 
        if  [ -z "${Homep##*[!0-9]*}" ];
            then       
            echo "
            n
            p
            2
                
            +${Homep}
            w
            " | fdisk ${DISK}
            elif [ -z "${Homep//[0-9]/}" -a ! -z "$Homep" ]; 
            then 
            echo "
            n
            p
            2
                
            +${Homep}GB
            w
            " | fdisk ${DISK}
            fi
        fi

    #------ Make File System For Partition -----#

    mkfs.ext4 "${DISK}1"
    if [ "$answer" == "YES" ] ||  [ "$answer" == "Yes" ] ||  [ "$answer" == "Y" ] ||  [ "$answer" == "yes" ] ||  [ "$answer" == "y" ] && [ "$answer2" == "YES" ] ||  [ "$answer2" == "Yes" ] ||  [ "$answer2" == "Y" ] ||  [ "$answer2" == "yes" ] ||  [ "$answer2" == "y" ]
        then
        mkfs.ext4 "${DISK}2" #partition 4 (Home)
        mkswap "${DISK}3" #partition 4 (Swap)
        swapon "${DISK}3"
        elif [ $answer == "NO" ] ||  [ "$answer" == "No" ] ||  [ "$answer" == "N" ] ||  [ "$answer" == "no" ] ||  [ "$answer" == "n" ] && [ "$answer2" == "Yes" ] ||  [ "$answer2" == "yes" ] ||  [ "$answer2" == "Y" ] ||  [ "$answer2" == "y" ]
        then
        mkswap "${DISK}2" #partition 4 (Swap)
        swapon "${DISK}2"
        fi 

        #---------  mount the points partitions  --------------#

    mount "${DISK}1" /mnt
    if [ $answer == "YES" ] ||  [ "$answer" == "Yes" ] ||  [ "$answer" == "Y" ] ||  [ "$answer" == "yes" ] ||  [ "$answer" == "y" ]
        then
        mkdir /mnt/home
        mount "${DISK}2" /mnt/home
        fi
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
    elif [ "$Mode" == "$N2" ] # ---------- IF IS UEFI MODE ---------#
    then
    clear
    #_____Determine the size of the root partition____#
    echo -e "\nNote: Enter Values in 'MB' or 'GB' on Next step\n "
    while true
    do
    echo -e ""
    read -p "Please Enter Size For Root Partition : " RooP
    if [ "$RooP" == "" ] 
        then
        echo -e "\n[+]You Must Enter Root Partition Size !!![+]\n"
        count=`expr $count + 1`
        if [ "$count" -eq "$max" ]
        then
        clear
        count=`expr $count - 3`
        fi
        else 
        break        
    fi
    done
    clear
    #____Determine the size of the home partition___#
    while true
    do
    echo -e 
    read  -p "Please do you want create home part or not (y/n) : " answer
    if [ "$answer" == "YES" ] ||  [ "$answer" == "Yes" ] ||  [ "$answer" == "Y" ] ||  [ "$answer" == "yes" ] ||  [ "$answer" == "y" ] #if "Yes"
        then
        echo -e 
        read -p "Enter your /home partition size please : " Homep
        echo -e 
        break
        elif [ "$answer" == "NO" ] ||  [ "$answer" == "No" ] ||  [ "$answer" == "N" ] ||  [ "$answer" == "no" ] ||  [ "$answer" == "n" ]  #if "No"
        then
        break
        else 
        echo -e "\n[+]Enter yes or no (y/n)[+]"
        count=`expr $count + 1`
        if [ "$count" -eq "$max" ]
        then
        clear
        count=`expr $count - 3`
        fi
    fi
    done
    clear
    #_____Determine the size of the swap partition__#

    while true
    do
    echo -e ""
    read  -p "Please did you want create swap part or not (y/n) : " answer2
    if [ "$answer2" == "YES" ] ||  [ "$answer2" == "Yes" ] ||  [ "$answer2" == "Y" ] ||  [ "$answer2" == "yes" ] ||  [ "$answer2" == "y" ] #if "Yes"
        then
        echo -e 
        read -p "Enter your Swap partition size please : " Swap
        echo -e 
        break
        elif [ "$answer2" == "NO" ] ||  [ "$answer2" == "No" ] ||  [ "$answer2" == "N" ] ||  [ "$answer2" == "no" ] ||  [ "$answer2" == "n" ] #if "No"
        then        
        break
        else 
        echo -e "\n[+]Enter yes or no (y/n)[+]"
        count=`expr $count + 1`
        if [ "$count" -eq "$max" ]
        then
        clear
        count=`expr $count - 3`
        fi
    fi
    done
#---------- CREATE PARTITIONS UEFI ---------#

    clear
    sgdisk -a 2048 -o ${DISK} # new gpt disk 2048 alignment
    sgdisk -n 1:0:+512M ${DISK}     
    if  [ -z "${RooP##*[!0-9]*}" ]; 
    then       
    sgdisk -n 2:0:+$RooP  ${DISK} 
    elif [ -z "${RooP//[0-9]/}" -a ! -z "$RooP" ]; 
    then 
    sgdisk -n 2:0:+${RooP}GB  ${DISK}
    fi

    if [ "$answer" == "YES" ] || [ "$answer" == "Yes" ] || [ "$answer" == "Y" ] || [ "$answer" == "yes" ] || [ "$answer" == "y" ] && [ "$answer2" == "YES" ] || [ "$answer2" == "Yes" ] || [ "$answer2" == "Y" ] || [ "$answer2" == "yes" ] || [ "$answer2" == "y" ]
        then ######## for check input if is string or int, example : (10GB) or (10) only
        if  [ -z "${Homep##*[!0-9]*}" ] && [ -z "${Swap##*[!0-9]*}" ]; #str
            then       
            sgdisk -n 3:0:+${Homep} ${DISK}   
            sgdisk -n 4:0:+${Swap} ${DISK}
            elif [ -z "${Homep//[0-9]/}" -a ! -z "$Homep" ] && [ -z "${Swap//[0-9]/}" -a ! -z "$Swap" ]; #int
            then 
            sgdisk -n 3:0:+${Homep}GB ${DISK} 
            sgdisk -n 4:0:+${Swap}GB ${DISK}
            elif [ -z "${Homep//[0-9]/}" -a ! -z "$Homep" ] && [ -z "${Swap##*[!0-9]*}" ];
            then 
            sgdisk -n 3:0:+${Homep}GB ${DISK}
            sgdisk -n 4:0:+${Swap} ${DISK}
            elif  [ -z "${Swap//[0-9]/}" -a ! -z "$Swap" ] && [ -z "${Homep##*[!0-9]*}" ];
            then 
            sgdisk -n 3:0:+${Homep} ${DISK}
            sgdisk -n 4:0:+${Swap}GB ${DISK}
            fi   
        elif [ "$answer" == "NO" ] || [ "$answer" == "No" ] || [ "$answer" == "N" ] || [ "$answer" == "no" ] || [ "$answer" == "n" ] && [ "$answer2" == "Yes" ] || [ "$answer2" == "yes" ] || [ "$answer2" == "Y" ] || [ "$answer2" == "y" ]
        then 
        if  [ -z "${Swap##*[!0-9]*}" ]; 
            then       
            sgdisk -n 3:0:+${Swap} ${DISK}     
            elif [ -z "${Swap//[0-9]/}" -a ! -z "$Swap" ]; 
            then 
            sgdisk -n 3:0:+${Swap}GB ${DISK}
            fi 
        elif [ "$answer" == "YES" ] || [ "$answer" == "Yes" ] || [ "$answer" == "Y" ] || [ "$answer" == "yes" ] || [ "$answer" == "y" ] && [ "$answer2" == "NO" ] || [ "$answer2" == "No" ] || [ "$answer2" == "N" ] || [ "$answer2" == "no" ] || [ "$answer2" == "n" ]
        then 
        if  [ -z "${Homep##*[!0-9]*}" ]; 
            then       
            sgdisk -n 3:0:+${Homep} ${DISK}
            elif [ -z "${Homep//[0-9]/}" -a ! -z "$Homep" ]; 
            then 
            sgdisk -n 3:0:+${Homep}GB ${DISK}
            fi
        fi

    #------ Make File System For Partition -----#

    mkfs.fat -F32 "${DISK}1"
    mkfs.ext4 "${DISK}2"
    if [ "$answer" == "YES" ] ||  [ "$answer" == "Yes" ] ||  [ "$answer" == "Y" ] ||  [ "$answer" == "yes" ] ||  [ "$answer" == "y" ] && [ "$answer2" == "YES" ] ||  [ "$answer2" == "Yes" ] ||  [ "$answer2" == "Y" ] ||  [ "$answer2" == "yes" ] ||  [ "$answer2" == "y" ]
        then
        mkfs.ext4 "${DISK}3" #partition 4 (Home)
        mkswap "${DISK}4" #partition 4 (Swap)
        swapon "${DISK}4"
        elif [ $answer == "NO" ] ||  [ "$answer" == "No" ] ||  [ "$answer" == "N" ] ||  [ "$answer" == "no" ] ||  [ "$answer" == "n" ] && [ "$answer2" == "Yes" ] ||  [ "$answer2" == "yes" ] ||  [ "$answer2" == "Y" ] ||  [ "$answer2" == "y" ]
        then
        mkswap "${DISK}3" #partition 4 (Swap)
        swapon "${DISK}3"
        fi 
            
        #---------  mount the points partitions  --------------#

    mount "${DISK}2" /mnt
    mkdir /mnt/boot
    mkdir /mnt/boot/efi
    mount "${DISK}1" /mnt/boot/efi
    if [ $answer == "YES" ] ||  [ "$answer" == "Yes" ] ||  [ "$answer" == "Y" ] ||  [ "$answer" == "yes" ] ||  [ "$answer" == "y" ]
        then
        mkdir /mnt/home
        mount "${DISK}3" /mnt/home
        fi
    clear
    lsblk
    echo -e "\n"
    echo "----------------------------------------------------------------"
    echo "--      If You DID Not Do The Division correctly              --"
    echo "--               Stop Script With 'ctrl + z'                  --"
    echo "               And Run Command 'Umount -R /mnt'               --"

    echo "--       And turn off Your Swap partition if you have         --"
    echo -e "                        with 'swapoff'                        \n"
    echo "--                 [+]  And Try Again  [+]                    --"
    echo "----------------------------------------------------------------"
    sleep 20
    clear
    echo "--------------------------------------"
    echo "-- Arch Install on Main Drive       --"
    echo "--------------------------------------"
    pacstrap /mnt --noconfirm base base-devel linux linux-firmware vim nano sudo
    genfstab -U /mnt >> /mnt/etc/fstab
    cp ~/arc/step2.sh /mnt/
    chmod a+x /mnt/step2.sh
    echo "$DISK" > /mnt/ID
    echo "$Mode" > /mnt/GrubID
    clear
    echo "-------------------------------------------------------------"
    echo "--    You Should Run Step 2 After It Be Ready (./step2)  --"
    echo "-------------------------------------------------------------"
    sleep 3
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
    echo "--          reboot now              --"
    break
    else
    echo -e "\n[+]Choose Number One Or Two [+]\n"
    count=`expr $count + 1`
    if [ "$count" -eq "$max" ]
    then
    clear
    count=`expr $count - 3`
    fi 
    
       
fi
done
