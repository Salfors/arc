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
    fi

    done
########## CREAT PARTION BIOS ########

    clear
    echo "w
    " | fdisk ${DISK}
    #echo ';' | sfdisk ${DISK}
     
    echo "n
    p
    1
    
    +${RooP}
    w
    " | fdisk ${DISK}
    #sgdisk -n 1:0:+512M ${DISK}
    #sgdisk -n 2:0:"+"$RooP""  ${DISK} 
    if [ "$answer" == "yes" ] ||  [ "$answer" == "y" ] && [ "$answer2" == "yes" ] ||  [ "$answer2" == "y" ]
        then
        echo "n
        p
        1
    
        +${RooP} ############# root part
        w
        " | fdisk ${DISK}
        echo "n
        p
        2
        
        +${HomeP} ############### home part
        w
        " | fdisk ${DISK}
        echo "n
        p
        3
        
        +${Swap} ############## swap part
        " | fdisk ${DISK}
        elif [ "$answer2" == "yes" ] ||  [ "$answer2" == "y" ] && [ "$answer" == "no" ] ||  [ "$answer" == "n" ] #if "No"
        then
        echo "n
        p
        1
    
        +${RooP} ########################### root part without  home 
        w
        " | fdisk ${DISK}
        echo "n
        p
        2
        
        +${Swap} ######################## Swap part
        w
        " | fdisk ${DISK}
        
        
    fi ## answer1 
    break
         
           

    
fi

done
