os=$(lsb_release -ds | sed 's/"//g')
if [ "${os}" != "Arch Linux" ]; then
    echo "You must be using Arch Linux to execute this script."
    break
    elif [ "${os}" == "Arch Linux" ]; then
    clear
    echo -e "\nInstalling git (for next steups)...\n"
    pacman -S --noconfirm git

    while true
    do
    echo "-------------------------------------------------"
    echo "-------       Keyboard Layout Menu      ---------"
    echo -e "-------------------------------------------------\n"
    echo "+[1] AR +"
    echo "+[2] EN +"
    echo "+[3] FR +"
    echo -e
    read -p "Enter Your Default Layout Keyboard (default==EN) : " KEY
    if [ "$KEY" == "1" ]
        then 
        echo "ar_AE.UTF-8 UTF-8" >> /etc/local.gen
        break
        elif [ "$KEY" == "2" ] ||  [ "$KEY" == "" ]
        then
        echo "en_US.UTF-8 UTF-8" >> /etc/local.gen
        break
        elif  [ "$KEY" == "3" ]
        then 
        echo "fr_FR.UTF-8 UTF-8" >> /etc/local.gen
        break
        else
        clear
        echo -e "\n[+]Choose Any Number Or Set The Default !!! [+]\n"
    fi
    done

    clear

    while true
    do
    echo "------------------------------------"
    echo "-------   Languages Menu      ------"
    echo -e "------------------------------------\n"
    echo "+ [1] Arabia  +"
    echo "+ [2] English +"
    echo "+ [3] French  +"
    echo -e
    read -p "Enter Your Language (default==EN) : " LANG
    if [ "$LANG" == "1" ]
        then 
        echo "LANG=ar_AE.UTF-8" > /etc/locale.conf
        break
        elif [ "$LANG" == "2" ] ||  [ "$LANG" == "" ]
        then
        echo "LANG=en_US.UTF-8" > /etc/locale.conf
        break
        elif  [ "$LANG" == "3" ] 
        then     
        echo "LANG=fr_FR.UTF-8" > /etc/locale.conf
        break
        else
        clear
        echo -e "\n[+]Choose Number or set default [+]\n"
    fi
    done
    clear

    echo "--------------------------------------"
    echo "--          Host Setup              --"
    echo "--------------------------------------"

    while true
    do
    read  -p "Enter your Host name (default==archPc) :" HostN
    if [ "$HostN" != "" ]
        then
        echo "$HostN" >> /etc/hostname
        echo "127.0.1.1	  localhost.localdomin	  $HostN" >> /etc/hosts
        break
        elif [ "$HostN" == "" ]
        then 
        echo "archPc" >> /etc/hostname
        echo "127.0.1.1	  localhost.localdomin	  archPc"  >> /etc/hosts
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

    while true
    do
    read -p "Enter New Password For Root User : " passwd1
    read -p "Re-enter Password  : " passwd2
    if [ "$passwd1" != "$passwd2" ] 
        then
        echo -e "\n[+]Two words that don't match, try again !!![+]\n"
        elif [ "$passwd1" == "" ] &&  [ "$passwd2" == "" ] 
        then
        echo -e "\nDon't leave it blank, you must create a root password for first login "
        elif [ "$passwd1" == "$passwd2" ]
        echo 'root:'${passwd1} | chpasswd
        break
    fi
    done
    clear

    echo "--------------------------------------"
    echo "-- Bootloader Systemd Installation  --"
    echo "--------------------------------------"
    pacman -S --noconfirm efibootmgr grub
    ID="`cat ID`"
    GrubID="`cat GrubID`"

    if [ "$GrubID" == "1" ]  ######### IF IS BIOS MODE #######
        then
        grub-install $ID 
        elif [ "$GrubID" == "2" ] ### If Is Uefi MODE
        then
        grub-install --target=x86_64-efi --efi--directory=/boot/efi --bootloader-id=GRUB --removable 
        else
        echo ""   
    fi
    grub-mkconfig -o /boot/grub/grub.cfg
    clear
    echo "-------------------------------------------------------------------------"
    echo "--                                                                   ----"
    echo "      Now Enter The 'exit' Command To Finish The Installation            "
    echo "--                                                                   ----"
    echo "-------------------------------------------------------------------------"
    sleep 3 
    exit
fi
