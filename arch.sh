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
sgdisk -n 0:0:+1000M ${DISK} # partition 1 (UEFI SYS), default start block, 512MB
echo "Please enter size for root partition"
read RooP

sgdisk -n 2:0:"+"$RooP""   ${DISK} # partition 2 (Root), default start, remaining

echo -e "\nPlease do you want create home part or not "
read  -p "your answer " answer
if [ $answer == "yes" ]
then
    echo -e "\nEnter your /home partition size please"
    read Homep   
    echo sgdisk -n 3:0:"+"$Homep"" ${DISK} #partition 3 (/home)
    echo -e 

else 
 

    echo "Ok no problem " 
  
fi
echo -e "\nPlease did you want create swap part or not"
read  -p "your answer " answer2
if [ $answer2 == "yes" ]
then
    echo -e "\nEnter your Swap partition size please"
    read Swap
    echo sgdisk -n 4:0:"+"$Swap"" ${DISK} #partition 4 (Swap)
    echo -e 

else 
 

    echo "Ok no problem " 
  
fi
