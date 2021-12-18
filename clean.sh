os=`cat /etc/*-release | grep "PRETTY_NAME" | sed 's/PRETTY_NAME=//g'`
if [ "${os}" != '"Arch Linux"' ]; then
    echo "You must be using Arch Linux to execute this script."
    elif [ "${os}" == '"Arch Linux"' ]; then
    clear
    root=`whoami`
    case $root in

        "root")
            echo  -e "\n---------------------------------------"
            echo  "Installing packages (for next steps)..."
            echo  -e "---------------------------------------\n"
            rm -rf /var/lib/pacman/db.lck
            pacman -S --noconfirm git micro nano vi vim 
            ### to make clean screen with limit trying 
            count=0
            max=3
            function clean_screen() {
                if [ "$count" -eq "$max" ]; then
                    clear
                    count=`expr $count - 3`
                    fi
            }
            clear
            function Keyboard() {

                while true
                    do
                    echo -e "\n[+] Note: that if you've run a script before. [+]"
                    echo "make sure you don't repeat the keyboard layout at the top of the file selected /etc/locale.gen'. "
                    echo -e "\nPress Enter To Continue"
                    read CN #Confirm Note
                    case $CN in 
                        "")
                            clear
                            while true
                                do 

                                echo -e "\n====================================="
                                echo "[---]   Keyboard Layout Menu    [---]"
                                echo -e "=====================================\n"
                                read -p "The Default keyboard Layout (EN) Do You Want To Add Another Layout [Y/N]  : " AK #ASK KEY
                                case $AK in 

                                    y|Y|yes|Yes|YES)  
                                    clear
                                        while true
                                            do
                                            echo -e "\n====================================="
                                            echo "[---]   Keyboard Layout Menu    [---]"
                                            echo -e "=====================================\n"
                                            echo "+[1] AR +"
                                            echo "+[2] RU +"
                                            echo "+[3] FR +"
                                            echo -e
                                            read -p "Choose a Number Or Enter ['A'] To show more Layouts : " KEY
                                            if [ "$KEY" == "1" ] ; then 
                                                sed -i '/# lists of locales/a ar_AE.UTF-8 UTF-8' /etc/locale.gen
                                                break
                                                elif [ "$KEY" == "2" ] 
                                                then
                                                sed -i '/# lists of locales/a ru_RU.UTF-8 UTF-8' /etc/locale.gen
                                                break
                                                elif  [ "$KEY" == "3" ]
                                                then 
                                                sed -i '/# lists of locales/a fr_FR.UTF-8 UTF-8' /etc/locale.gen
                                                break
                                                elif [ "$KEY" == "A" ] || [ "$KEY" == "a" ]; then
                                                    clear
                                                    while true
                                                        do 
                                                        echo -e  ""
                                                        echo -e "Now Choose Your Editor And Remove '#' From Your Layout And Save File And Exit\n"
                                                        #EDIT KEY
                                                        echo -e ""
                                                        echo "[-] nano"
                                                        echo "[-] vi"
                                                        echo "[-] vim"
                                                        echo "[-] micro"
                                                        echo -e""
                                                        read -p "your choice : " EK #EDIT KEY
                                                        case $EK in 
                                                            "nano"|"vi"|"vim"|"micro")
                                                                clear
                                                                while true
                                                                    do 
                                                                    echo "[+] Note that if you edit the file before, make sure you don't repeat the key layout in the top of the file. [+]"
                                                                    echo -e "\nPress Enter to Contine"
                                                                    read Confirm
                                                                    case $Confirm in 
                                                                        "")
                                                                            
                                                                                $EK /etc/locale.gen 
                                                                                while true
                                                                                    do
                                                                                    clear
                                                                                    echo -e "\n"
                                                                                    read -p "Please Confirm Changes [y/n] : " CONF #CONF
                                                                                    case $CONF in 
                                                                                        y|Y|yes|Yes|YES)
                                                                                            break ;;
                                                                                        n|N|no|No|NO)
                                                                                            sleep 3
                                                                                            clear 
                                                                                            break;;
                                                                                        *)
                                                                                            echo -e "\n[+] ENTER 'Yes' or 'No' !!! [+]\n"
                                                                                            count=`expr $count + 1` 
                                                                                            sleep 1 
                                                                                            clean_screen  ;;
                                                                                    esac
                                                                                done 
                                                                                break ;;
                                                                            *)
                                                                                clear ;;
                                                                    esac
                                                                done
                                                                break
                                                                ;;
                                                            "")
                                                                echo -e "\n[-] Type one of them [-]\n" 
                                                                count=`expr $count + 1`
                                                                clean_screen ;;

                                                            *)
                                                                echo -e "\n[-] Enter Valid Value !![-]\n" 
                                                                count=`expr $count + 1`
                                                                clean_screen ;;
                                                        esac
                                                                

                                                                            
                                                    done
                                                    break
                                                else
                                                sleep 1
                                                echo -e "\n[+] Choose Any one of options !!! [+]\n"
                                                count=`expr $count + 1`
                                                clean_screen
                                            fi
                                    
                                        #clear
                                        done
                                        break
                                        ;; 

                                    n|N|no|No|NO) 
                                        
                                        break ;;
                                    *)  
                                        sleep 1
                                        echo -e ""
                                        echo "[-]Enter Yes or No !!! [-] "
                                        echo -e ""
                                        count=`expr $count + 1`
                                        clean_screen
                                        ;;

                                esac 
                            done
                            echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen 
                            break ;;
                        *)
                            clear ;;
                    esac
                    

                    
                done
            }
            Keyboard
            clear
            localectl --no-ask-password set-locale LANG="en_US.UTF-8" LC_TIME="en_US.UTF-8"

            # Set keymaps
            localectl --no-ask-password set-keymap us


            while true
            do
            echo -e "\n============================="
            echo "[---]    Host Setup     [---]"
            echo -e "=============================\n"
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
            echo -e "\n=================================="
            echo "[---]     Network Setup      [---]"
            echo -e "==================================\n"

            pacman -S networkmanager dhclient --noconfirm --needed
            systemctl enable --now NetworkManager
            clear
            ####################################################
            function add_user() {
                clear
                echo -e "\n=================================="
                echo "[---]     User creation      [---]"
                echo -e "==================================\n"
                username=""
                echo -e "\n"
                while [ x$username = "x" ]; do

                read -p "Please Enter the Username You Wish To Create : " username
                if [ "${username}" == "" ]; then
                    echo -e "\n[-] Enter Something [-]\n"
                    count=`expr $count + 1`
                    clean_screen
                elif id -u $username >/dev/null 2>&1; then

                echo -e "\n[+]User already exists[+] "
                count=`expr $count + 1`
                clean_screen
                username=""

                fi

                done
                group=""
                echo -e "\n"
                while [ x$group = "x" ]; do

                read -p "Please Enter The Primary Group. If Group Not Exist, It Will Be Created : " group
                if [ "$group" == "" ]; then
                    echo -e "\n[-] Enter Something !! [-]\n"
                    count=`expr $count + 1`
                    clean_screen

                elif id -g $group >/dev/null 2>&1; then

                echo -e "\n[+]Group Exist[+] "
                count=`expr $count + 1`
                clean_screen
            
                else

                groupadd $group

                fi

                done
                echo -e "\n"
                read -p "Please Enter Bash [/bin/bash] : " bash

                if [ x"$bash" = "x" ]; then

                bash="/bin/bash"

                fi

                read -p "Please Enter Homedir [/home/$username] : " homedir

                if [ x"$homedir" = "x" ]; then

                homedir="/home/$username"

                fi
                function password() {
                
                    while true
                        do
                        echo -e ""
                        read -p "Enter New Password For User : " password1
                        read -p "Re-enter Password  : " password2
                        if [ "$password1" != "$password2" ] 
                            then
                            echo -e "\n[-]Two words that don't match, try again !!![-]\n"
                            count=`expr $count + 1`
                            clean_screen
                            elif [ "$password1" == "" ] &&  [ "$password2" == "" ] 
                            then
                            echo -e "\nDon't Leave It Blank, You Must Create a Password For Login "
                            count=`expr $count + 1`
                            clean_screen
                            elif [ "$password1" == "$password2" ]
                            then
                            echo  $username':'${password1} | chpasswd
                            break
                        fi
                    done
                }

            echo -e ""
                while true 
                    read -p "Please confirm [y/n] : " confirm
                    do 
                    case $confirm in 
                        y|Y|yes|Yes|YES)

                            useradd -g $group -s $bash -d $homedir -m $username
                            sed -i '/root ALL=(ALL) ALL/a '${username}' ALL=(ALL) ALL' /etc/sudoers 
                            password
                            break ;;
                        n|N|no|No|NO)

                            clear
                            add_user ;;
                        *)
                            echo -e "\n[-] Enter Yes or No [-]\n" 
                            count=`expr $count + 1`
                            clean_screen ;;
                    esac
                done
                
            }
            #add_user

            clear


            while true
                do
                echo -e "\n==============================="
                echo "[---]    USER ACCOUNT     [---]"
                echo -e "===============================\n"
                read -p  "do you want add new user : " user
                case $user in 
                    y|Y|yes|Yes|YES)

                        add_user
                        while true 
                            do
                            clear
                            echo -e "\n"
                            read -p "Do You Want Anthore User : " new_user 
                            case $new_user in 
                                y|Y|yes|Yes|YES)

                                    add_user
                                    ;;
                                n|N|no|No|NO)

                                    break ;;
                                *)  
                                    echo "[-]Enter Yes/No !!![-]" 
                                    count=`expr $count + 1`
                                    clean_screen ;;
                            esac
                        done
                        break
                        ;;
                        

                    n|N|no|No|NO)

                        echo "no"
                        break 
                        ;;
                    *)
                        echo -e "\n[-]Enter Yes/No !!![-]\n" 
                        count=`expr $count + 1`
                        clean_screen
                        ;;
                esac

            done



            while true
            do
            echo -e "\n===================================="
            echo "[---]  Set Password for Root   [---]"
            echo -e "====================================\n"
            read -p "Enter New Password For Root User : " passwd1
            read -p "Re-enter Password  : " passwd2
            if [ "$passwd1" != "$passwd2" ] 
                then
                echo -e "\n[+]Two words that don't match, try again !!![+]\n"
                count=`expr $count + 1`
                clean_screen
                elif [ "$passwd1" == "" ] &&  [ "$passwd2" == "" ] 
                then
                echo -e "\nDon't Leave It Blank, You Must Create a Root Password For First Login "
                count=`expr $count + 1`
                clean_screen
                elif [ "$passwd1" == "$passwd2" ]
                then
                echo 'root:'${passwd1} | chpasswd
                break
            fi
            done
            clear

            echo "=========================================="
            echo "[---]    Bootloader  Installation    [---]"
            echo "=========================================="
            pacman -S --noconfirm efibootmgr grub
            ID="`cat ID`"
            GrubID="`cat GrubID`"

            if [ "$GrubID" == "BIOS" ]; then  ######### IF IS BIOS MODE #######
                grub-install $ID 
                elif [ "$GrubID" == "UEFI" ]; then ### If Is Uefi MODE
                grub-install --target=x86_64-efi --efi--directory=/boot/efi --bootloader-id=GRUB --removable    
            fi
            grub-mkconfig -o /boot/grub/grub.cfg
            clear
            echo "-------------------------------------------------------------------------"
            echo "--                                                                   ----"
            echo "      Now Enter The 'exit' Command To Finish The Installation            "
            echo "--                                                                   ----"
            echo "-------------------------------------------------------------------------"
            sleep 3 
            exit ;;

        *)
            echo "[-]You Must Be a Root User To Successfully Complete a Process. !![-]" ;;
    esac
fi
