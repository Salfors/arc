echo -e "\nInstalling prereqs...\n"
pacman -S --noconfirm gptfdisk btrfs-progs

echo "-------------------------------------------------"
echo "-------select your disk to format----------------"
echo "-------------------------------------------------"
lsblk
echo "Please enter disk: (example /dev/sda)"
read DISK
echo "--------------------------------------"
echo -e "\nFormatting disk...\n"
echo "--------------------------------------"
echo -e "\nNote: Enter values in MB on next step will input be like that =58M"
# disk prep
sgdisk -Z ${DISK} # zap all on disk
sgdisk -a 2048 -o ${DISK} # new gpt disk 2048 alignment

# create partitions
sgdisk -n 1:0:+1000M ${DISK} # partition 1 (UEFI SYS), default start block, 512MB
echo "Please enter size for root partition"
read RooP

sgdisk -n 2:0:"+"$RooP""   ${DISK} # partition 2 (Root), default start, remaining

echo -e "\nPlease do you want create home part or not "
read  -p "your answer " answer
if [ $answer == "yes" ]
then
    echo -e "\nEnter your /home partition size please"
    read Homep   
    sgdisk -n 3:0:"+"$Homep"" ${DISK} #partition 3 (/home)
    echo -e 
    sgdisk -c 3:"Home" ${DISK}
    mkfs.ext4 -L "Home" "${DISK}3"





else 
 

    echo "Ok no problem " 
  
fi
echo -e "\nPlease did you want create swap part or not"
read  -p "your answer " answer2
if [ $answer2 == "yes" ]
then
    echo -e "\nEnter your Swap partition size please"
    read Swap
    sgdisk -n 4:0:"+"$Swap"" ${DISK} #partition 4 (Swap)
    echo -e 
    sgdisk -c :"Swap" ${DISK}
    mkswap -L "Swap" "${DISK}4"
    swapon "Swap" "${DISK}4"

else 
 

    echo "Ok no problem " 
  
fi

# label partitions
sgdisk -c 1:"UEFISYS" ${DISK}
sgdisk -c 2:"ROOT" ${DISK}

# make filesystems
echo -e "\nCreating Filesystems...\n"


mkfs.fat -F32 -n "UEFISYS" "${DISK}1"
mkfs.ext4 -L "ROOT" "${DISK}2"

# mount target
#mkdir /mnt
mount -t ext4 "${DISK}2" /mnt
#mkdir /mnt/boot
mkdir /mnt/boot/efi
mount "${DISK}1" /mnt/boot/efi

if [ $answer == "yes" ]
then
    mkdir /mnt/home
    mount "${DISK}3" /mnt/home

else 
 
    echo "" 
fi 
echo "--------------------------------------"
echo "-- Arch Install on Main Drive       --"
echo "--------------------------------------"
#pacstrap /mnt --noconfirm base base-devel linux linux-firmware vim nano sudo
#genfstab -U /mnt >> /mnt/etc/fstab
mv /arc/step2.sh/ /mnt
chmod a+x /mnt/arc/step2.sh
arch-chroot /mnt 

umount -R /mnt

echo "--------------------------------------"
echo "--   SYSTEM READY FOR FIRST BOOT    --"
echo "--------------------------------------"
echo "--          reboot now              --"
