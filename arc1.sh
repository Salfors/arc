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

    clear
    #_____Determine the size of the root partition____#
    echo -e "\nNote: Enter values in MB or GB on next step\n "

    read -p "Please enter size for root partition : " RooP

    clear
    #____Determine the size of the home partition___#
    while true
    do
    echo -e 
    read  -p "Please do you want create home part or not (y/n) : " answer
    if [ $answer == "yes" ] ||  [ "$answer" == "y" ] #if "Yes"
        then
        echo -e 
        read -p "Enter your /home partition size please :" Homep
        echo -e 

        break
        elif [ $answer == "no" ] ||  [ "$answer" == "n" ] #if "No"
        then
        
        break
        else 
        echo  "[+]Enter yes or no (y/n)[+]"
    fi
    done
    clear
    #_____Determine the size of the swap partition__#

    while true
    do
    echo -e ""
    read  -p "Please did you want create swap part or not (y/n) : " answer2
    if [ $answer2 == "yes" ] ||  [ "$answer2" == "y" ] #if "Yes"
        then
        echo -e 
        read -p "Enter your Swap partition size please : " Swap
        echo -e 

        break
        elif [ $answer2 == "no" ] ||  [ "$answer2" == "n" ] #if "No"
        then
        
        break
        else 
        echo  "[+]Enter yes or no (y/n)[+]"
    fi

    done
########## CREAT PARTION BIOS ########

    clear
    echo "w
    " | fdisk ${DISK}
    #echo ';' | sfdisk ${DISK}
    echo 
    echo "n
    p
    1
    
    +${RooP}
    w
    " | fdisk ${DISK}
    #sgdisk -n 1:0:+512M ${DISK}
    #sgdisk -n 2:0:"+"$RooP""  ${DISK} 
    if [ $answer == "yes" ] ||  [ "$answer" == "y" ]
        then
        echo "n
        p
        2
        
        +${HomeP}
        w
        " | fdisk ${DISK}
        fi
    if [ $answer2 == "yes" ] ||  [ "$answer2" == "y" ] && [ $answer == "yes" ] ||  [ "$answer" == "y" ] 
        then
        echo "n
        p
        3
        
        +${Swap}
        w
        " | fdisk ${DISK}
        elif  [ $answer == "no" ] ||  [ "$answer" == "n" ]  && [ $answer2 == "yes" ] ||  [ "$answer2" == "y" ] 
        then
        echo "n
        p
        2
        
        +${Swap}
        w
        " | fdisk ${DISK}
        fi 
            #### make file system for partion
    mkfs.ext4 "${DISK}1"
    if [ $answer == "yes" ] ||  [ "$answer" == "y" ]
        then
        mkfs.ext4 "${DISK}2"
        fi
    if [ $answer == "yes" ] ||  [ "$answer" == "y" ] 
        then
        mkswap "${DISK}3" #partition 4 (Swap)
        swapon "${DISK}3"
        elif [ $answer == "no" ] ||  [ "$answer" == "n" ]
        then
        mkswap "${DISK}2" #partition 4 (Swap)
        swapon "${DISK}2"
        fi 
            #### mount point
    mount "${DISK}1" /mnt
    #mkdir /mnt/boot
    #mount "${DISK}1" /mnt/boot
    if [ $answer == "yes" ] ||  [ "$answer" == "y" ]
        then
        mkdir /mnt/home
        mount "${DISK}2" /mnt/home
        fi

    lsblk
    sleep 15
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
    sleep 5
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
    elif [ "$Mode" == "$N2" ] # ----------if UFI-------------- #
    then
    clear
    #_____Determine the size of the root partition____#
    sgdisk -a 2048 -o ${DISK} # new gpt disk 2048 alignment
    clear
    echo -e "\nNote: Enter values in MB or GB on next step\n "

    read -p "Please enter size for root partition : " RooP
    clear
    #____Determine the size of the home partition___#
    while true
    do
    echo -e 
    read  -p "Please do you want create home part or not (y/n) : " answer
    if [ $answer == "yes" ] ||  [ "$answer" == "y" ] #if "Yes"
        then
        echo -e 
        read -p "Enter your /home partition size please : " Homep
        echo -e 
        break
        elif [ $answer == "no" ] ||  [ "$answer" == "n" ] #if "No"
        then
        
        break
        else 
        echo  "[+]Enter yes or no (y/n)[+]"
    fi
    done
    clear
    #_____Determine the size of the swap partition__#

    while true
    do
    echo -e ""
    read  -p "Please did you want create swap part or not (y/n) : " answer2
    if [ $answer2 == "yes" ] ||  [ "$answer2" == "y" ] #if "Yes"
        then
        echo -e 
        read -p "Enter your Swap partition size please : " Swap
        echo -e 

        break
        elif [ $answer2 == "no" ] ||  [ "$answer2" == "n" ] #if "No"
        then
        
        break
        else 
        echo  "[+]Enter yes or no (y/n)[+]"
    fi

    done


    clear
    sgdisk -n 1:0:+512M ${DISK}
    sgdisk -n 2:0:"+"$RooP""  ${DISK} 
    if [ $answer == "yes" ] ||  [ "$answer" == "y" ]
        then
        sgdisk -n 3:0:"+"$Homep"" ${DISK} #partition 3 (/home)
        fi
    if [ $answer2 == "yes" ] ||  [ "$answer2" == "y" ] 
        then
        sgdisk -n 4:0:"+"$Swap"" ${DISK} #partition 4 (Swap)
        fi 
            #### make file system for partion
    mkfs.fat -F32 "${DISK}1"
    mkfs.ext4 "${DISK}2"
    if [ $answer == "yes" ] ||  [ "$answer" == "y" ]
        then
        mkfs.ext4 "${DISK}3"
        fi
    if [ $answer2 == "yes" ] ||  [ "$answer2" == "y" ] 
        then
        mkswap "${DISK}4" #partition 4 (Swap)
        swapon "${DISK}4"
        fi 
            #### mount point
    mount "${DISK}2" /mnt
    mkdir /mnt/boot
    mkdir /mnt/boot/efi
    mount "${DISK}1" /mnt/boot/efi
    if [ $answer == "yes" ] ||  [ "$answer" == "y" ]
        then
        mkdir /mnt/home
        mount "${DISK}3" /mnt/home
        fi

            
    clear

    #echo "--------------------------------------"
    #echo "-- Arch Install on Main Drive       --"
    #echo "--------------------------------------"
    #pacstrap /mnt --noconfirm base base-devel linux linux-firmware vim nano sudo
    #genfstab -U /mnt >> /mnt/etc/fstab
    #mv ~/arc/step2.sh /mnt/
    #chmod a+x /mnt/step2.sh
    #echo "$DISK" > /mnt/ID
    #echo "$Mode" > /mnt/GrubID
    #clear
    #echo "-------------------------------------------------------------"
    #echo "--    you should run step 2 after it be ready (./step2)  --"
    #echo "-------------------------------------------------------------"
    #sleep 8
    #echo -e "\n----------------------------"
    #echo    "------   it ready !!    ----"
    #echo    "----------------------------"
    #arch-chroot /mnt 

    #---After arch-chroot---#
    #umount -R /mnt

    echo "--------------------------------------"
    echo "--   SYSTEM READY FOR FIRST BOOT    --"
    echo "--------------------------------------"
    echo "--          reboot now              --"
    break

    
fi

done
