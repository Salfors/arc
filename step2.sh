clear
echo -e "\nInstalling git (for next steups)...\n"
pacman -S --noconfirm git

echo "en_US.UTF-8 UTF-8" >> /etc/local.gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
clear
echo "--------------------------------------"
echo "--          Host Setup              --"
echo "--------------------------------------"

while true
do
read  -p "Enter your Host name (default==archPc) :" HostN
if [ "$HostN" != "" ]
    then
    echo "127.0.1.1	  localhost.localdomin	  $HostN" 
    break
    elif [ "$HostN" == "" ]
    then 
    echo "127.0.1.1	  localhost.localdomin	  archPc" 
    break
     
fi

done

clear
echo "--------------------------------------"
echo "--          Network Setup           --"
echo "--------------------------------------"

pacman -S networkmanager dhclient --noconfirm --needed
systemctl enable --now NetworkManager
clear
echo "--------------------------------------"
echo "--      Set Password for Root       --"
echo "--------------------------------------"
echo "Enter password for root user: "
passwd root
clear

echo "--------------------------------------"
echo "-- Bootloader Systemd Installation  --"
echo "--------------------------------------"
pacman -S --noconfirm efibootmgr grub

ID="`cat ID`"
GrubID="`cat GrubID`"

if [ "$GrubID" == "1" ]
    then
    grub-install $ID 
    elif [ "$GrubID" == "2" ]
    then
    grub-install --target=x86_64-efi --efi--directory=/boot/efi --bootloader-id=GRUB --removable 
    else
    echo ""
    
fi
grub-mkconfig -o /boot/grub/grub.cfg
clear
echo "-------------------------------------------------------------------------"
echo "--                                                                   ----"
echo "      Now enter the exit command because it is the installation          "
echo "--                                                                   ----"
echo "-------------------------------------------------------------------------"
sleep 5 
exit
