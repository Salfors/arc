#------In order to partition a disk----#
echo -e "\nInstalling prereqs...\n"
pacman -S --noconfirm gptfdisk btrfs-progs
clear
echo "-------------------------------------------------"
echo "-------select your disk to format----------------"
echo "-------------------------------------------------"
lsblk
echo "Please enter disk: (example /dev/sda)"
read DISK
echo "--------------------------------------"
echo -e "\nFormatting disk...\n"
echo "--------------------------------------"
# disk prep
sgdisk -Z ${DISK} # zap all on disk
sgdisk -a 2048 -o ${DISK} # new gpt disk 2048 alignment
clear
#------create partitions------#

#-----Select live boot type------#

echo "-------------------------------------------------"
echo "----------Select your boot type -----------------"
echo "-------------------------------------------------"
while true
do
N1=1
N2=2
echo -e "\n+[1] Bios Mode" # BIOS
echo -e  "+[2] UFI Mode\n" # UFI
read -p  "Enter Number : " Mode

if [ "$Mode" == "$N1" ]  ######### if Bios #######
    then
    sgdisk -n 1:0:+512M ${DISK}
    sgdisk -c 1:"BIOSSYS" ${DISK}
    mkfs.ext2 -L "BIOSSYS" "${DISK}1"
    mkdir /mnt/boot
    mount "${DISK}1" /mnt/boot/

    clear
    #_____Determine the size of the root partition____#
    echo -e "\nNote: Enter values in MB or GB on next step\n "

    read -p "Please enter size for root partition : " RooP
    sgdisk -n 2:0:"+"$RooP""   ${DISK} # partition 2 (Root), default start, remaining
    clear
    #____Determine the size of the home partition___#
    while true
    do
    echo -e ""
    read  -p "Please do you want create home part or not (y/n) : " answer
    if [ $answer == "yes" ] ||  [ "$answer" == "y" ] #if "Yes"
        then
        echo -e "\nEnter your /home partition size please"
        read Homep   
        sgdisk -n 3:0:"+"$Homep"" ${DISK} #partition 3 (/home)
        echo -e 
        sgdisk -c 3:"Home" ${DISK}
        mkfs.ext4 -L "Home" "${DISK}3"
        break
        elif [ $answer == "no" ] ||  [ "$answer" == "n" ] #if "No"
        then
        echo "Ok no problem"
        break
        else 
        echo  "[+]Enter yes or no (y/n)[+]"
    fi
    done
    #_____Determine the size of the swap partition__#

    while true
    do
    echo -e ""
    read  -p "Please did you want create swap part or not (y/n) : " answer2
    if [ $answer2 == "yes" ] ||  [ "$answer2" == "y" ] #if "Yes"
        then
        echo -e "\nEnter your Swap partition size please"
        read Swap
        sgdisk -n 4:0:"+"$Swap"" ${DISK} #partition 4 (Swap)
        echo -e 
        sgdisk -c :"Swap" ${DISK}
        mkswap -L "Swap" "${DISK}4"
        swapon "Swap" "${DISK}4"
        break
        elif [ $answer2 == "no" ] ||  [ "$answer2" == "n" ] #if "No"
        then
        echo "Ok no problem"
        break
        else 
        echo  "[+]Enter yes or no (y/n)[+]"
    fi

    done

    # label partitions
    sgdisk -c 2:"ROOT" ${DISK}

    # make filesystems
    echo -e "\nCreating Filesystems...\n"

    mkfs.ext4 -L "ROOT" "${DISK}2"

    # mount target

    mount -t ext4 "${DISK}2" /mnt

    if [ $answer == "yes" ]
        then
        mkdir /mnt/home
        mount -t ext4 "${DISK}3" /mnt/home

        else 
    
        echo "" 
    fi 
    clear

    echo "--------------------------------------"
    echo "-- Arch Install on Main Drive       --"
    echo "--------------------------------------"
    pacstrap /mnt --noconfirm base base-devel linux linux-firmware vim nano sudo
    genfstab -U /mnt >> /mnt/etc/fstab
    mv ~/arc/step2.sh /mnt/
    chmod a+x /mnt/step2.sh
    echo "$DISK" > /mnt/ID
    echo "$Mode" > /mnt/GrubID
    clear
    echo "-------------------------------------------------------------"
    echo "--    you should run step 2 after it be ready (./step2)  --"
    echo "-------------------------------------------------------------"
    sleep 8
    echo -e "\n----------------------------"
    echo    "------   it ready !!    ----"
    echo    "----------------------------"
    arch-chroot /mnt 

    #---After arch-chroot---#
    umount -R /mnt

    echo "--------------------------------------"
    echo "--   SYSTEM READY FOR FIRST BOOT    --"
    echo "--------------------------------------"
    echo "--          reboot now              --"
    break

    ########################################################

    elif [ "$Mode" == "$N2" ] # ----------if UFI-------------- #
    then
    sgdisk -Z ${DISK} # zap all on disk
    sgdisk -a 2048 -o ${DISK} # new gpt disk 2048 alignment
    sgdisk -n 1:0:+512M ${DISK}
    sgdisk -c 1:"UEFISYS" ${DISK}
    mkfs.fat -F32 -n "UEFISYS" "${DISK}1"
    mkdir /mnt/boot
    mkdir /mnt/boot/efi
    mount "${DISK}1" /mnt/boot/efi
    

    clear
    #_____Determine the size of the root partition____#
    echo -e "\nNote: Enter values in MB or GB on next step\n "

    read -p "Please enter size for root partition : " RooP
    sgdisk -n 2:0:"+"$RooP""   ${DISK} # partition 2 (Root), default start, remaining
    clear
    #____Determine the size of the home partition___#
    while true
    do
    echo -e ""
    read  -p "Please do you want create home part or not (y/n) : " answer
    if [ $answer == "yes" ] ||  [ "$answer" == "y" ] #if "Yes"
        then
        echo -e "\nEnter your /home partition size please"
        read Homep   
        sgdisk -n 3:0:"+"$Homep"" ${DISK} #partition 3 (/home)
        echo -e 
        sgdisk -c 3:"Home" ${DISK}
        mkfs.ext4 -L "Home" "${DISK}3"
        break
        elif [ $answer == "no" ] ||  [ "$answer" == "n" ] #if "No"
        then
        echo "Ok no problem"
        break
        else 
        echo  "[+]Enter yes or no (y/n)[+]"
    fi
    done
    #_____Determine the size of the swap partition__#

    while true
    do
    echo -e ""
    read  -p "Please did you want create swap part or not (y/n) : " answer2
    if [ $answer2 == "yes" ] ||  [ "$answer2" == "y" ] #if "Yes"
        then
        echo -e "\nEnter your Swap partition size please"
        read Swap
        sgdisk -n 4:0:"+"$Swap"" ${DISK} #partition 4 (Swap)
        echo -e 
        sgdisk -c :"Swap" ${DISK}
        mkswap -L "Swap" "${DISK}4"
        swapon "Swap" "${DISK}4"
        break
        elif [ $answer2 == "no" ] ||  [ "$answer2" == "n" ] #if "No"
        then
        echo "Ok no problem"
        break
        else 
        echo  "[+]Enter yes or no (y/n)[+]"
    fi

    done

    # label partitions
    sgdisk -c 2:"ROOT" ${DISK}

    # make filesystems
    echo -e "\nCreating Filesystems...\n"

    mkfs.ext4 -L "ROOT" "${DISK}2"

    # mount target

    mount -t ext4 "${DISK}2" /mnt

    if [ $answer == "yes" ]
        then
        mkdir /mnt/home
        mount -t ext4 "${DISK}3" /mnt/home

        else 
    
        echo "" 
    fi 
    clear

    echo "--------------------------------------"
    echo "-- Arch Install on Main Drive       --"
    echo "--------------------------------------"
    pacstrap /mnt --noconfirm base base-devel linux linux-firmware vim nano sudo
    genfstab -U /mnt >> /mnt/etc/fstab
    mv ~/arc/step2.sh /mnt/
    chmod a+x /mnt/step2.sh
    echo "$DISK" > /mnt/ID
    echo "$Mode" > /mnt/GrubID
    clear
    echo "-------------------------------------------------------------"
    echo "--    you should run step 2 after it be ready (./step2)  --"
    echo "-------------------------------------------------------------"
    sleep 8
    echo -e "\n----------------------------"
    echo    "------   it ready !!    ----"
    echo    "----------------------------"
    arch-chroot /mnt 

    #---After arch-chroot---#
    umount -R /mnt

    echo "--------------------------------------"
    echo "--   SYSTEM READY FOR FIRST BOOT    --"
    echo "--------------------------------------"
    echo "--          reboot now              --"
    break
fi

done
