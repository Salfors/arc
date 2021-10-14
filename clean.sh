#------In order to partition a disk----#
echo -e "\nInstalling prereqs...\n"
pacman -S --noconfirm gptfdisk btrfs-progs
clear
echo "-------------------------------------------------"
echo "-------select your disk to format----------------"
echo "-------------------------------------------------"
lsblk
count=1
max=4
while true
do
echo -e "\nPlease enter disk: (example /dev/sda)\n"
read DISK
if [ "$DISK" == "" ] 
    then
    echo -e "\n[+]Choose the disk to install to !!![+]\n"
    count=`expr $count + 1`
    if [ "$count" -eq "$max" ]
    then
    clear
    count=`expr $count - 4`
    fi
    else 
    break
    
fi
done
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
    echo -e "\nNote: Enter values in 'MB' or 'GB' on next step\n "

    while true
    do
    read -p "Please enter size for root partition : " RooP
    if [ "$RooP" == "" ] #if "Yes"
        then
        echo -e "\n[+]You must enter root partition size !!![+]\n"
        count=`expr $count + 1`
        else 
        break
        if [ "$count" -eq "$max" ]
        then
        clear
        count=`expr $count - 4`
        fi
    fi
    done

    clear
    #____Determine the size of the home partition___#
    while true
    do
    echo -e 
    read  -p "Please do you want create home part or not (y/n) : " answer
    if [ "$answer" == "yes" ] ||  [ "$answer" == "y" ] #if "Yes"
        then
        echo -e 
        read -p "Enter your /home partition size please :" Homep
        echo -e 
        break
        elif [ "$answer" == "no" ] ||  [ "$answer" == "n" ] #if "No"
        then
        break
        else 
        echo  "[+]Enter yes or no (y/n)[+]"
        count=`expr $count + 1`
        if [ "$count" -eq "$max" ]
        then
        clear
        count=`expr $count - 4`
        fi
    fi
    done
    clear
    #_____Determine the size of the swap partition__#

    while true
    do
    echo -e ""
    read  -p "Please did you want create swap part or not (y/n) : " answer2
    if [ "$answer2" == "yes" ] ||  [ "$answer2" == "y" ] #if "Yes"
        then
        echo -e 
        read -p "Enter your Swap partition size please : " Swap
        echo -e 

        break
        elif [ "$answer2" == "no" ] ||  [ "$answer2" == "n" ] #if "No"
        then        
        break
        else 
        echo  "[+]Enter yes or no (y/n)[+]"
        count=`expr $count + 1`
        if [ "$count" -eq "$max" ]
        then
        clear
        count=`expr $count - 4`
        fi
    fi

    done
########## CREAT PARTION BIOS ########

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

    if [ "$answer" == "yes" ] || [ "$answer" == "y" ] && [ "$answer2" == "yes" ] || [ "$answer2" == "y" ]
        then ########for check input if is string or int (10GB) or (10)only
        if  [ -z "${Homep##*[!0-9]*}" ] && [ -z "${Swap##*[!0-9]*}" ];
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
            elif [ -z "${Homep//[0-9]/}" -a ! -z "$Homep" ] && [ -z "${Swap//[0-9]/}" -a ! -z "$Swap" ];
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
            fi #####if  
##################
        elif [ "$answer" == "no" ] || [ "$answer" == "n" ] && [ "$answer2" == "yes" ] || [ "$answer2" == "y" ]
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
            fi ########if 
        ######
        elif [ "$answer" == "yes" ] || [ "$answer" == "y" ] && [ "$answer2" == "no" ] || [ "$answer2" == "n" ]
        then 
        if  [ -z "${Homep##*[!0-9]*}" ]; ##########str
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

    #### make file system for partion
    mkfs.ext4 "${DISK}1"
    if [ "$answer" == "yes" ] ||  [ "$answer" == "y" ] && [ "$answer2" == "yes" ] ||  [ "$answer2" == "y" ]
        then
        mkfs.ext4 "${DISK}2"
        mkswap "${DISK}3" #partition 4 (Swap)
        swapon "${DISK}3"

        elif [ $answer == "no" ] ||  [ "$answer" == "n" ] && [ "$answer2" == "yes" ] ||  [ "$answer2" == "y" ]
        then
        mkswap "${DISK}2" #partition 4 (Swap)
        swapon "${DISK}2"
        fi 
            #### mount point
    mount "${DISK}1" /mnt
    if [ $answer == "yes" ] ||  [ "$answer" == "y" ]
        then
        mkdir /mnt/home
        mount "${DISK}2" /mnt/home
        fi

    lsblk
    echo -e "\n"
    echo "----------------------------------------------------------"
    echo "--   If you did not do the division correctly      -------"
    echo "--           Stop Script with (CTRL + Z)           -------"
    echo " Then enter the command 'umount -R' and try again   ------"
    echo "               Or reboot and try again ..            -----"
    echo "----------------------------------------------------------"
    sleep 20
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
    sleep 4
    echo -e "\n----------------------------"
    echo    "------   it ready !!    ----"
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
    elif [ "$Mode" == "$N2" ] # ----------if UFI-------------- ----------------------------------------------#
    then
    clear
    #_____Determine the size of the root partition____#
    echo -e "\nNote: Enter values in MB or GB on next step\n "

    while true
    do
    read -p "Please enter size for root partition : " RooP
    if [ "$RooP" == "" ] #if "Yes"
        then
        echo -e "\n[+]You must enter root partition size !!![+]\n"
        count=`expr $count + 1`
        if [ "$count" -eq "$max" ]
        then
        clear
        count=`expr $count - 4`
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
        count=`expr $count + 1`
        if [ "$count" -eq "$max" ]
        then
        clear
        count=`expr $count - 4`
        fi
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
    ####
    if [ "$answer" == "yes" ] || [ "$answer" == "y" ] && [ "$answer2" == "yes" ] || [ "$answer2" == "y" ]
        then ########for check input if is string or int (10GB) or (10)only
        if  [ -z "${Homep##*[!0-9]*}" ] && [ -z "${Swap##*[!0-9]*}" ];
            then  
            sgdisk -n 3:0:+${Homep} ${DISK}    ####### 
            sgdisk -n 4:0:+${Swap} ${DISK} ####
            
            elif [ -z "${Homep//[0-9]/}" -a ! -z "$Homep" ] && [ -z "${Swap//[0-9]/}" -a ! -z "$Swap" ];
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
            fi #####if  
        ##################
        elif [ "$answer" == "no" ] || [ "$answer" == "n" ] && [ "$answer2" == "yes" ] || [ "$answer2" == "y" ]
        then 
        if  [ -z "${Swap##*[!0-9]*}" ]; 
            then  
            sgdisk -n 3:0:+${Swap} ${DISK}     
    
            elif [ -z "${Swap//[0-9]/}" -a ! -z "$Swap" ]; 
            then
            sgdisk -n 3:0:+${Swap}GB ${DISK}    
            fi 
        ######
        elif [ "$answer" == "yes" ] || [ "$answer" == "y" ] && [ "$answer2" == "no" ] || [ "$answer2" == "n" ]
        then 
        if  [ -z "${Homep##*[!0-9]*}" ]; ##########str
            then  
            sgdisk -n 3:0:+${Homep} ${DISK}     
            
            elif [ -z "${Homep//[0-9]/}" -a ! -z "$Homep" ]; 
            then 
            sgdisk -n 3:0:+${Homep}GB ${DISK}
            fi
        fi
            #### make file system for partion
    mkfs.fat -F32 "${DISK}1"
    mkfs.ext4 "${DISK}2"
    if [ $answer == "yes" ] ||  [ "$answer" == "y" ] && [ $answer2 == "yes" ] ||  [ "$answer2" == "y" ]
        then
        mkfs.ext4 "${DISK}3"
        mkswap "${DISK}4" #partition 4 (Swap)
        swapon "${DISK}4"
        elif [ $answer == "no" ] ||  [ "$answer" == "n" ] && [ $answer2 == "yes" ] ||  [ "$answer2" == "y" ]
        then
        mkswap "${DISK}3" #partition 4 (Swap)
        swapon "${DISK}3"
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

    lsblk
    echo -e "\n"
    echo "----------------------------------------------------------"
    echo "--   If you did not do the division correctly      -------"
    echo "--           Stop Script with (CTRL + Z)           -------"
    echo " Then enter the command 'umount -R' and try again   ------"
    echo "               Or reboot and try again ..            -----"
    echo "----------------------------------------------------------"
    sleep 20
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
    sleep 3
    echo -e "\n----------------------------"
    echo    "------   it ready !!    ----"
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

    
fi

done
